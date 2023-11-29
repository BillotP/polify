import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:drift/drift.dart';
import 'package:get/get.dart';
import 'package:polify/services/bucket.dart';
import 'package:polify/services/database.dart';

class SongToplay {
  late int songId;
  Song song;
  String? localPath;
  String? streamingUrl;
  late String title;
  Album? album;
  late String albumName;
  Uint8List? albumCover;
  Artist? artist;
  late String artistName;
  SongToplay(this.song, {this.artist, this.album}) {
    songId = song.id;
    title = song.title
        .replaceAll(RegExp('.(?:wav|mp3|flac)'), "")
        .replaceAll(RegExp(r'\d+-\d\d'), "")
        .replaceAll(RegExp(r'^F?[0-9][0-9]'), "")
        .replaceAll(RegExp(r'^F?[0-9]'), "");
    localPath = song.localPath;
    streamingUrl = song.streamUrl;
    albumName = album?.name ?? "unknow album";
    artistName = artist?.name ?? "unknow artist";
    albumCover = album?.imageBlob;
  }
  Source get source {
    if (localPath != null) {
      return DeviceFileSource(localPath!);
    } else if (streamingUrl != null) {
      return UrlSource(streamingUrl!);
    }
    throw Exception("missing source");
  }

  MediaItem get mediaItem {
    String songitemId = "";
    if (localPath != null) {
      songitemId = localPath!;
    } else if (streamingUrl != null) {
      songitemId = streamingUrl!;
    }

    return songitemId.isNotEmpty
        ? MediaItem(
            id: songitemId,
            album: albumName,
            playable: true,
            artUri: albumCover != null
                ? UriData.fromBytes(albumCover! as List<int>,
                        mimeType: "image/png")
                    .uri
                : null,
            duration:
                song.duration > 1 ? Duration(seconds: song.duration) : null,
            title: title,
            artist: artistName)
        : throw Exception("missing source");
  }
}

class PlayerService extends BaseAudioHandler with QueueHandler, SeekHandler {
  int playIndex = 0;
  LocalDB localDb = Get.find();
  AudioPlayer player = Get.find();
  MusicBucketsService srv = Get.find();
  List<SongToplay> currentPlaylist = [];
  @override
  Future<void> play() async {
    await player.play(currentPlaylist.elementAt(playIndex).source);
    mediaItem.add(currentPlaylist.elementAt(playIndex).mediaItem);
    playbackState.value =
        PlaybackState(playing: true, queueIndex: playIndex, controls: [
      MediaControl.skipToPrevious,
      MediaControl.play,
      MediaControl.pause,
      MediaControl.stop,
      MediaControl.skipToNext,
    ]);
  }

  @override
  Future<void> pause() async {
    await player.pause();
    playbackState.add(
        playbackState.value.copyWith(playing: false, queueIndex: playIndex));
  }

  Future playAlbum(Album album, {bool replaceCurrent = true}) async {
    Artist? artist;
    var songs = await (localDb.songs.select()
          ..where((tbl) => tbl.albumId.equals(album.id)))
        .get();
    var artistsID = await (localDb.songArtists.select(distinct: true)
          ..where((tbl) => tbl.songId.equals(songs.first.id)))
        .getSingleOrNull();
    if (artistsID != null) {
      artist = await (localDb.artists.select(distinct: true)
            ..where(
              (tbl) => tbl.id.equals(artistsID.artistId),
            ))
          .getSingleOrNull();
    }
    await playSongs(songs,
        replaceCurrent: replaceCurrent, album: album, artist: artist);
  }

  Future playArtist(Artist artist, {bool replaceCurrent = true}) async {
    var albumIds = await (localDb.albumArtists.select()
          ..where((tbl) => tbl.artistId.equals(artist.id)))
        .get();
    var songs = await (localDb.songs.select()
          ..where((tbl) => tbl.albumId.isIn(albumIds.map((e) => e.albumId))))
        .get();
    await playSongs(songs, replaceCurrent: replaceCurrent, artist: artist);
  }

  Future playSongs(List<Song> songs,
      {bool replaceCurrent = true, Artist? artist, Album? album}) async {
    if (currentPlaylist.isEmpty) replaceCurrent = true;
    if (replaceCurrent && currentPlaylist.isNotEmpty) currentPlaylist.clear();

    for (var song in songs) {
      Album? songAlbum = album;
      Artist? songArtist = artist;
      if (song.streamUrl == null && song.localPath == null ||
          (song.streamUrl != null &&
              song.streamUrlExpiration!.isBefore(DateTime.now()))) {
        song = await srv.fetchUrl(song);

        if (album == null && song.albumId != null) {
          songAlbum = await (localDb.albums.select(distinct: true)
                ..where((a) => a.id.equals(song.albumId!)))
              .getSingleOrNull();
        }

        if (artist == null) {
          var artistsID = await (localDb.songArtists.select(distinct: true)
                ..where((tbl) => tbl.songId.equals(song.id)))
              .getSingleOrNull();

          if (artistsID != null) {
            songArtist = await (localDb.artists.select(distinct: true)
                  ..where(
                    (tbl) => tbl.id.equals(artistsID.artistId),
                  ))
                .getSingleOrNull();
          }
        }
      }

      currentPlaylist
          .add(SongToplay(song, artist: songArtist, album: songAlbum));
    }
    if (currentPlaylist.isEmpty) {
      Get.snackbar("Player", "No songs in playlist");
      return;
    }
    if (replaceCurrent) {
      playIndex = 0;
      await player.stop();
      queue.value = currentPlaylist.map((e) => e.mediaItem).toList();
      await play();
    } else {
      queue.add(currentPlaylist.map((e) => e.mediaItem).toList());
    }
  }

  Future nextSong() async {
    if (currentPlaylist.length > playIndex + 1 && currentPlaylist.isNotEmpty) {
      playIndex++;
      if (player.state == PlayerState.playing ||
          player.state == PlayerState.paused) {
        await player.stop();
      }
      await play();
    }
  }

  Future previousSong() async {
    if (playIndex - 1 >= 0 && currentPlaylist.isNotEmpty) {
      playIndex--;
      if (player.state == PlayerState.playing ||
          player.state == PlayerState.paused) {
        await player.stop();
      }
      await play();
    }
  }

  Future playIndexSong(int index) async {
    if (currentPlaylist.isNotEmpty &&
        index < currentPlaylist.length &&
        index >= 0) {
      playIndex = index;
      if (player.state == PlayerState.playing ||
          player.state == PlayerState.paused) {
        await player.stop();
      }
      await play();
    }
  }

  @override
  Future<void> skipToNext() => nextSong();

  @override
  Future<void> skipToPrevious() => previousSong();

  @override
  Future<void> stop() async {
    await player.stop();
    playbackState.value = PlaybackState();
  }
}
