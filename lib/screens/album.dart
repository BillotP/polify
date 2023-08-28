// import 'dart:io';

import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polify/services/database.dart';
import 'package:polify/services/player.dart';
// import 'package:posthog_flutter/posthog_flutter.dart';

import '../services/bucket.dart';

class AlbumWidget extends StatefulWidget {
  final Album album;
  const AlbumWidget({required this.album, super.key});

  @override
  State<AlbumWidget> createState() => _AlbumWidgetState();
}

class _AlbumWidgetState extends State<AlbumWidget> {
  Album get album => widget.album;
  List<Song>? songs;
  List<SongGenre>? genres;
  List<Artist>? artists;
  LocalDB db = Get.find();
  PlayerService player = Get.find();
  MusicBucketsService srv = Get.find();

  @override
  void initState() {
    super.initState();
    // artists = (db.ar)
    _init();
  }

  Future _init() async {
    songs = await (db.songs.select()
          ..where((tbl) => tbl.albumId.equals(album.id)))
        .get();
    genres = await (db.songGenres.select()
          ..where(
            (tbl) => tbl.songId.isIn(songs!.map((e) => e.id).toList()),
          ))
        .get();
    setState(() {});
  }

  void onAlbumPlay(Album album, bool now) async => {
        await player.playAlbum(
          album,
          replaceCurrent: now,
        ),
        setState(() {})
      };

  @override
  Widget build(BuildContext context) {
    // if (Platform.isAndroid || Platform.isIOS) {
    //   Posthog().screen(
    //     screenName: 'Album Screen',
    //   );
    // }
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.background,
        backgroundColor: Colors.black,
        title: Text(album.name),
        titleTextStyle: const TextStyle(color: Colors.white),
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Navigator.pop(context, "hello"),
            icon: const Icon(Icons.backspace)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              decoration: album.imageBlob == null
                  ? null
                  : BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: MemoryImage(album.imageBlob!))),
              height: (MediaQuery.of(context).size.height + 100) / 6,
              width: (MediaQuery.of(context).size.width),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Card(
                    child: Column(
                      children: [
                        Text(
                          album.name,
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text(
                          album.bucketPrefix,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const Card(
                    child: Row(
                      children: [
                        Text("Genres"),
                        // genres != null
                        //     ? genres!.map((e) => Text(e.genreId)).toList()
                        //     : null
                      ],
                    ),
                  ),
                  Card(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () => onAlbumPlay(album, true),
                            icon: const Icon(Icons.play_circle_fill)),
                        IconButton(
                            onPressed: () => onAlbumPlay(album, false),
                            icon: const Icon(Icons.playlist_add)),
                        IconButton(
                            onPressed: songs == null
                                ? null
                                : () => srv.downloadSongs(songs!),
                            icon: const Icon(Icons.download_for_offline)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Text("Songs"),
            songs == null
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: songs!.length,
                      itemBuilder: (context, index) => ListTile(
                          title: Text(songs![index].title),
                          leading: songs![index].imageUrl != null
                              ? Image.network(songs![index].imageUrl!)
                              : const Icon(Icons.library_music),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Icon(Icons.play_arrow_outlined),
                              IconButton(
                                  onPressed: () => player.playSongs(
                                      [songs![index]],
                                      replaceCurrent: true),
                                  icon: const Icon(Icons.play_circle_fill)),
                              IconButton(
                                  onPressed: () => player.playSongs(
                                      [songs![index]],
                                      replaceCurrent: false),
                                  icon: const Icon(Icons.playlist_add)),
                              IconButton(
                                  onPressed: () =>
                                      srv.readId3Tag(songs![index]),
                                  icon: const Icon(Icons.info_outline_rounded)),
                              IconButton(
                                  onPressed: () =>
                                      songs![index].localPath != null
                                          ? null
                                          : srv.downloadSongs([songs![index]]),
                                  icon: const Icon(Icons.download_for_offline))
                            ],
                          ),
                          onTap: () async => ()),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
