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

Widget bucketCardTile(MusicBucket bucket, bool loading,
        void Function(MusicBucket bucket) onRefreshBucketContent) =>
    Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: IconButton(
                iconSize: 100,
                splashRadius: 100,
                onPressed: () => Get.to(BucketWidget(bucket: bucket)),
                icon: const Icon(Icons.storage_rounded)),
          ),
          Expanded(
            child: Center(
              child: IconButton(
                onPressed: () => Get.to(BucketWidget(bucket: bucket)),
                icon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      bucket.name,
                      style: const TextStyle(
                          color: Colors.black, backgroundColor: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      bucket.endpoint,
                      style: const TextStyle(
                          color: Colors.black, backgroundColor: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
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
        ],
      ),
    );
