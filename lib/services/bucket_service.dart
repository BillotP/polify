import 'dart:io';

import 'package:drift/drift.dart' as d;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:id3tag/id3tag.dart';
import 'package:path_provider/path_provider.dart';
import 'package:polify/services/database.dart';
import 'package:s3_storage/io.dart';
import 'package:s3_storage/models.dart';
import 'package:s3_storage/s3_storage.dart';
import 'package:path/path.dart' as p;

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
              name: e.name, musicFolderPrefix: d.Value(musicPrefix))),
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

  Future readId3Tag(Song song) async {
    // TODO (readId3Tag): Check if file is offline first else download and update db
    final appFolder = await getExternalStorageDirectory();
    final fPath = p.join(appFolder!.path, song.bucketKey.split('/').last);
    if (!File(fPath).existsSync()) {
      // print("Downloading ...");
      await s3storage.fGetObject(song.bucketName, song.bucketKey, fPath);
      // print("Downloaded $fPath");
      sleep(const Duration(seconds: 2));
    }
    final parser = ID3TagReader.path(fPath);
    final tag = parser.readTagSync();
    if (tag.tagFound) {
      Get.snackbar('Infos',
          'Artist : ${tag.artist}\nAlbum :${tag.album}\nTitle :${tag.title}\nComment :${tag.comment}',
          snackPosition: SnackPosition.BOTTOM,
          icon: tag.pictures.isNotEmpty
              ? Image.memory(tag.pictures.first.imageData as Uint8List)
              : const Icon(Icons.library_music_outlined));
    }
  }
}
