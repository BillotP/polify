import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import 'package:polify/services/database.dart';
import 'package:polify/services/player.dart';
import 'package:polify/services/bucket.dart';

import 'album.dart';

class ArtistWidget extends StatefulWidget {
  // final Artist artist;
  final int artistID;
  const ArtistWidget({required this.artistID, super.key});

  @override
  State<ArtistWidget> createState() => _ArtistWidgetState();
}

class _ArtistWidgetState extends State<ArtistWidget> {
  // Artist get artist => widget.artist;
  Artist? artist;
  Stream<List<Album>>? albums;
  Stream<List<Song>>? songs;
  List<Artist>? artists;
  LocalDB db = Get.find();
  PlayerService player = Get.find();
  MusicBucketsService srv = Get.find();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future toggleFavorite() async {
    if (artist == null) return;
    artist = (await (db.artists.update()
              ..where((tbl) => tbl.id.equals(artist!.id)))
            .writeReturning(
                ArtistsCompanion(isFavorite: d.Value(!artist!.isFavorite))))
        .first;

    return;
  }

  Future _init() async {
    artist = await (db.artists.select()
          ..where((tbl) => tbl.id.equals(widget.artistID)))
        .getSingle();
    if (artist == null) return;
    var albumsIds = await (db.albumArtists.select()
          ..where((tbl) => tbl.artistId.equals(artist!.id))
          ..distinct)
        .get();
    setState(() {
      albums = (db.albums.select()
            ..where((tbl) => tbl.id.isIn(albumsIds.map((e) => e.albumId))))
          .watch();
      songs = (db.songs.select()
            ..where((tbl) =>
                tbl.albumId.isIn(albumsIds.map((e) => e.albumId).toList())))
          .watch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("${artist?.name} - ${artist?.bucketPrefix}"),
        titleTextStyle: const TextStyle(color: Colors.white),
        centerTitle: false,
        leading: IconButton(
            onPressed: () => Navigator.pop(context, "hello"),
            icon: const Icon(
              Icons.backspace,
              color: Colors.white,
            )),
      ),
      body: Center(
        child: artist == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      artist!.imageUrl != null
                          ? Image.network(artist!.imageUrl!)
                          : const Icon(Icons.person_3_outlined),
                      artist!.description != null
                          ? Expanded(child: Html(data: artist!.description!))
                          : Container(),
                      const Text("...")
                    ],
                  ),
                  const Text("Albums"),
                  StreamBuilder(
                    stream: albums,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.connectionState ==
                              ConnectionState.active ||
                          snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Text('Error ${snapshot.data.toString()}');
                        } else if (snapshot.hasData) {
                          return Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) => ListTile(
                                      title: Text(
                                        snapshot.data![index].name,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      onTap: () => Get.to(AlbumWidget(
                                          albumID: snapshot.data![index].id)),
                                      leading: snapshot.data![index].imageUrl !=
                                              null
                                          ? Image.network(
                                              snapshot.data![index].imageUrl!)
                                          : const Icon(Icons.library_music),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                              onPressed: () => player.playAlbum(
                                                  snapshot.data![index],
                                                  replaceCurrent: true),
                                              icon:
                                                  const Icon(Icons.play_arrow)),
                                          IconButton(
                                              onPressed: () => player.playAlbum(
                                                  snapshot.data![index],
                                                  replaceCurrent: false),
                                              icon: const Icon(
                                                  Icons.playlist_add)),
                                        ],
                                      ),
                                    )),
                          );
                        } else {
                          return const Text('Empty data');
                        }
                      } else {
                        return const Center(child: Text('...'));
                      }
                    },
                  ),
                  const Text("Songs"),
                  StreamBuilder(
                    stream: songs,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.connectionState ==
                              ConnectionState.active ||
                          snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Text('Error ${snapshot.data.toString()}');
                        } else if (snapshot.hasData) {
                          return Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) => ListTile(
                                      title: Text(
                                        snapshot.data![index].title,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      leading: snapshot.data![index].imageUrl !=
                                              null
                                          ? Image.network(
                                              snapshot.data![index].imageUrl!)
                                          : const Icon(
                                              Icons.library_music_sharp),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                              onPressed: () => player.playSongs(
                                                  [snapshot.data![index]],
                                                  replaceCurrent: true),
                                              icon:
                                                  const Icon(Icons.play_arrow)),
                                          IconButton(
                                              onPressed: () => player.playSongs(
                                                  [snapshot.data![index]],
                                                  replaceCurrent: false),
                                              icon: const Icon(
                                                  Icons.playlist_add)),
                                        ],
                                      ),
                                    )),
                          );
                        } else {
                          return const Text('Empty data');
                        }
                      } else {
                        return const Center(child: Text('...'));
                      }
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
