import 'package:flutter_test/flutter_test.dart';
import 'package:ticket_management/repos/user_repo.dart';
import 'package:ticket_management/models/user_model.dart';

void main() {
  final UserRepo userRepo = UserRepo();

  group('UserRepo Integration Tests', () {
    test('getUserRole returns correct role', () async {
      // Arrange
      final userId = 'testUserId';
      // Act
      final role = await userRepo.getUserRole(userId);
      // Assert
      expect(role, isNotNull);
      expect(role, 'user'); // Assuming 'user' is the default role
    });

    test('getUserId returns current user ID', () {
      // Act
      final userId = userRepo.getUserId();
      // Assert
      expect(userId, isNotNull);
    });

    test('deleteUser removes user successfully', () async {
      // Arrange
      final userId = 'testUserIdToDelete';
      // Act
      await userRepo.deleteUser(userId);
      // Assert
      // Verify user deletion by attempting to fetch the user role
      expect(() async => await userRepo.getUserRole(userId), throwsException);
    });

    test('getUserByRole returns list of users with specified role', () async {
      // Arrange
      final role = 'employee';
      // Act
      final users = await userRepo.getUserByRole(role);
      // Assert
      expect(users, isNotEmpty);
      expect(users, isA<List<UserModel>>());
    });
  });
}
