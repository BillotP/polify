import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  // bool get _isPlaying => _playerState == PlayerState.playing;

  bool get _isPaused => _playerState == PlayerState.paused;

  String get _durationText => _duration?.toString().split('.').first ?? '';

  String get _positionText => _position?.toString().split('.').first ?? '';

  AudioPlayer get player => widget.player.player;

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () => {}, icon: const Icon(Icons.my_library_music)),
            Expanded(
              child: Text(widget.player.currentPlaylist
                      .elementAt(widget.player.playIndex)
                      .title ??
                  "Unknow title"),
            ),
            IconButton(
              key: const Key('prev_button'),
              // onPressed: _isPlaying || _isPaused ? _stop : null,
              onPressed: () => widget.player.skipToPrevious(),
              iconSize: 48.0,
              icon: const Icon(Icons.skip_previous),
              color: playerCtrlcolor,
            ),
            _isPaused
                ? FloatingActionButton(
                    backgroundColor: playerCtrlcolor,
                    key: const Key('play_button'),
                    onPressed: _play,
                    // iconSize: 48.0,
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      size: 48,
                    ),
                    // color: playerCtrlcolor,
                  )
                : FloatingActionButton(
                    key: const Key('pause_button'),
                    onPressed: _pause,
                    backgroundColor: playerCtrlcolor,
                    child: const Icon(
                      Icons.pause,
                      size: 48,
                    ),
                  ),
            IconButton(
              key: const Key('next_button'),
              // onPressed: _isPlaying || _isPaused ? _stop : null,
              onPressed: () => widget.player.nextSong(),
              iconSize: 48.0,
              icon: const Icon(Icons.skip_next_sharp),
              color: playerCtrlcolor,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: [
              Text(
                _position != null
                    ? _positionText
                    : _duration != null
                        ? _durationText
                        : '',
                style: const TextStyle(fontSize: 16.0),
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
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _initStreams() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
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
