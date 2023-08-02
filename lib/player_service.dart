import 'package:audioplayers/audioplayers.dart';
import 'package:drift/drift.dart';
import 'package:get/get.dart';
import 'package:polify/bucket_service.dart';
import 'package:polify/database.dart';

class SongToplay {
  final String? localPath;
  final String? streamingUrl;
  SongToplay(this.localPath, this.streamingUrl);
  Source get source {
    if (localPath != null) {
      return DeviceFileSource(localPath!);
    } else if (streamingUrl != null) {
      return UrlSource(streamingUrl!);
    }
    throw Exception("missing source");
  }
}

class PlayerService {
  LocalDB localDb = Get.find();
  MusicBucketsService srv = Get.find();
  AudioPlayer player = Get.find();
  List<SongToplay> currentPlaylist = [];
  int playIndex = 0;
  Future playAlbum(Album album) async {
    var songs = await (localDb.songs.select()
          ..where((tbl) => tbl.albumId.equals(album.id)))
        .get();
    print("${songs.length} from album ${album.name} to play");
    await playSongs(songs);
  }

  Future playArtist(Artist artist) async {
    var albumIds = await (localDb.albumArtists.select()
          ..where((tbl) => tbl.artistId.equals(artist.id)))
        .get();
    var songs = await (localDb.songs.select()
          ..where((tbl) => tbl.albumId.isIn(albumIds.map((e) => e.albumId))))
        .get();
    print("${songs.length} from artist ${artist.name} to play");
    await playSongs(songs);
  }

  Future playSongs(List<Song> songs) async {
    playIndex = 0;
    currentPlaylist.clear();
    for (var song in songs) {
      if (song.streamUrl != null) {
        currentPlaylist.add(SongToplay(null, song.streamUrl!));
      } else if (song.localPath != null) {
        currentPlaylist.add(SongToplay(song.localPath!, null));
      } else {
        var songUrl = await srv.fetchUrl(song);
        currentPlaylist.add(SongToplay(null, songUrl));
      }
    }
    // await player.setSource(currentPlaylist.first.source);
    if (player.state == PlayerState.playing ||
        player.state == PlayerState.paused) {
      await player.stop();
    }
    if (currentPlaylist.isNotEmpty) {
      await player.play(currentPlaylist.elementAt(playIndex).source);
      return;
    }
    Get.snackbar("Player", "No songs in playlist");
  }

  Future nextSong() async {
    if (currentPlaylist.length > playIndex + 1 && currentPlaylist.isNotEmpty) {
      playIndex++;
      if (player.state == PlayerState.playing ||
          player.state == PlayerState.paused) {
        await player.stop();
      }
      // await player.setSource(currentPlaylist.elementAt(playIndex).source);
      await player.play(currentPlaylist.elementAt(playIndex).source);
    }
  }

  Future previousSong() async {
    if (playIndex - 1 >= 0 && currentPlaylist.isNotEmpty) {
      playIndex--;
      if (player.state == PlayerState.playing ||
          player.state == PlayerState.paused) {
        await player.stop();
      }
      // await player.setSource(currentPlaylist.elementAt(playIndex).source);
      await player.play(currentPlaylist.elementAt(playIndex).source);
    }
  }
}

// Future _readObject(String bucket, String key) async {
//   try {
//     String songUrl;
//     setState(() {
//       _loading = true;
//     });
//     if (player.state == PlayerState.playing) player.stop();
//     var existing = await (db.select(db.songs)
//           ..where((tbl) => tbl.bucketKey.equals(key)))
//         .getSingle();
//     if (existing.streamUrl != null) {
//       songUrl = existing.streamUrl!;
//     } else {
//       songUrl = await s3Storage.presignedGetObject(
//         bucket,
//         key,
//       );
//       await (db.update(db.songs)..where((tbl) => tbl.bucketKey.equals(key)))
//           .write(SongsCompanion(streamUrl: d.Value(songUrl)));
//     }
//     await player.play(UrlSource(songUrl));
//     setState(() {
//       _loading = false;
//     });
//   } on Exception catch (e) {
//     Get.snackbar("Something bad happened", e.toString());
//     setState(() {
//       _loading = false;
//     });
//   }
// }
