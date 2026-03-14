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
      genres: List<String>.from(json['genres']),
    );
  }
}
