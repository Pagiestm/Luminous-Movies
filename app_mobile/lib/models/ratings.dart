class Rating {
  final String id;
  final String movies;
  final String users;
  final int rating;

  Rating({
    required this.id,
    required this.movies,
    required this.users,
    required this.rating,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['_id'],
      movies: json['movies'],
      users: json['users'],
      rating: json['rating'],
    );
  }
}
