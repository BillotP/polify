import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polify/services/database.dart';

import '../services/bucket_service.dart';

class AlbumWidget extends StatefulWidget {
  final Album album;
  const AlbumWidget({required this.album, super.key});

  @override
  State<AlbumWidget> createState() => _AlbumWidgetState();
}

class _AlbumWidgetState extends State<AlbumWidget> {
  Album get album => widget.album;
  Stream<List<Song>>? songs;
  List<Artist>? artists;
  LocalDB db = Get.find();
  MusicBucketsService srv = Get.find();

  @override
  void initState() {
    super.initState();
    songs = (db.songs.select()..where((tbl) => tbl.albumId.equals(album.id)))
        .watch();
    // artists = (db.ar)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.background,
        backgroundColor: Colors.black,
        title: Text(album.name),
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
                  Text(album.name),
                  Text(album.bucketPrefix),
                  // IconButton(
                  //     onPressed: () => Get.back(),
                  //     icon: const Icon(Icons.keyboard_return)),
                ],
              ),
            ),
            const Text("Songs"),
            StreamBuilder(
              stream: songs,
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
                            title: Text(snapshot.data![index].title),
                            leading: snapshot.data![index].imageUrl != null
                                ? Image.network(snapshot.data![index].imageUrl!)
                                : const Icon(Icons.library_music),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Icon(Icons.play_arrow_outlined),
                                const Icon(Icons.playlist_add),
                                IconButton(
                                    onPressed: () =>
                                        srv.readId3Tag(snapshot.data![index]),
                                    icon:
                                        const Icon(Icons.info_outline_rounded))
                              ],
                            ),
                            onTap: () async => ()),
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
          ],
        ),
      ),
    );
  }
}
