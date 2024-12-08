import 'package:flutter/material.dart';

class AddUserScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  AddUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add User/Employee')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: roleController,
              decoration: const InputDecoration(labelText: 'Role (user/employee)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add user to Firestore
                final name = nameController.text.trim();
                final email = emailController.text.trim();
                final role = roleController.text.trim();
                if (name.isNotEmpty && email.isNotEmpty && role.isNotEmpty) {
                  // Call Firestore repository to add user
                }
              },
              child: const Text('Add User'),
            ),
          ],
        ),
      ),
    );
  }
}
