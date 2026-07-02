class User {
  final String id;
  final String fullName;
  final String email;
  final String password;
  final String role;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.password,
    this.role = 'user',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'password': password,
      'role': role,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      role: map['role'] ?? 'user',
    );
  }
}
