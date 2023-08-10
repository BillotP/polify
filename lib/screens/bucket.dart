// import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polify/services/database.dart';

class BucketWidget extends StatefulWidget {
  final MusicBucket bucket;
  const BucketWidget({required this.bucket, super.key});

  @override
  State<BucketWidget> createState() => _BucketWidgetState();
}

class _BucketWidgetState extends State<BucketWidget> {
  MusicBucket get bucket => widget.bucket;
  LocalDB db = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(bucket.name),
        centerTitle: true,
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
                  Text("ID ${bucket.id} - ${bucket.name}"),
                  Text(
                      "Music Folder Prefix : ${bucket.musicFolderPrefix ?? '--'}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
