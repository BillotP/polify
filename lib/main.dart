import 'dart:io';

import 'package:get/get.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:polify/components/bucket_tile.dart';
import 'package:polify/components/current_playlist_widget.dart';
// import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:s3_storage/s3_storage.dart';

import 'env.dart';
import 'services/database.dart';
import 'services/bucket.dart';
import 'services/player.dart';
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
        androidNotificationChannelId: 'lol.polify.polify.channel.audio',
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
          useMaterial3: true,
          // iconTheme: const IconThemeData(color: Colors.orangeAccent),
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
  int _selectedIndex = 0;
  bool _crawlMetarunning = false;
  final Map<String, bool> _bucketCrawling = {};

  List<Widget> _widgets(Stream<List<MusicBucket>>? buckets,
          Stream<List<Artist>>? artists, Stream<List<Album>>? albums) =>
      [
        Expanded(
          child: StreamBuilder(
            stream: buckets,
            key: const Key("buckets_stream"),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('Error ${snapshot.data.toString()}');
                } else if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return const Center(
                      child:
                          Text("Click on refresh button above to list buckets"),
                    );
                  }
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: Platform.isAndroid ? 1 : 2),
                    clipBehavior: Clip.antiAlias,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) => bucketCardTile(
                        snapshot.data![index],
                        _bucketCrawling[snapshot.data![index].name] != null &&
                            _bucketCrawling[snapshot.data![index].name]!,
                        onRefreshBucketContent),
                  );
                } else {
                  return const Center(
                    child:
                        Text("Click on refresh button above to list buckets"),
                  );
                }
              } else {
                return Text('State: ${snapshot.connectionState}');
              }
            },
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: artists,
            key: const Key("artists_stream"),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('Error ${snapshot.data.toString()}');
                } else if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              "No artists found, click on refresh button for a bucket in 'Buckets' page first.",
                              textScaleFactor: 2,
                            ),
                          ),
                          Expanded(child: Container()),
                          const Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Icon(
                              Icons.arrow_downward_sharp,
                              size: 30,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: Platform.isAndroid ? 2 : 3),
                    clipBehavior: Clip.antiAlias,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) =>
                        artistCardTile(snapshot.data![index], onArtistPlay),
                  );
                } else {
                  return const Text('Empty data');
                }
              } else {
                return const Center(
                    child: Text(
                        'Click on a bucket card refresh symbol to crawl for songs'));
              }
            },
          ),
        ),
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
                  if (snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              "No albums found, click on refresh button for a bucket in 'Buckets' page first.",
                              textScaleFactor: 2,
                            ),
                          ),
                          Expanded(child: Container()),
                          const Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Icon(
                              Icons.arrow_downward_sharp,
                              size: 30,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: Platform.isAndroid ? 2 : 3),
                    clipBehavior: Clip.antiAlias,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return albumCardTile(snapshot.data![index], onAlbumPlay);
                    },
                  );
                } else {
                  return const Text('Empty data');
                }
              } else {
                return const Center(
                    child: Text(
                        'Click on a bucket card refresh symbol to crawl for songs'));
              }
            },
          ),
        ),
        Expanded(
            child: StreamBuilder(
          stream: songs,
          key: const Key("songs_stream"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text('Error ${snapshot.data.toString()}');
              } else if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            "No songs found, click on refresh button for a bucket in 'Buckets' page first.",
                            textScaleFactor: 2,
                          ),
                        ),
                        Expanded(child: Container()),
                        const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Icon(
                            Icons.arrow_downward_sharp,
                            size: 30,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  clipBehavior: Clip.antiAlias,
                  shrinkWrap: true,
                  // controller: _songPageScrollcontroller,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        snapshot.data![index].title,
                        style: const TextStyle(color: Colors.white),
                      ),
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () =>
                                  onSongPlay(snapshot.data![index], true),
                              icon: const Icon(Icons.play_arrow_sharp)),
                          IconButton(
                              onPressed: () =>
                                  onSongPlay(snapshot.data![index], false),
                              icon: const Icon(Icons.playlist_add_outlined))
                        ],
                      ),
                    );
                  },
                );
              } else {
                return const Text('Empty data');
              }
            } else {
              return const Center(
                  child: Text(
                      'Click on a bucket card refresh symbol to crawl for songs'));
            }
          },
        )),
        const Expanded(child: CurrentPlaylistWidget())
      ];

  @override
  void initState() {
    super.initState();
    // TODO(main): Paginate those results
    buckets = (db.musicBuckets.select()
          ..orderBy([(u) => d.OrderingTerm.asc(u.name)]))
        .watch();
    artists = (db.artists.select()
          ..orderBy([(u) => d.OrderingTerm.asc(u.name)]))
        .watch();
    albums = (db.albums.select()..orderBy([(u) => d.OrderingTerm.asc(u.name)]))
        .watch();
    songs = (db.songs.all()).watch();

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

  void onSongPlay(Song song, bool now) async => {
        await player.playSongs(
          [song],
          replaceCurrent: now,
        ),
        setState(() {})
      };

  void onRefreshBucketList() async => {
        _loading
            ? ()
            : setState(() {
                _loading = true;
              }),
        await _init(),
        setState(() {
          _loading = false;
        })
      };

  void onRefreshBucketContent(MusicBucket bucket) async =>
      _bucketCrawling[bucket.name] != null &&
              _bucketCrawling[bucket.name]! == false
          ? {
              setState(() {
                _bucketCrawling[bucket.name] = true;
              }),
              await srv.saveSongs(bucket.name),
              setState(() {
                _bucketCrawling[bucket.name] = false;
              }),
            }
          : null;

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      backgroundColor: Colors.black,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.white,
            heroTag: "shufflePlay",
            onPressed: () async {
              // TODO(main): improve shuffle method to player service
              var shuffledSongs = await (db.songs.select()
                    ..orderBy([(u) => d.OrderingTerm.random()])
                    ..limit(30))
                  .get();
              await player.playSongs(shuffledSongs, replaceCurrent: true);
              setState(() {});
            },
            tooltip: 'Shuffle play',
            child: const Icon(Icons.shuffle_sharp),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.white,
            heroTag: "refreshMode",
            onPressed: _crawlMetarunning
                ? null
                : () async => {
                      setState(() {
                        _crawlMetarunning = true;
                      }),
                      await srv.loadJackets(),
                      await srv.loadArtists(),
                      setState(() {
                        _crawlMetarunning = false;
                      })
                    },
            tooltip: 'Refresh Metadatas',
            child: _crawlMetarunning
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 3.0,
                    ),
                  )
                : const Icon(Icons.rule_folder_sharp),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.white,
            heroTag: "refreshBucket",
            onPressed: () => onRefreshBucketList(),
            tooltip: 'Refresh Bucket List',
            child: _loading
                ? const CircularProgressIndicator()
                : const Icon(Icons.refresh),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.white,
            heroTag: "cleanAll",
            tooltip: 'Clear All',
            child: const Icon(Icons.delete_forever_outlined),
            onPressed: () => deleteEverything(db),
          ),
        ),
      ],
      title: Text(
        widget.title,
        style: const TextStyle(color: Colors.white),
      ),
    );
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (value) => setState(() {
                _selectedIndex = value;
              }),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.restore_from_trash_rounded),
              label: "Buckets",
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(Icons.spatial_audio_off),
              label: "Artists",
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(Icons.album),
              label: "Albums",
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(Icons.music_note),
              label: "Songs",
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(Icons.playlist_add_check_circle),
              label: "Playlist",
            ),
          ]),
      // drawer: player.currentPlaylist.isNotEmpty
      //     ? const CurrentPlaylistWidget()
      //     : null,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _widgets(buckets, artists, albums).elementAt(_selectedIndex),
          player.currentPlaylist.isEmpty ? Container() : PlayerWidget()
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
