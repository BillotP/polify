import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' as d;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:id3tag/id3tag.dart';
import 'package:path_provider/path_provider.dart';
import 'package:polify/env.dart';
import 'package:polify/services/database.dart';
import 'package:polify/services/wiki_service.dart';
import 'package:s3_storage/io.dart';
import 'package:s3_storage/models.dart';
import 'package:s3_storage/s3_storage.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

class MusicBucketsService {
  // TODO(MusicBucketsService/musicPrefix) do not hardcode
  String musicPrefix = "Music";
  S3Storage s3storage = Get.find();
  LocalDB localDb = Get.find();
  List<Bucket> buckets = [];

  /// loadBuckets use package:s3_storage to get user bucket list and save them to local database
  Future loadBuckets() async {
    try {
      buckets = await s3storage.listBuckets();
      if (!kDebugMode) {
        buckets.removeWhere((element) =>
            element.name.isCaseInsensitiveContainsAny("preprod") ||
            element.name.isCaseInsensitiveContainsAny("dev"));
      }
      await localDb.musicBuckets.insertAll(
          buckets.map((e) => MusicBucketsCompanion.insert(
              endpoint: Env.s3Endpoint,
              name: e.name,
              musicFolderPrefix: d.Value(musicPrefix))),
          onConflict: d.DoNothing(target: [localDb.musicBuckets.name]));
    } on Exception catch (e) {
      Get.snackbar("Something bad happened", e.toString());
    }
  }

// seedDefault upsert and return unknowAlbum Id(List[0]) and unknowArtistId (List[1]) ids
  Future<List<int>> seedDefault() async {
    try {
      var unknowAlbumId = await localDb.albums.insertReturningOrNull(
          AlbumsCompanion.insert(
              name: "Unknow Album", bucketPrefix: "xxx", year: DateTime.now()),
          onConflict: d.DoNothing(target: [localDb.albums.name]));

      unknowAlbumId ??= await (localDb.albums.select()
            ..where((tbl) => tbl.name.equals("Unknow Album")))
          .getSingle();

      var unknowArtistId = await localDb.artists.insertReturningOrNull(
          ArtistsCompanion.insert(bucketPrefix: "xxx", name: "Unknow Artists"),
          onConflict: d.DoNothing(target: [localDb.artists.name]));

      unknowArtistId ??= await (localDb.artists.select()
            ..where((tbl) => tbl.name.equals("Unknow Artists")))
          .getSingle();
      return [unknowAlbumId.id, unknowArtistId.id];
    } on Exception {
      rethrow;
    }
  }

