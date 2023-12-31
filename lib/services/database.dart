// ignore_for_file: recursive_getters

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class MusicBuckets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique().withLength(min: 1)();
  TextColumn get endpoint => text().withLength(min: 1)();
  TextColumn get musicFolderPrefix => text().nullable()();
}

class Genres extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique().withLength(min: 1)();
}

class Labels extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique().withLength(min: 1)();
  TextColumn get imageUrl => text().nullable().withLength(min: 1)();
}

class LabelGenres extends Table {
  TextColumn get id => text().unique()();
  IntColumn get labelId => integer().references(Labels, #id)();
  IntColumn get genreId => integer().references(Genres, #id)();
}

class Groups extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get bucketPrefix => text().withLength(min: 1)();
  TextColumn get name => text().withLength(min: 1)();
  TextColumn get imageUrl => text().withLength(min: 1)();
}

class GroupGenres extends Table {
  TextColumn get id => text().unique()();
  IntColumn get groupId => integer().references(Groups, #id)();
  IntColumn get genreId => integer().references(Genres, #id)();
}

class GroupLabels extends Table {
  TextColumn get id => text().unique()();
  IntColumn get groupId => integer().references(Groups, #id)();
  IntColumn get labelId => integer().references(Genres, #id)();
}

class Artists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get bucketPrefix => text().withLength(min: 1)();
  TextColumn get name => text().unique().withLength(min: 1)();
  TextColumn get imageUrl => text().nullable().withLength(min: 1)();
  TextColumn get description => text().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  BoolColumn get hidden => boolean().withDefault(const Constant(false))();
}

class ArtistGenres extends Table {
  IntColumn get artistId => integer().references(Artists, #id)();
  IntColumn get genreId => integer().references(Genres, #id)();
}

class ArtistLabels extends Table {
  IntColumn get artistId => integer().references(Artists, #id)();
  IntColumn get genreId => integer().references(Genres, #id)();
}

class ArtistGroups extends Table {
  IntColumn get artistId => integer().references(Artists, #id)();
  IntColumn get groupId => integer().references(Groups, #id)();
}

class Albums extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique().withLength(min: 1)();
  TextColumn get bucketPrefix => text().withLength(min: 1)();
  TextColumn get imageUrl => text().nullable().withLength(min: 1)();
  BlobColumn get imageBlob => blob().nullable()();
  DateTimeColumn get year =>
      dateTime().check(year.isBiggerThan(Constant(DateTime(1000))))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  BoolColumn get hidden => boolean().withDefault(const Constant(false))();
}

class AlbumGenres extends Table {
  IntColumn get albumId => integer().references(Albums, #id)();
  IntColumn get genreId => integer().references(Genres, #id)();
}

class AlbumLabels extends Table {
  IntColumn get albumId => integer().references(Albums, #id)();
  IntColumn get genreId => integer().references(Genres, #id)();
}

class AlbumArtists extends Table {
  TextColumn get id => text().unique().withLength(min: 2)();
  IntColumn get albumId => integer().references(Albums, #id)();
  IntColumn get artistId => integer().references(Artists, #id)();
}

class AlbumGroups extends Table {
  TextColumn get id => text().unique().withLength(min: 2)();
  IntColumn get albumId => integer().references(Albums, #id)();
  IntColumn get groupId => integer().references(Groups, #id)();
}

class Songs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1)();
  TextColumn get bucketName => text().references(MusicBuckets, #name)();

  TextColumn get bucketKey => text().unique().withLength(min: 1)();
  TextColumn get streamUrl => text().nullable().withLength(min: 1)();
  DateTimeColumn get streamUrlExpiration => dateTime().nullable()();
  TextColumn get localPath => text().nullable().nullable()();

  TextColumn get imageUrl => text().nullable().withLength(min: 1)();
  DateTimeColumn get year =>
      dateTime().check(year.isBiggerThan(Constant(DateTime(1000))))();
  IntColumn get duration =>
      integer().check(duration.isBiggerOrEqual(const Constant(1)))();
  IntColumn get albumId => integer().nullable().references(Albums, #id)();

  BoolColumn get isSingle => boolean().withDefault(const Constant(false))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  BoolColumn get hidden => boolean().withDefault(const Constant(false))();
}

class SongGenres extends Table {
  TextColumn get id => text().unique().withLength(min: 2)();
  IntColumn get songId => integer().references(Songs, #id)();
  IntColumn get genreId => integer().references(Genres, #id)();
}

class SongLabels extends Table {
  TextColumn get id => text().unique().withLength(min: 2)();
  IntColumn get songId => integer().references(Songs, #id)();
  IntColumn get genreId => integer().references(Genres, #id)();
}

class SongArtists extends Table {
  TextColumn get id => text().unique().withLength(min: 2)();
  IntColumn get songId => integer().references(Songs, #id)();
  IntColumn get artistId => integer().references(Artists, #id)();
}

class SongGroups extends Table {
  TextColumn get id => text().unique().withLength(min: 2)();
  IntColumn get songId => integer().references(Songs, #id)();
  IntColumn get groupId => integer().references(Groups, #id)();
}

class Playlists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique().withLength(min: 1)();
}

class PlaylistSongs extends Table {
  TextColumn get id => text().unique().withLength(min: 2)();
  IntColumn get playlistId => integer().references(Playlists, #id)();
  IntColumn get songId => integer().references(Songs, #id)();
}

@DriftDatabase(tables: [
  MusicBuckets,
  Genres,
  Labels,
  LabelGenres,
  Groups,
  GroupGenres,
  GroupLabels,
  Artists,
  ArtistGenres,
  ArtistLabels,
  ArtistGroups,
  Albums,
  AlbumGenres,
  AlbumLabels,
  AlbumArtists,
  Songs,
  SongGenres,
  SongLabels,
  SongArtists,
  SongGroups,
  Playlists,
  PlaylistSongs
])
class LocalDB extends _$LocalDB {
  LocalDB() : super(_openConnection());

  @override
  int get schemaVersion => 3;
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // we added the dueDate property in the change from version 1 to
          // version 2
          await m.addColumn(songs, songs.hidden as GeneratedColumn<Object>);
        }
        if (from < 3) {
          await m.addColumn(albums, albums.isFavorite as GeneratedColumn);
          await m.addColumn(albums, albums.hidden as GeneratedColumn);
          await m.addColumn(artists, artists.isFavorite as GeneratedColumn);
          await m.addColumn(artists, artists.hidden as GeneratedColumn);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    try {
      final dbFolder = await getApplicationDocumentsDirectory();
      final fPath = p.join(dbFolder.path, 'db.sqlite');
      final file = File(fPath);
      return NativeDatabase.createInBackground(file);
    } on Exception catch (e) {
      print(e);
      // rethrow;
      final file = File('db.sqlite');
      return NativeDatabase.createInBackground(file);
    }
  });
}

Future<void> deleteEverything(LocalDB db) async {
  await db.customStatement('PRAGMA foreign_keys = OFF');
  try {
    await db.transaction(() async {
      for (final table in db.allTables) {
        await db.delete(table).go();
      }
    });
  } finally {
    await db.customStatement('PRAGMA foreign_keys = ON');
  }
}
