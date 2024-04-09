import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../localdb/my_db.dart';
import '../models/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late MyDB db;
  List<User> _users = []; // List to store retrieved users

  // Text Editing Controllers for user input
  final _userIdController = TextEditingController();
  final _userNameController = TextEditingController();
  final _profileURLController = TextEditingController();

  @override
  void initState() {
    super.initState();
    db = context.read<MyDB>();
    _getUsers();
  }

  Future<void> _getUsers() async {
    _users = await db.getAllUsers();
    setState(() {});
  }

  Future<void> _addUser() async {
    // Get user data from Text Editing Controllers
    final userId = _userIdController.text;
    final userName = _userNameController.text;
    final profileURL = _profileURLController.text;

    final user = User(
      userId: userId,
      name: userName,
      profileUrl: profileURL,
      isSubscribed: false,
    );

    await db.insertUser(user);
    // refresh Users
    _getUsers();

    // Clear text fields after successful insertion (optional)
    _userIdController.text = '';
    _userNameController.text = '';
    _profileURLController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Database Example'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            // User input section
            TextField(
              controller: _userIdController,
              decoration: const InputDecoration(labelText: 'User ID'),
            ),
            TextField(
              controller: _userNameController,
              decoration: const InputDecoration(labelText: 'User Name'),
            ),
            TextField(
              controller: _profileURLController,
              decoration: const InputDecoration(labelText: 'Profile URL'),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _addUser,
              child: const Text('Add User'),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  title: Text(user.name),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

