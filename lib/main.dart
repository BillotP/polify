import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:polify/album.dart';
import 'package:polify/artist.dart';
import 'package:polify/bucket_service.dart';
import 'package:polify/player_service.dart';
import 'package:polify/player_widget.dart';
import 'package:s3_storage/s3_storage.dart';
import 'package:get/get.dart';

import 'database.dart';
import 'env.dart';

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
    config: AudioServiceConfig(
        androidShowNotificationBadge: true,
        androidNotificationChannelId: 'com.example.polify.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
        notificationColor: Colors.amber[900]),
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

  @override
  void dispose() {
    super.dispose();
    // player.dispose();
    // player.player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      // backgroundColor: Theme.of(context).colorScheme.background,
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
                        6,
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => ListTile(
                        leading: const Icon(Icons.storage_rounded),
                        trailing: _bucketCrawling[snapshot.data![index].name] !=
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
                                  _bucketCrawling[snapshot.data![index].name] =
                                      true;
                                }),
                                await srv.saveSongs(snapshot.data![index].name),
                                setState(() {
                                  _bucketCrawling[snapshot.data![index].name] =
                                      false;
                                }),
                              }
                            : print("supposedly loading ..."),
                        title: Text(snapshot.data![index].name),
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
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('Error ${snapshot.data.toString()}');
                } else if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => ListTile(
                        leading: snapshot.data![index].imageUrl != null
                            ? Image.network(snapshot.data![index].imageUrl!)
                            : const Icon(Icons.person_3_outlined),
                        title: Text(snapshot.data![index].name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () async => {
                                      await player
                                          .playArtist(snapshot.data![index]),
                                      setState(
                                        () {},
                                      )
                                    },
                                icon: const Icon(Icons.play_circle_fill)),
                            IconButton(
                                onPressed: () async => {
                                      await player.playArtist(
                                          snapshot.data![index],
                                          replaceCurrent: false),
                                      setState(() {})
                                    },
                                icon: const Icon(Icons.playlist_add))
                          ],
                        ),
                        onTap: () =>
                            Get.to(ArtistWidget(artist: snapshot.data![index])),
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
          StreamBuilder(
            stream: albums,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('Error ${snapshot.data.toString()}');
                } else if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => ListTile(
                        leading: snapshot.data![index].imageUrl != null
                            ? Image.network(snapshot.data![index].imageUrl!)
                            : const Icon(Icons.album_sharp),
                        title: Text(snapshot.data![index].name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () async => {
                                      await player.playAlbum(
                                        snapshot.data![index],
                                        replaceCurrent: true,
                                      ),
                                      setState(() {})
                                    },
                                icon: const Icon(Icons.play_circle_fill)),
                            IconButton(
                                onPressed: () async => {
                                      await player.playAlbum(
                                          snapshot.data![index],
                                          replaceCurrent: false),
                                      setState(() {})
                                    },
                                icon: const Icon(Icons.playlist_add))
                          ],
                        ),
                        onTap: () =>
                            Get.to(AlbumWidget(album: snapshot.data![index])),
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
          player.player.source == null ? Container() : PlayerWidget()
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
