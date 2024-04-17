class User {
  final String pseudo;
  final String email;
  final String role;

  User(this.pseudo, this.email, this.role);

  User.fromJson(Map<String, dynamic> json)
      : pseudo = json['pseudo'] as String,
        email = json['email'] as String,
        role = json['role'] as String;

  Map<String, dynamic> toJson() => {
        'pseudo': pseudo,
        'email': email,
        'role': role
      };
}