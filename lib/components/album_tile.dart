import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polify/screens/album.dart';
import 'package:polify/services/database.dart';

Widget albumListTile(
        Album album, void Function(Album album, bool now) onAlbumPlay) =>
    ListTile(
      shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2, color: Colors.white),
          borderRadius: BorderRadius.circular(20)),
      leading: album.imageUrl != null
          ? Image.network(album.imageUrl!)
          : const Icon(Icons.album_sharp),
      title: Text(album.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              onPressed: () => onAlbumPlay(album, true),
              icon: const Icon(Icons.play_circle_fill)),
          IconButton(
              onPressed: () => onAlbumPlay(album, false),
              icon: const Icon(Icons.playlist_add))
        ],
      ),
      onTap: () => Get.to(AlbumWidget(albumID: album.id)),
    );

Widget albumCardTile(
        Album album, void Function(Album album, bool now) onAlbumPlay) =>
    Card(
      child: Container(
        decoration: album.imageBlob != null
            ? BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill, image: MemoryImage(album.imageBlob!)),
              )
            : const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/icon/default_album.png")),
              ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: IconButton(
                  iconSize: 100,
                  splashRadius: 100,
                  onPressed: () => Get.to(AlbumWidget(albumID: album.id)),
                  icon: album.imageBlob != null
                      ? Image.memory(album.imageBlob!)
                      : const Icon(Icons.album_sharp)),
            ),
            Expanded(
              child: TextButton(
                onPressed: () => Get.to(AlbumWidget(albumID: album.id)),
                child: Text(
                  album.name,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      backgroundColor: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Card(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () => onAlbumPlay(album, true),
                      icon: const Icon(Icons.play_circle_fill)),
                  IconButton(
                      onPressed: () => onAlbumPlay(album, false),
                      icon: const Icon(Icons.playlist_add)),
                  // IconButton(
                  //     onPressed: () => onAlbumDownload(album),
                  //     icon: const Icon(Icons.download_for_offline))
                ],
              ),
            ),
          ],
        ),
      ),
    );
