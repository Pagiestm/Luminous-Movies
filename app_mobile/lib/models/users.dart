class User {
  final String id;
  final String pseudo;
  String email;
  final String role;

  User(this.id, this.pseudo, this.email, this.role);

  User.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String,
        pseudo = json['pseudo'] as String,
        email = json['email'] as String,
        role = json['role'] as String;

  Map<String, dynamic> toJson() => {
        'id' : id,
        'pseudo': pseudo,
        'email': email,
        'role': role
      };
}