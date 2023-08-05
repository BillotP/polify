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
      onTap: () => Get.to(AlbumWidget(album: album)),
    );

Widget albumCardTile(
        Album album, void Function(Album album, bool now) onAlbumPlay) =>
    Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              iconSize: 100,
              onPressed: () => Get.to(AlbumWidget(album: album)),
              icon: album.imageUrl != null
                  ? Image.network(album.imageUrl!)
                  : const Icon(Icons.album_sharp)),
          Text(
            album.name,
            style: const TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          Row(
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
        ],
      ),
    );
