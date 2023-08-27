import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polify/services/player_service.dart';

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
      backgroundColor: Colors.black,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text("Current Playlist"),
            Text("Titles : ${pls.currentPlaylist.length}"),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => {},
                  icon: const Icon(Icons.save),
                ),
                IconButton(
                  onPressed: () => {},
                  icon: const Icon(Icons.offline_pin_rounded),
                ),
                IconButton(
                  onPressed: () => {},
                  icon: const Icon(Icons.delete_forever_outlined),
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: pls.currentPlaylist.length,
                itemBuilder: (context, index) => ListTile(
                  dense: true,
                  onTap: () async =>
                      {await pls.playIndexSong(index), setState(() {})},
                  leading: const Icon(Icons.playlist_add_check_circle),
                  trailing: pls.playIndex == index
                      ? const Icon(Icons.headset_rounded)
                      : null,
                  title: Text(pls.currentPlaylist.elementAt(index).title ??
                      "Unknow title"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
