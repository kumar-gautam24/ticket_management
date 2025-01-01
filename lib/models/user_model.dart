class UserModel {
  final String name;
  final String id;
  final String email;
  final String role;

  UserModel({
    required this.name,
    required this.id,
    required this.email,
    required this.role,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      name:data['name'],
      email: data['email'],
      role: data['role'],
    );
  }
}
