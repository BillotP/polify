import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:drift/drift.dart';
import 'package:get/get.dart';
import 'package:polify/services/bucket_service.dart';
import 'package:polify/services/database.dart';

class SongToplay {
  late int songId;
  String? localPath;
  String? streamingUrl;
  String? title;
  String? albumName;
  String? artistName;
  SongToplay(Song song, {Artist? artist, Album? album}) {
    songId = song.id;
    title = song.title;
    localPath = song.localPath;
    streamingUrl = song.streamUrl;
    albumName = album?.name;
    artistName = artist?.name;
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
            title: title ?? "Unknow title",
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
    var songs = await (localDb.songs.select()
          ..where((tbl) => tbl.albumId.equals(album.id)))
        .get();
    await playSongs(songs, replaceCurrent: replaceCurrent, album: album);
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
      if (song.streamUrl == null && song.localPath == null) {
        song = await srv.fetchUrl(song);
      }
      currentPlaylist.add(SongToplay(song, artist: artist, album: album));
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
