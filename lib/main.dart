import 'package:get/get.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:s3_storage/s3_storage.dart';

import 'env.dart';
import 'services/database.dart';
import 'services/bucket_service.dart';
import 'services/player_service.dart';
import 'components/artist_tile.dart';
import 'components/album_tile.dart';
import 'components/player_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(LocalDB());
  Get.put(S3Storage(
      endPoint: Env.s3Endpoint,
      accessKey: Env.accessKey,
      secretKey: Env.secretKey,
      signingType: SigningType.V4));
  Get.put(AudioPlayer());
  Get.put(MusicBucketsService());
  Get.put(PlayerService());
  await AudioService.init<PlayerService>(
    builder: () => Get.find(),
    config: const AudioServiceConfig(
        androidShowNotificationBadge: true,
        androidNotificationChannelId: 'com.example.polify.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
        notificationColor: Colors.black),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PolifyV2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
          useMaterial3: true,
          textTheme: Typography.whiteCupertino,
          scaffoldBackgroundColor: Colors.black),
      home: const MyHomePage(title: 'PolifyV2'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Stream<List<MusicBucket>>? buckets;
  S3Storage s3Storage = Get.find();
  LocalDB db = Get.find();
  MusicBucketsService srv = Get.find();
  PlayerService player = Get.find();

  Stream<List<Artist>>? artists;
  Stream<List<Album>>? albums;
  Stream<List<Song>>? songs;

  bool _loading = false;
  final Map<String, bool> _bucketCrawling = {};
  @override
  void initState() {
    super.initState();
    buckets = db.musicBuckets.all().watch();
    artists = db.artists.all().watch();
    albums = db.albums.all().watch();
    songs = db.songs.all().watch();
    _init();
  }

  Future _init() async {
    await srv.loadBuckets();
    setState(() {
      for (var element in srv.buckets) {
        _bucketCrawling[element.name] = false;
      }
    });
  }

  void onAlbumPlay(Album album, bool now) async => {
        await player.playAlbum(
          album,
          replaceCurrent: now,
        ),
        setState(() {})
      };

  void onArtistPlay(Artist artist, bool now) async => {
        await player.playArtist(
          artist,
          replaceCurrent: now,
        ),
        setState(() {})
      };

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      backgroundColor: Colors.black,
      actions: [
        FloatingActionButton(
          mini: true,
          heroTag: "refreshBucket",
          onPressed: () async => {
            _loading
                ? ()
                : setState(() {
                    _loading = true;
                  }),
            await srv.loadBuckets(),
            setState(() {
              _loading = false;
            })
          },
          tooltip: 'Refresh',
          child: _loading
              ? const CircularProgressIndicator()
              : const Icon(Icons.refresh),
        ),
        FloatingActionButton(
          mini: true,
          heroTag: "cleanAll",
          child: const Icon(Icons.delete_forever_outlined),
          onPressed: () => deleteEverything(db),
        ),
      ],
      title: Text(
        widget.title,
        style: const TextStyle(color: Colors.white),
      ),
    );
    return Scaffold(
      appBar: appBar,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text("Buckets"),
          StreamBuilder(
            stream: buckets,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('Error ${snapshot.data.toString()}');
                } else if (snapshot.hasData) {
                  return SizedBox(
                    height: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height) /
                        10,
                    // width: 200,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: snapshot.data!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => SizedBox(
                        width: MediaQuery.of(context).size.width - 80,
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 2, color: Colors.white),
                              borderRadius: BorderRadius.circular(10)),
                          leading: const Icon(Icons.storage_rounded),
                          trailing: _bucketCrawling[
                                          snapshot.data![index].name] !=
                                      null &&
                                  _bucketCrawling[snapshot.data![index].name]!
                              ? Transform.scale(
                                  scale: 0.5,
                                  child: const CircularProgressIndicator(),
                                )
                              : null,
                          onTap: () async => _bucketCrawling[
                                          snapshot.data![index].name] !=
                                      null &&
                                  !_bucketCrawling[snapshot.data![index].name]!
                              ? {
                                  setState(() {
                                    _bucketCrawling[
                                        snapshot.data![index].name] = true;
                                  }),
                                  await srv
                                      .saveSongs(snapshot.data![index].name),
                                  setState(() {
                                    _bucketCrawling[
                                        snapshot.data![index].name] = false;
                                  }),
                                }
                              : null,
                          title: Text(snapshot.data![index].name),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Text('Empty data');
                }
              } else {
                return Text('State: ${snapshot.connectionState}');
              }
            },
          ),
          const Text("Artists"),
          StreamBuilder(
            stream: artists,
            key: const Key("artists_stream"),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('Error ${snapshot.data.toString()}');
                } else if (snapshot.hasData) {
                  return SizedBox(
                    height: 60,
                    key: const Key("artists"),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: artistListTile(
                            snapshot.data![index], (artist, now) {}),
                      ),
                    ),
                  );
                } else {
                  return const Text('Empty data');
                }
              } else {
                return const Center(child: Text('Select a bucket above'));
              }
            },
          ),
          const Text("Albums"),
          Expanded(
            child: StreamBuilder(
              stream: albums,
              key: const Key("albums_stream"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text('Error ${snapshot.data.toString()}');
                  } else if (snapshot.hasData) {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      clipBehavior: Clip.antiAlias,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        // return albumListTile(snapshot.data![index],
                        //     onAlbumPlayAfter, onAlbumPlayNow);
                        return albumCardTile(
                            snapshot.data![index], onAlbumPlay);
                      },
                    );
                  } else {
                    return const Text('Empty data');
                  }
                } else {
                  return const Center(child: Text('Select a bucket above'));
                }
              },
            ),
          ),
          player.player.source == null ? Container() : PlayerWidget()
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
