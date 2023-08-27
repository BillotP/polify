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
          // primaryColor: Colors.orange,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
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
  int _selectedIndex = 0;
  final Map<String, bool> _bucketCrawling = {};

  // int _songPage = 0;
  // var _songPageScrollcontroller = ScrollController();
  // void pagination() {
  //   if ((_songPageScrollcontroller.position.pixels ==
  //       _songPageScrollcontroller.position.maxScrollExtent)) {
  //     print("more $_songPage");
  //     _songPage += 1;
  //     songs = (db.songs.select()..limit(100, offset: _songPage)).watch();
  //     setState(() {});
  //   }
  // }
  final pages = ["buckets", "artists", "albums", "songs", "playlist"];
  List<Widget> _widgets(Stream<List<MusicBucket>>? buckets,
          Stream<List<Artist>>? artists, Stream<List<Album>>? albums) =>
      [
        Expanded(
          child: StreamBuilder(
            stream: buckets,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('Error ${snapshot.data.toString()}');
                } else if (snapshot.hasData) {
                  return GridView.builder(
                    // padding: const EdgeInsets.all(8),
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
                  return const Text('Empty data');
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
                return const Center(child: Text('Select a bucket above'));
              }
            },
          ),
        ),
        // const Text("Albums"),
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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: Platform.isAndroid ? 2 : 3),
                    clipBehavior: Clip.antiAlias,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      // return albumListTile(snapshot.data![index],
                      //     onAlbumPlayAfter, onAlbumPlayNow);
                      return albumCardTile(snapshot.data![index], onAlbumPlay);
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
        Expanded(
            child: StreamBuilder(
          stream: songs,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text('Error ${snapshot.data.toString()}');
              } else if (snapshot.hasData) {
                return ListView.builder(
                  clipBehavior: Clip.antiAlias,
                  shrinkWrap: true,
                  // controller: _songPageScrollcontroller,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.play_arrow_sharp),
                      title: Text(snapshot.data![index].title),
                      onTap: () async => {
                        await player.playSongs([snapshot.data![index]]),
                        setState(
                          () => {},
                        )
                      },
                    );
                  },
                );
              } else {
                return const Text('Empty data');
              }
            } else {
              return const Center(child: Text('Select a bucket above'));
            }
          },
        )),
        const Expanded(child: CurrentPlaylistWidget())
      ];

  @override
  void initState() {
    // _songPageScrollcontroller.addListener(pagination);
    super.initState();
    buckets = db.musicBuckets.all().watch();
    artists = db.artists.all().watch();
    albums = db.albums.all().watch();
    // songs = (db.songs.select()..limit(100, offset: _songPage)).watch();
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
    // if (Platform.isAndroid || Platform.isIOS) {
    //   Posthog().screen(
    //     screenName: 'Main Screen',
    //   );
    // }
    var appBar = AppBar(
      backgroundColor: Colors.black,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.white,
            heroTag: "shufflePlay",
            onPressed: () => print("Shuffle play"),
            tooltip: 'Shuffle play',
            child: const Icon(Icons.radio_outlined),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.white,
            heroTag: "refreshMode",
            onPressed: () async =>
                {await srv.loadJackets(), await srv.loadArtists()},
            tooltip: 'Refresh Metadatas',
            child: const Icon(Icons.rule_folder_sharp),
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
          onTap: (value) => {
                setState(() {
                  _selectedIndex = value;
                })
              },
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
      drawer: player.currentPlaylist.isNotEmpty
          ? const CurrentPlaylistWidget()
          : null,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: SearchAnchor(
              suggestionsBuilder: (context, controller) {
                // TODO(main) : do full text search on db items
                print(controller.value.text);
                // var res = (db.artists.select()
                //       ..where(
                //           (tbl) => tbl.name.contains(controller.value.text)))
                //     .watch();
                return List<ListTile>.generate(5, (index) {
                  final String item =
                      'item $index for ${pages[_selectedIndex]}';
                  return ListTile(
                    title: Text(item),
                    onTap: () {
                      setState(() {
                        controller.closeView(item);
                      });
                    },
                  );
                });
              },
              builder: (context, controller) {
                return SearchBar(
                  controller: controller,
                  onTap: () {
                    controller.openView();
                  },
                  onChanged: (_) {
                    controller.openView();
                  },
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0)),
                  leading: const Icon(Icons.search),
                );
              },
            ),
          ),
          _widgets(buckets, artists, albums).elementAt(_selectedIndex),
          player.currentPlaylist.isEmpty ? Container() : PlayerWidget()
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
