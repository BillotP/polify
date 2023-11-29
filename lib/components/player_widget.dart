import 'dart:async';

import 'package:drift/drift.dart' as d;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polify/screens/album.dart';
import 'package:polify/screens/artist.dart';
import 'package:polify/services/database.dart';
import 'package:polify/services/player.dart';

class PlayerWidget extends StatefulWidget {
  final PlayerService player = Get.find();

  PlayerWidget({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState();
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;
  final double _playerIconSize = 24.0;
  final double _playerOptionsIconSize = 16.0;

  final double _playerInfoFontSize = 16;

  final LocalDB db = Get.find();

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  // bool get _isPlaying => _playerState == PlayerState.playing;

  bool get _isPaused => _playerState == PlayerState.paused;

  String get _durationText => _duration?.toString().split('.').first ?? '';

  String get _positionText => _position?.toString().split('.').first ?? '';

  AudioPlayer get player => widget.player.player;

  Future toggleFavorite() async {
    widget.player.currentPlaylist.elementAt(widget.player.playIndex).song =
        (await (db.songs.update()
                  ..where((tbl) => tbl.id.equals(widget.player.currentPlaylist
                      .elementAt(widget.player.playIndex)
                      .songId)))
                .writeReturning(SongsCompanion(
                    isFavorite: d.Value(!widget.player.currentPlaylist
                        .elementAt(widget.player.playIndex)
                        .song
                        .isFavorite))))
            .first;

    return;
  }

  Future toggleHidden() async {
    widget.player.currentPlaylist.elementAt(widget.player.playIndex).song =
        (await (db.songs.update()
                  ..where((tbl) => tbl.id.equals(widget.player.currentPlaylist
                      .elementAt(widget.player.playIndex)
                      .songId)))
                .writeReturning(SongsCompanion(
                    hidden: d.Value(!widget.player.currentPlaylist
                        .elementAt(widget.player.playIndex)
                        .song
                        .hidden))))
            .first;

    return;
  }

  @override
  void initState() {
    super.initState();
    // Use initial values from player
    _playerState = player.state;
    player.getDuration().then(
          (value) => setState(() {
            _duration = value;
          }),
        );
    player.getCurrentPosition().then(
          (value) => setState(() {
            _position = value;
          }),
        );
    _initStreams();
  }

  @override
  void setState(VoidCallback fn) {
    // Subscriptions only can be closed asynchronously,
    // therefore events can occur after widget has been disposed.
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerCtrlcolor = Theme.of(context).secondaryHeaderColor;
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white), color: Colors.black),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                key: const Key('prev_button'),
                onPressed: () => widget.player.skipToPrevious(),
                iconSize: _playerIconSize,
                icon: const Icon(Icons.skip_previous),
                color: playerCtrlcolor,
              ),
              _isPaused
                  ? FloatingActionButton(
                      backgroundColor: playerCtrlcolor,
                      key: const Key('play_button'),
                      onPressed: _play,
                      child: Icon(
                        Icons.play_arrow_rounded,
                        size: _playerIconSize,
                      ),
                      // color: playerCtrlcolor,
                    )
                  : FloatingActionButton(
                      key: const Key('pause_button'),
                      onPressed: _pause,
                      backgroundColor: playerCtrlcolor,
                      child: Icon(
                        Icons.pause,
                        size: _playerIconSize,
                      ),
                    ),
              IconButton(
                key: const Key('next_button'),
                onPressed: () => widget.player.nextSong(),
                iconSize: _playerIconSize,
                icon: const Icon(Icons.skip_next_sharp),
                color: playerCtrlcolor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "🎵 ${widget.player.currentPlaylist.elementAtOrNull(widget.player.playIndex)?.title}",
                        style: TextStyle(fontSize: _playerInfoFontSize),
                      ),
                      GestureDetector(
                        onTap: widget.player.currentPlaylist
                                    .elementAtOrNull(widget.player.playIndex)
                                    ?.album ==
                                null
                            ? null
                            : () => Get.to(AlbumWidget(
                                  albumID: widget.player.currentPlaylist
                                      .elementAt(widget.player.playIndex)
                                      .album!
                                      .id,
                                )),
                        child: Text(
                          "💽 ${widget.player.currentPlaylist.elementAtOrNull(widget.player.playIndex)?.albumName}",
                          style: TextStyle(fontSize: _playerInfoFontSize),
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.player.currentPlaylist
                                    .elementAtOrNull(widget.player.playIndex)
                                    ?.artist ==
                                null
                            ? null
                            : () => Get.to(ArtistWidget(
                                  artistID: widget.player.currentPlaylist
                                      .elementAt(widget.player.playIndex)
                                      .artist!
                                      .id,
                                )),
                        child: Text(
                          "🎤 ${widget.player.currentPlaylist.elementAtOrNull(widget.player.playIndex)?.artistName}",
                          style: TextStyle(fontSize: _playerInfoFontSize),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.player.currentPlaylist
                          .elementAt(widget.player.playIndex)
                          .song
                          .isFavorite
                      ? Container()
                      : IconButton(
                          constraints:
                              BoxConstraints.loose(Size.fromHeight(80)),
                          iconSize: _playerOptionsIconSize,
                          icon: const Icon(
                            Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () async => {
                            await toggleHidden(),
                            await widget.player.nextSong(),
                            setState(() {})
                          },
                        ),
                  IconButton(
                    constraints: BoxConstraints.loose(Size.fromHeight(80)),
                    iconSize: _playerOptionsIconSize,
                    icon: Icon(
                      Icons.favorite,
                      color: widget.player.currentPlaylist
                              .elementAt(widget.player.playIndex)
                              .song
                              .isFavorite
                          ? Colors.red
                          : Colors.white,
                    ),
                    onPressed: () async =>
                        {await toggleFavorite(), setState(() {})},
                  ),
                  IconButton(
                    constraints: BoxConstraints.loose(Size.fromHeight(80)),
                    iconSize: _playerOptionsIconSize,
                    onPressed: () => print("not implemented"),
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Text(
                    _position != null
                        ? _positionText
                        : _duration != null
                            ? _durationText
                            : '',
                    style: TextStyle(fontSize: _playerInfoFontSize),
                  ),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context)
                        .copyWith(overlayShape: SliderComponentShape.noOverlay),
                    child: Slider(
                      activeColor: playerCtrlcolor,
                      onChanged: (v) {
                        final duration = _duration;
                        if (duration == null) {
                          return;
                        }
                        final position = v * duration.inMilliseconds;
                        player.seek(Duration(milliseconds: position.round()));
                      },
                      value: (_position != null &&
                              _duration != null &&
                              _position!.inMilliseconds > 0 &&
                              _position!.inMilliseconds <
                                  _duration!.inMilliseconds)
                          ? _position!.inMilliseconds /
                              _duration!.inMilliseconds
                          : 0.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    _position != null
                        ? _durationText
                        : _duration != null
                            ? _durationText
                            : '',
                    style: TextStyle(fontSize: _playerInfoFontSize),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _initStreams() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      var currSong = widget.player.currentPlaylist[widget.player.playIndex];
      if (currSong.song.duration.isEqual(1) && duration.inSeconds > 1) {
        // print(
        //     "Song ${widget.player.currentPlaylist[widget.player.playIndex].title} duration : ${duration.toString()}");
        (db.update(db.songs)..where((tbl) => tbl.id.equals(currSong.song.id)))
            .writeReturning(
                SongsCompanion(duration: d.Value(duration.inSeconds)));
      }
      setState(() => _duration = duration);
    });

    _positionSubscription = player.onPositionChanged.listen(
      (p) => setState(() => _position = p),
    );

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) async {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
      });
      await widget.player.nextSong();
    });

    _playerStateChangeSubscription =
        player.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });
  }

  Future<void> _play() async {
    final position = _position;
    if (position != null && position.inMilliseconds > 0) {
      await player.seek(position);
    }
    await player.resume();
    setState(() => _playerState = PlayerState.playing);
  }

  Future<void> _pause() async {
    await player.pause();
    setState(() => _playerState = PlayerState.paused);
  }

  // Future<void> _stop() async {
  //   await player.stop();
  //   setState(() {
  //     _playerState = PlayerState.stopped;
  //     _position = Duration.zero;
  //   });
  // }
}
