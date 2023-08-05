import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polify/screens/artist.dart';
import 'package:polify/services/database.dart';

Widget artistListTile(
        Artist artist, void Function(Artist artist, bool now) onArtistPlay) =>
    ListTile(
      shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2, color: Colors.white),
          borderRadius: BorderRadius.circular(10)),
      leading: artist.imageUrl != null
          ? Image.network(artist.imageUrl!)
          : const Icon(Icons.person_3_outlined),
      title: Text(artist.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              onPressed: () => onArtistPlay(artist, true),
              icon: const Icon(Icons.play_circle_fill)),
          IconButton(
              onPressed: () => onArtistPlay(artist, false),
              icon: const Icon(Icons.playlist_add))
        ],
      ),
      onTap: () => Get.to(ArtistWidget(artist: artist)),
    );
