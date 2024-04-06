class User {
  final String pseudo;
  final String email;

  User(this.pseudo, this.email);

  User.fromJson(Map<String, dynamic> json)
      : pseudo = json['pseudo'] as String,
        email = json['email'] as String;

  Map<String, dynamic> toJson() => {
        'pseudo': pseudo,
        'email': email,
      };
}