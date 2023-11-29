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
    return Column(
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(color: Colors.black),
          child: ListTile(
            title: Text(
              "Playing Now",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Expanded(
          child: ReorderableListView.builder(
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
              dense: true,
              selected: index == pls.playIndex,
              selectedTileColor: Colors.grey,
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
                      pls.currentPlaylist.removeWhere((element) => element
                          .songId
                          .isEqual(pls.currentPlaylist[index].songId)),
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
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pls.currentPlaylist[index].title,
                        style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        pls.currentPlaylist[index].albumName,
                        style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.clip,
                      ),
                      Text(
                        pls.currentPlaylist[index].artistName,
                        style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.clip,
                      ),
                    ],
                  )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Duration(
                              seconds: pls.currentPlaylist[index].song.duration)
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
          ),
        ),
      ],
    );
  }
}
