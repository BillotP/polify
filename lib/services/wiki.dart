import 'dart:convert';

import 'package:http/http.dart';

import 'database.dart';

class WikiThumbnail {
  final String mimetype;
  final String url;
  WikiThumbnail(this.mimetype, this.url);
  WikiThumbnail.fromJson(Map<String, dynamic> json)
      : mimetype = json['mimetype'],
        url = json['url'];
}

class WikiInfos {
  final int id;
  final String key;
  final String title;
  final String excerpt;
  final WikiThumbnail? thumbnail;

  WikiInfos(this.id, this.key, this.title, this.excerpt, this.thumbnail);

  WikiInfos.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        key = json['key'],
        title = json['title'],
        excerpt = json['excerpt'],
        thumbnail = json['thumbnail'] != null
            ? WikiThumbnail.fromJson(json['thumbnail'])
            : null;
}

Future<List<WikiInfos>> getInfos(Artist element, Client client) async {
  var url = Uri.https('en.wikipedia.org', '/w/rest.php/v1/search/page',
      {"q": "${element.name} music artist", "limit": "1"});
  var response = await client.get(url);
  // print('Response status: ${response.statusCode}');
  // print('Response body: ${response.body}');
  var articles = jsonDecode(response.body);
  List<WikiInfos> pages = [];
  if (articles['pages'] != null && articles['pages'] != []) {
    pages = List<WikiInfos>.from(
        articles['pages'].map((model) => WikiInfos.fromJson(model)));
  }
  // print("Found ${pages.length} response pages");
  return pages;
}
