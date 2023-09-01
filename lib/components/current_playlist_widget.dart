import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polify/services/player.dart';

class CurrentPlaylistWidget extends StatefulWidget {
  const CurrentPlaylistWidget({super.key});

  @override
  State<CurrentPlaylistWidget> createState() => _CurrentPlaylistWidgetState();
}

class _CurrentPlaylistWidgetState extends State<CurrentPlaylistWidget> {
  PlayerService pls = Get.find();
  // Row(
  //   mainAxisSize: MainAxisSize.max,
  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //   children: [
  //     Text("Current Playlist Titles : ${pls.currentPlaylist.length}"),
  //     Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         IconButton(
  //           onPressed: () => {},
  //           tooltip: "Save",
  //           color: Colors.white,
  //           icon: const Icon(Icons.save),
  //         ),
  //         IconButton(
  //           onPressed: () => {},
  //           color: Colors.white,
  //           tooltip: "Clear",
  //           icon: const Icon(Icons.delete_forever_outlined),
  //         )
  //       ],
  //     ),
  //   ],
  // ),

  @override
  void initState() {
    pls.player.eventStream.listen((event) {
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (pls.currentPlaylist.isEmpty) {
      return const Center(
        child: Text("Go listen to some music !"),
      );
    }
    return ReorderableListView.builder(
      buildDefaultDragHandles: false,
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final SongToplay item = pls.currentPlaylist.removeAt(oldIndex);
          pls.currentPlaylist.insert(newIndex, item);
        });
      },
      itemCount: pls.currentPlaylist.length,
      itemBuilder: (context, index) => ListTile(
        // tileColor: Colors.orange,
        dense: true,
        trailing: ReorderableDragStartListener(
            index: index,
            child: const Icon(
              Icons.drag_indicator_outlined,
              color: Colors.white,
            )),
        key: Key(pls.currentPlaylist[index].songId.toString()),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle),
              color: Colors.white,
              onPressed: () => {
                pls.currentPlaylist.removeWhere((element) =>
                    element.songId.isEqual(pls.currentPlaylist[index].songId)),
                setState(() {})
              },
            ),
            IconButton(
                icon: const Icon(Icons.play_arrow),
                color: Colors.white,
                onPressed: () async =>
                    {await pls.playIndexSong(index), setState(() {})}),
          ],
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                child: Text(
              pls.currentPlaylist.elementAt(index).title ?? "Unknow title",
              style: const TextStyle(color: Colors.white),
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                Duration(
                        seconds:
                            pls.currentPlaylist.elementAt(index).song.duration)
                    .toString()
                    .split(".")
                    .first,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            pls.playIndex == index
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.headphones,
                      color: Colors.white,
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
