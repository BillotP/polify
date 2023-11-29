import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:polify/services/database.dart';
import 'package:polify/services/player.dart';
import 'package:polify/services/bucket.dart';

class AlbumWidget extends StatefulWidget {
  final int albumID;
  const AlbumWidget({required this.albumID, super.key});

  @override
  State<AlbumWidget> createState() => _AlbumWidgetState();
}

class _AlbumWidgetState extends State<AlbumWidget> {
  Album? album;
  List<Song>? songs;
  List<SongGenre>? genres;
  List<Artist>? artists;
  LocalDB db = Get.find();
  PlayerService player = Get.find();
  MusicBucketsService srv = Get.find();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future _init() async {
    album = await (db.albums.select()
          ..where((tbl) => tbl.id.equals(widget.albumID)))
        .getSingle();
    if (album == null) return;
    songs = await (db.songs.select()
          ..where((tbl) => tbl.albumId.equals(album!.id)))
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

  Future toggleFavorite() async {
    if (album == null) return;
    album = (await (db.albums.update()
              ..where((tbl) => tbl.id.equals(album!.id)))
            .writeReturning(
                AlbumsCompanion(isFavorite: d.Value(!album!.isFavorite))))
        .first;

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("${album?.name}"),
        titleTextStyle: const TextStyle(color: Colors.white),
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Navigator.pop(context, "hello"),
            icon: const Icon(
              Icons.backspace,
              color: Colors.white,
            )),
      ),
      body: Center(
        child: album == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    decoration: album!.imageBlob == null
                        ? null
                        : BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: MemoryImage(album!.imageBlob!))),
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
                                album!.name,
                                style: const TextStyle(color: Colors.black),
                              ),
                              Text(
                                album!.bucketPrefix,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () => onAlbumPlay(album!, true),
                                  icon: const Icon(Icons.play_circle_fill)),
                              IconButton(
                                  onPressed: () => onAlbumPlay(album!, false),
                                  icon: const Icon(Icons.playlist_add)),
                              IconButton(
                                  onPressed: songs == null
                                      ? null
                                      : () => srv.downloadSongs(songs!),
                                  icon: const Icon(Icons.download_for_offline)),
                              IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: album!.isFavorite
                                      ? Colors.red
                                      : Colors.grey[800],
                                ),
                                onPressed: () async =>
                                    {await toggleFavorite(), setState(() {})},
                              ),
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
                                title: Text(
                                  songs![index].title,
                                  style: const TextStyle(color: Colors.white),
                                ),
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
                                        icon:
                                            const Icon(Icons.play_circle_fill)),
                                    IconButton(
                                        onPressed: () => player.playSongs(
                                            [songs![index]],
                                            replaceCurrent: false),
                                        icon: const Icon(Icons.playlist_add)),
                                    IconButton(
                                        onPressed: () =>
                                            songs![index].localPath != null
                                                ? null
                                                : srv.downloadSongs(
                                                    [songs![index]]),
                                        icon: const Icon(
                                            Icons.download_for_offline))
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
