import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polify/screens/bucket.dart';
import 'package:polify/services/database.dart';

Widget bucketListTile(MusicBucket bucket, bool loading,
        void Function(MusicBucket bucket) onRefreshBucketContent) =>
    ListTile(
      shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2, color: Colors.white),
          borderRadius: BorderRadius.circular(10)),
      leading: const Icon(Icons.storage_rounded),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          loading
              ? Transform.scale(
                  scale: 0.5,
                  child: const CircularProgressIndicator(),
                )
              : IconButton(
                  onPressed: () => onRefreshBucketContent(bucket),
                  icon: const Icon(Icons.refresh)),
        ],
      ),
      onTap: () => Get.to(BucketWidget(bucket: bucket)),
      title: Text(bucket.name),
    );
