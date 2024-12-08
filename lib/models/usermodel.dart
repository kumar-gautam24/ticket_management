class UserModel {
  final String id;
  final String email;
  final String role;

  UserModel({
    required this.id,

    required this.email,
    required this.role,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      email: data['email'],
      role: data['role'],
    );
  }
}