  Future saveSongs(String targetBucket) async {
    try {
      Stream<ListObjectsResult> objs;
      var [unknowAlbumId, unknowArtistId] = await seedDefault();

      objs = s3storage.listObjectsV2(targetBucket,
          prefix: "$musicPrefix/", recursive: true);

      await objs.forEach((element) async {
        for (var obj in element.objects) {
          await saveObject(obj, targetBucket, unknowAlbumId, unknowArtistId);
        }
        if (element.objects.length < 1000) {
          objs = s3storage.listObjectsV2(targetBucket,
              prefix: "$musicPrefix/",
              recursive: true,
              startAfter: element.objects.last.key);
        }
        return;
      }).then((_) {
        Get.snackbar("Bucket $targetBucket", "Processing Done !");
        return;
      }).catchError((e) {
        throw e;
      });
    } on Exception catch (e) {
      Get.snackbar("Something bad happened", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 40));
    }
  }

  Future<void> saveObject(Object obj, String targetBucket, int unknowAlbumId,
      int unknowArtistId) async {
    // TODO(saveObject) : clean / refacto the below mess (serialize parsing as json and batch upsert and the end)
    if (obj.eTag == null) return; // It should be a folder
    Map<String, dynamic> objectmetas = {
      "name": null,
      "key": obj.key,
      "bucket": targetBucket,
      "artist": {"name": null},
      "album": {"name": null},
    };
    var infos = obj.key!.split("/");
    infos.remove(musicPrefix);
    switch (infos.length) {
      case 1:
        objectmetas["name"] = infos.first;
        var songId = await localDb.songs.insertReturningOrNull(
            SongsCompanion.insert(
              title: objectmetas["name"],
              bucketName: objectmetas["bucket"],
              bucketKey: objectmetas["key"],
              year: DateTime.now(),
              duration: 1,
              albumId: d.Value(unknowAlbumId),
            ),
            onConflict: d.DoNothing(target: [localDb.songs.bucketKey]));
        songId ??= await (localDb.songs.select()
              ..where((tbl) => tbl.bucketKey.equals(objectmetas["key"])))
            .getSingle();
        await localDb.songArtists.insertOne(
          SongArtistsCompanion.insert(
            id: "${songId.id}-$unknowArtistId",
            songId: songId.id,
            artistId: unknowArtistId,
          ),
        );
        break;
      case 2:
        objectmetas["name"] = infos.last;
        objectmetas["artist"] = {"name": infos.first};
        var artistId = await localDb.artists.insertReturningOrNull(
            ArtistsCompanion.insert(
                bucketPrefix: "$musicPrefix/${infos.first}",
                name: objectmetas["artist"]["name"]),
            onConflict: d.DoNothing(target: [localDb.artists.name]));
        artistId ??= await (localDb.artists.select()
              ..where((tbl) => tbl.name.equals(objectmetas["artist"]["name"])))
            .getSingle();
        var songId = await localDb.songs.insertReturningOrNull(
            SongsCompanion.insert(
              title: objectmetas["name"],
              bucketName: objectmetas["bucket"],
              bucketKey: objectmetas["key"],
              year: DateTime.now(),
              duration: 1,
              albumId: d.Value(unknowAlbumId),
            ),
            onConflict: d.DoNothing(target: [localDb.songs.bucketKey]));
        songId ??= await (localDb.songs.select()
              ..where((tbl) => tbl.bucketKey.equals(objectmetas["key"])))
            .getSingle();
        await localDb.songArtists.insertOne(
            SongArtistsCompanion.insert(
                id: "${songId.id}-${artistId.id}",
                songId: songId.id,
                artistId: artistId.id),
            onConflict: d.DoNothing(target: [localDb.songArtists.id]));
        break;
      case 3:
        objectmetas["name"] = infos.last;
        objectmetas["artist"] = {"name": infos.first};
        objectmetas["album"] = {"name": infos.elementAt(1)};
        var albumId = await localDb.albums.insertReturningOrNull(
          AlbumsCompanion.insert(
              name: objectmetas["album"]["name"],
              bucketPrefix: "$musicPrefix/${infos.first}/${infos.elementAt(1)}",
              year: DateTime.now()),
          onConflict: d.DoNothing(target: [localDb.albums.name]),
        );
        albumId ??= await (localDb.albums.select()
              ..where((tbl) => tbl.name.equals(objectmetas["album"]["name"])))
            .getSingle();
        var artistId = await localDb.artists.insertReturningOrNull(
            ArtistsCompanion.insert(
                bucketPrefix: "$musicPrefix/${infos.first}",
                name: objectmetas["artist"]["name"]),
            onConflict: d.DoNothing(target: [localDb.artists.name]));
        artistId ??= await (localDb.artists.select()
              ..where((tbl) => tbl.name.equals(objectmetas["artist"]["name"])))
            .getSingle();
        await localDb.albumArtists.insertOne(
            AlbumArtistsCompanion.insert(
                id: "${albumId.id}-${artistId.id}",
                albumId: albumId.id,
                artistId: artistId.id),
            onConflict: d.DoNothing(target: [localDb.albumArtists.id]));
        var songId = await localDb.songs.insertReturningOrNull(
            SongsCompanion.insert(
                title: objectmetas["name"],
                bucketName: objectmetas["bucket"],
                bucketKey: objectmetas["key"],
                year: DateTime.now(),
                duration: 1,
                albumId: d.Value(albumId.id)),
            onConflict: d.DoNothing(target: [localDb.songs.bucketKey]));
        songId ??= await (localDb.songs.select()
              ..where((tbl) => tbl.bucketKey.equals(objectmetas["key"])))
            .getSingle();
        await localDb.songArtists.insertOne(
            SongArtistsCompanion.insert(
                id: "${songId.id}-${artistId.id}",
                songId: songId.id,
                artistId: artistId.id),
            onConflict: d.DoNothing(target: [localDb.songArtists.id]));
        break;
      default:
        break;
    }
  }

  /// fetchUrl get a presigned url (valid for 1week) for a song bucket key
  /// and save it to local db
  Future<Song> fetchUrl(Song song) async {
    try {
      var songUrl = await s3storage.presignedGetObject(
        song.bucketName,
        song.bucketKey,
      );
      var updated = await (localDb.update(localDb.songs)
            ..where((tbl) => tbl.bucketKey.equals(song.bucketKey)))
          .writeReturning(SongsCompanion(streamUrl: d.Value(songUrl)));
      return updated.first;
    } on Exception catch (e) {
      Get.snackbar("Something bad happened", e.toString());
      rethrow;
    }
  }

  Future<List<Song>> downloadSongs(List<Song> songs) async {
    try {
      for (var song in songs) {
        if (song.localPath != null && File(song.localPath!).existsSync()) {
          continue;
        }
        Directory? appFolder;
        if (Platform.isAndroid) {
          appFolder = await getExternalStorageDirectory();
        } else {
          appFolder = await getDownloadsDirectory();
        }

        final fPath =
            p.join(appFolder!.path, "polify", song.bucketKey.split('/').last);
        print("Exist $fPath ");
        if (!File(fPath).existsSync()) {
          print("Downloading ...");
          await s3storage.fGetObject(song.bucketName, song.bucketKey, fPath);
          print("Downloaded $fPath");
        }
        var updated = await (localDb.update(localDb.songs)
              ..where((tbl) => tbl.bucketKey.equals(song.bucketKey)))
            .writeReturning(SongsCompanion(localPath: d.Value(fPath)));
        songs[songs.indexWhere((element) => element.id == updated.first.id)] =
            updated.first;
      }
      return songs;
    } on Exception {
      rethrow;
    }
  }

  Future uploadSong(String fpath, String bucketPath, String bucket) async {
    if (!File(fpath).existsSync()) return;
    try {
      var ff = File(fpath);
      Stream<Uint8List> lines = ff.openRead() as Stream<Uint8List>;
      var res = await s3storage.putObject(bucket, bucketPath, lines);
      print(res);
    } on Exception {
      rethrow;
    }
  }

  Future<ID3Tag?> readId3Tag(Song song, {clearAfter = false}) async {
    if (song.localPath == null ||
        (song.localPath != null && !File(song.localPath!).existsSync())) {
      [song] = await downloadSongs([song]);
      sleep(const Duration(seconds: 2));
    }
    print(song.localPath);
    final fpath = song.localPath!;
    final parser = ID3TagReader.path(fpath);
    final tag = parser.readTagSync();
    if (tag.tagFound) {
      // Get.snackbar('Infos',
      //     'Artist : ${tag.artist}\nAlbum :${tag.album}\nTitle :${tag.title}\nComment :${tag.comment}',
      //     snackPosition: SnackPosition.BOTTOM,
      //     icon: tag.pictures.isNotEmpty
      //         ? Image.memory(tag.pictures.first.imageData as Uint8List)
      //         : const Icon(Icons.library_music_outlined));
      return tag;
    }
    if (clearAfter) File(fpath).deleteSync();
    return null;
  }

  Future loadJackets() async {
    var elem = 0;
    final albums = await (localDb.albums.all()).get();
    print("Found ${albums.length} objects");
    for (var element in albums) {
      elem++;
      if (element.name.startsWith("Unknow Album") && element.id == 1) continue;
      if (element.imageBlob != null) continue;
      print("Crawling album $elem / ${albums.length} ${element.name}");
      if (elem % 100 == 0) {
        Get.snackbar("LoadJackets : ", "$elem / ${albums.length} treated",
            backgroundColor: Colors.white);
      }
      try {
        var song = await (localDb.songs.select()
              ..where((tbl) => tbl.albumId.equals(element.id))
              ..limit(1))
            .getSingleOrNull();
        if (song == null) continue;
        var tags = await readId3Tag(song, clearAfter: true);
        if (tags == null) continue;
        if (tags.pictures.isEmpty) continue;
        print("Found song  ${song.title} ${song.id} with picture");
        // TODO(loadJackets): Batch update @ the end
        await (localDb.update(localDb.albums)
              ..where((tbl) => tbl.id.equals(song.albumId!)))
            .writeReturning(AlbumsCompanion(
                imageBlob:
                    d.Value(tags.pictures.first.imageData as Uint8List)));
      } on Exception catch (e) {
        print(e);
        continue;
      }
    }
  }

  Future loadArtists() async {
    final artists = await (localDb.artists.all()).get();
    var client = http.Client();
    var cnt = 0;
    print("Found ${artists.length} objects");
    for (var element in artists) {
      if (element.id == 1) continue;
      // if (element.imageUrl != null) continue;
      cnt++;
      if (cnt % 10 == 0) {
        Get.snackbar("LoadArtists : ", "$cnt / ${artists.length} treated",
            backgroundColor: Colors.white
            // showProgressIndicator: true,
            // isDismissible: true,
            );
      }
      print("Crawling artists $cnt / ${artists.length} ${element.name}");
      var url = Uri.https('en.wikipedia.org', '/w/rest.php/v1/search/page',
          {"q": "${element.name} music artist", "limit": "1"});
      var response = await client.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      var articles = jsonDecode(response.body);
      List<WikiInfos> pages = [];
      if (articles['pages'] != null && articles['pages'] != []) {
        pages = List<WikiInfos>.from(
            articles['pages'].map((model) => WikiInfos.fromJson(model)));
      }
      print("Found ${pages.length} response pages");
      if (pages.isNotEmpty) {
        var page = pages.first;
        if (page.thumbnail != null) {
          await (localDb.update(localDb.artists)
                ..where((tbl) => tbl.id.equals(element.id)))
              .writeReturning(ArtistsCompanion(
                  description: d.Value(page.excerpt),
                  imageUrl: d.Value("https:${page.thumbnail!.url}")));
        } else if (page.excerpt.isNotEmpty) {
          await (localDb.update(localDb.artists)
                ..where((tbl) => tbl.id.equals(element.id)))
              .writeReturning(
                  ArtistsCompanion(description: d.Value(page.excerpt)));
        }
      }
      sleep(const Duration(seconds: 1));
    }
  }
}
