// import 'package:drift/drift.dart' as d;
// import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polify/services/database.dart';
// import 'package:posthog_flutter/posthog_flutter.dart';

class BucketWidget extends StatefulWidget {
  final MusicBucket bucket;
  const BucketWidget({required this.bucket, super.key});

  @override
  State<BucketWidget> createState() => _BucketWidgetState();
}

class _BucketWidgetState extends State<BucketWidget> {
  MusicBucket get bucket => widget.bucket;
  LocalDB db = Get.find();
  void _pickFile() async {
    // opens storage to pick files and the picked file or files
    // are assigned into result and if no file is chosen result is null.
    // you can also toggle "allowMultiple" true or false depending on your need
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    // if no file is picked
    if (result == null) return;

    // we will log the name, size and path of the
    // first picked file (if multiple are selected)
    // print(result.files.first.name);
    // print(result.files.first.size);
    // print(result.files.first.path);
    // TODO(bucket): implement upload file to bucket
  }

  @override
  Widget build(BuildContext context) {
    // if (Platform.isAndroid || Platform.isIOS) {
    //   Posthog().screen(
    //     screenName: 'Bucket Screen',
    //   );
    // }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(bucket.name.toUpperCase()),
        titleTextStyle: const TextStyle(color: Colors.white),
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Navigator.pop(context, "hello"),
            icon: const Icon(Icons.backspace)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: (MediaQuery.of(context).size.height + 100) / 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("ID : ${bucket.id}"),
                  Text("Name : ${bucket.name}"),
                  Text(
                      "Music Folder Prefix : ${bucket.musicFolderPrefix ?? '--'}"),
                ],
              ),
            ),
            FloatingActionButton(
              backgroundColor: Colors.deepPurple,
              tooltip: "Upload songs to bucket",
              onPressed: () => _pickFile(),
              child: const Icon(Icons.upload_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
