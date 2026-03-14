class Webtoon {
  final String id;
  final String title;
  final String thumbnail;
  final String description;
  final List<String> genres;

  Webtoon({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.description,
    required this.genres,
  });

  factory Webtoon.fromJson(Map<String, dynamic> json) {
    return Webtoon(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      description: json['description'],
      genres: List<String>.from(json['genres'] ?? []),
    );
  }

  factory Webtoon.fromMangadexJson(Map<String, dynamic> json) {
    final attributes = json['attributes'] as Map<String, dynamic>? ?? {};
    String title =
        (attributes['title'] as Map<String, dynamic>? ?? {})['en'] ?? 'Unknown';
    String description = attributes['description']?.toString() ?? '';
    String thumbnail = '';
    final relationships = json['relationships'] as List<dynamic>? ?? [];
    for (var rel in relationships) {
      if (rel['type'] == 'cover_art') {
        final relAttr = rel['attributes'] as Map<String, dynamic>? ?? {};
        final fileName = relAttr['fileName']?.toString() ?? '';
        if (fileName.isNotEmpty) {
          thumbnail =
              'https://uploads.mangadex.org/covers/${json['id']}/$fileName.512.jpg';
          break;
        }
      }
    }
    List<String> genres = [];
    final tags = attributes['tags'] as List<dynamic>? ?? [];
    for (var tag in tags) {
      final tagAttr = tag['attributes'] as Map<String, dynamic>? ?? {};
      final nameMap = tagAttr['name'] as Map<String, dynamic>? ?? {};
      final name = nameMap['en']?.toString() ?? '';
      if (name.isNotEmpty) {
        genres.add(name);
      }
    }
    return Webtoon(
      id: json['id']?.toString() ?? '',
      title: title,
      thumbnail: thumbnail,
      description: description,
      genres: genres,
    );
  }
}
