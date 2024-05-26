class Rating {
  final String id;
  final String movie;
  final String user;
  final int rating;

  Rating({
    required this.id,
    required this.movie,
    required this.user,
    required this.rating,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['_id'],
      movie: json['movie'],
      user: json['user'],
      rating: json['rating'],
    );
  }
}
