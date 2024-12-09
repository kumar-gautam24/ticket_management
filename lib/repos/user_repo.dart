import 'package:ticket_management/services/user_services.dart';

class UserRepo {
  final UserServices _userServices = UserServices();
// get user role
  Future<String> getUserRole(String userId) =>
      _userServices.getUserRole(userId);
// get userId for the current user
  getUserId() => UserServices().getUserId();

  // delete the user
  Future<void> deleteUser(String userId) => _userServices.deleteUser(userId);
// list of users by role
   getUserByRole(String role) =>
      _userServices.getUserByRole(role);
}
