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
