// screens/invite_screen.dart
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/DatabaseService.dart';

class InviteScreen extends StatefulWidget {
  @override
  _InviteScreenState createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  List<dynamic> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    _databaseService.getUsers().listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        _users = data.values.toList();
      });
    });
  }

  void _sendInvite(String receiverId) {
    if (currentUser != null) {
      _databaseService.sendInvite(currentUser!.uid, receiverId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invite Players'),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          if (user['email'] != currentUser?.email) {
            return ListTile(
              title: Text(user['username']),
              trailing: ElevatedButton(
                onPressed: () => _sendInvite(user['userId']),
                child: Text('Invite'),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
