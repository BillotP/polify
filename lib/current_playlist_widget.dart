import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polify/player_service.dart';

class CurrentPlaylistWidget extends StatefulWidget {
  const CurrentPlaylistWidget({super.key});

  @override
  State<CurrentPlaylistWidget> createState() => _CurrentPlaylistWidgetState();
}

class _CurrentPlaylistWidgetState extends State<CurrentPlaylistWidget> {
  PlayerService pls = Get.find();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.builder(
        itemCount: pls.currentPlaylist.length,
        itemBuilder: (context, index) => ListTile(
          dense: true,
          title: Text(
              pls.currentPlaylist.elementAt(index).title ?? "Unknow title"),
        ),
      ),
    );
  }
}
