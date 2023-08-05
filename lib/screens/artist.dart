import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polify/services/database.dart';

import 'album.dart';
import '../services/bucket_service.dart';

class ArtistWidget extends StatefulWidget {
  final Artist artist;
  const ArtistWidget({required this.artist, super.key});

  @override
  State<ArtistWidget> createState() => _ArtistWidgetState();
}

class _ArtistWidgetState extends State<ArtistWidget> {
  Artist get artist => widget.artist;
  Stream<List<Album>>? albums;
  List<Artist>? artists;
  LocalDB db = Get.find();
  MusicBucketsService srv = Get.find();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future _init() async {
    var albumsIds = await (db.albumArtists.select()
          ..where((tbl) => tbl.artistId.equals(artist.id))
          ..distinct)
        .get();
    setState(() {
      albums = (db.albums.select()
            ..where((tbl) => tbl.id.isIn(albumsIds.map((e) => e.albumId))))
          .watch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.background,
        backgroundColor: Colors.black,
        title: Text(artist.name),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: (MediaQuery.of(context).size.height + 100) / 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(artist.name),
                  Text(artist.bucketPrefix),
                  // Text(albums && albums!.length || 0),
                  // IconButton(
                  //     onPressed: () => Get.back(),
                  //     icon: const Icon(Icons.keyboard_return)),
                ],
              ),
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
                                title: Text(snapshot.data![index].name),
                                onTap: () => Get.to(
                                    AlbumWidget(album: snapshot.data![index])),
                                leading: snapshot.data![index].imageUrl != null
                                    ? Image.network(
                                        snapshot.data![index].imageUrl!)
                                    : const Icon(Icons.library_music),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Icon(Icons.play_arrow_outlined),
                                    const Icon(Icons.playlist_add),
                                    IconButton(
                                        onPressed: () => (),
                                        icon: const Icon(
                                            Icons.info_outline_rounded))
                                  ],
                                ),
                              )),
                    );
                  } else {
                    return const Text('Empty data');
                  }
                } else {
                  return const Center(child: Text('Select a bucket above'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
