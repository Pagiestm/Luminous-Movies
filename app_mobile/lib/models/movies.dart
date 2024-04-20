class Movie {
  final String id;
  final String title;
  final String synopsis;
  final String image;
  final List<String> staring;
  final String releaseDate;
  final String length;
  final String categorieId;

  Movie({
    required this.id,
    required this.title,
    required this.synopsis,
    required this.image,
    required this.staring,
    required this.releaseDate,
    required this.length,
    required this.categorieId,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['_id'],
      title: json['title'],
      synopsis: json['synopsis'],
      image: json['image'],
      staring: List<String>.from(json['staring']),
      releaseDate: json['release_date'],
      length: json['length'],
      categorieId: json['categorie'],
    );
  }
}