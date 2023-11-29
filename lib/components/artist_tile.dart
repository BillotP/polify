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
      onTap: () => Get.to(ArtistWidget(artistID: artist.id)),
    );

// Future<void> _updateImage(ImageProvider provider) async {
//     final ColorScheme newColorScheme = await ColorScheme.fromImageProvider(
//         provider: provider,
//         brightness: isLight ? Brightness.light : Brightness.dark);
//     setState(() {
//       selectedImage = widget.images.indexOf(provider);
//       currentColorScheme = newColorScheme;
//     });
//   }

Widget artistCardTile(
        Artist artist, void Function(Artist artist, bool now) onArtistPlay) =>
    Card(
      // color: artist.imageUrl != null ?  ColorScheme.fromImageProvider(provider: NetworkImage(artist.imageUrl!)) : null,
      color: Colors.black,
      shape:
          const RoundedRectangleBorder(side: BorderSide(color: Colors.white)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: IconButton(
                iconSize: 100,
                splashRadius: 100,
                onPressed: () => Get.to(ArtistWidget(artistID: artist.id)),
                icon: artist.imageUrl != null
                    ? CircleAvatar(
                        radius: 100,
                        foregroundImage:
                            NetworkImage(artist.imageUrl!, scale: 0.5),
                      )
                    : CircleAvatar(
                        radius: 100,
                        child: Text(
                            "${artist.name.split(" ").first.characters.first} ${artist.name.split(" ").last.characters.first}"),
                      )),
          ),
          Expanded(
            child: Center(
              child: TextButton(
                onPressed: () => Get.to(ArtistWidget(artistID: artist.id)),
                child: Text(
                  artist.name,
                  style: const TextStyle(
                      color: Colors.white, backgroundColor: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () => onArtistPlay(artist, true),
                  icon: const Icon(Icons.play_circle_fill)),
              IconButton(
                  onPressed: () => onArtistPlay(artist, false),
                  icon: const Icon(Icons.playlist_add)),
              // IconButton(
              //     onPressed: () => onAlbumDownload(album),
              //     icon: const Icon(Icons.download_for_offline))
            ],
          ),
        ],
      ),
    );
