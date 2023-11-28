import 'dart:async';

import 'package:drift/drift.dart' as d;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polify/services/database.dart';
import 'package:polify/services/player.dart';

class MobilePlayerWidget extends StatefulWidget {
  final PlayerService player = Get.find();

  MobilePlayerWidget({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _MobilePlayerWidgetState();
  }
}

class _MobilePlayerWidgetState extends State<MobilePlayerWidget> {
  PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;
  final double _playerIconSize = 12.0;
  final double _playerOptionsIconSize = 18.0;

  final double _playerInfoFontSize = 12;

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

  Future setFavorite(bool v) async {
    widget.player.currentPlaylist.elementAt(widget.player.playIndex).song =
        (await (db.songs.update()
                  ..where((tbl) => tbl.id.equals(widget.player.currentPlaylist
                      .elementAt(widget.player.playIndex)
                      .songId)))
                .writeReturning(SongsCompanion(isFavorite: d.Value(v))))
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
      alignment: Alignment.topCenter,
      height: 110,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white), color: Colors.black),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(right: 2),
                decoration: const BoxDecoration(
                    border: Border(right: BorderSide(color: Colors.white))),
                child: Column(
                  children: [
                    GestureDetector(
                      child: Icon(
                        Icons.favorite,
                        size: _playerOptionsIconSize,
                        color: widget.player.currentPlaylist
                                .elementAt(widget.player.playIndex)
                                .song
                                .isFavorite
                            ? Colors.red
                            : Colors.white,
                      ),
                      onTap: () async => {
                        await setFavorite(!widget.player.currentPlaylist
                            .elementAt(widget.player.playIndex)
                            .song
                            .isFavorite),
                        setState(() {})
                      },
                    ),
                    Icon(
                      Icons.heart_broken,
                      size: _playerOptionsIconSize,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.more_vert,
                      size: _playerOptionsIconSize,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "🎵 ${widget.player.currentPlaylist[widget.player.playIndex].title.trim()}",
                      style: TextStyle(fontSize: _playerInfoFontSize),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "💽 ${widget.player.currentPlaylist[widget.player.playIndex].albumName}",
                      style: TextStyle(fontSize: _playerInfoFontSize),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "🎤 ${widget.player.currentPlaylist[widget.player.playIndex].artistName}",
                      style: TextStyle(fontSize: _playerInfoFontSize),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
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
                          mini: true,
                          child: Icon(
                            Icons.play_arrow_rounded,
                            size: _playerIconSize,
                          ),
                          // color: playerCtrlcolor,
                        )
                      : FloatingActionButton(
                          key: const Key('pause_button'),
                          onPressed: _pause,
                          mini: true,
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
                ],
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _position != null
                    ? _positionText
                    : _duration != null
                        ? _durationText
                        : '',
                style: TextStyle(fontSize: _playerInfoFontSize),
              ),
              Expanded(
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
                          _position!.inMilliseconds < _duration!.inMilliseconds)
                      ? _position!.inMilliseconds / _duration!.inMilliseconds
                      : 0.0,
                ),
              ),
              Text(
                _position != null
                    ? _durationText
                    : _duration != null
                        ? _durationText
                        : '',
                style: TextStyle(fontSize: _playerInfoFontSize),
              ),
            ],
          ),
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
