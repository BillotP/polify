import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polify/services/bucket.dart';
import 'package:polify/services/database.dart';

class SettingsWidget extends StatelessWidget {
  final LocalDB db = Get.find();
  final MusicBucketsService srv = Get.find();

  SettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Theme.of(context).colorScheme.background,
          backgroundColor: Colors.black,
          title: Text("Settings"),
          titleTextStyle: const TextStyle(color: Colors.white),
          centerTitle: true,
          leading: IconButton(
              onPressed: () => Navigator.pop(context, "hello"),
              icon: const Icon(
                Icons.backspace,
                color: Colors.white,
              )),
        ),
        body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.white,
                  heroTag: "refreshMode",
                  onPressed: () async {
                    Get.snackbar("Info", "Will update 30 album jackets");
                    await srv.loadJackets(30);
                    Get.snackbar("Info", "Will update 30 artists infos");
                    await srv.loadArtists(30);
                  },
                  tooltip: 'Refresh Metadatas',
                  child: const Icon(Icons.rule_folder_sharp),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.white,
                  heroTag: "refreshBucket",
                  onPressed: () async {
                    await srv.loadBuckets();
                  },
                  tooltip: 'Refresh Bucket List',
                  child: const Icon(Icons.refresh),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.white,
                  heroTag: "cleanAll",
                  tooltip: 'Clear All',
                  child: const Icon(Icons.delete_forever_outlined),
                  onPressed: () => deleteEverything(db),
                ),
              ),
            ]));
  }
}
