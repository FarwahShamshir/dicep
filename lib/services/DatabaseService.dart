// services/database_service.dart
import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  // Add new user to the database
  Future<void> addUser(String userId, String username, String email) async {
    await _db.child('users').child(userId).set({
      'username': username,
      'email': email,
      'status': 'available',
    });
  }

  // Send an invite to another user
  Future<void> sendInvite(String senderId, String receiverId) async {
    await _db.child('invites').push().set({
      'senderId': senderId,
      'receiverId': receiverId,
      'status': 'pending',
    });
  }

  // Accept an invite
  Future<void> acceptInvite(String inviteId) async {
    await _db.child('invites').child(inviteId).update({'status': 'accepted'});
  }

  // Get all users
  Stream<DatabaseEvent> getUsers() {
    return _db.child('users').onValue;
  }

  // Save a high score
  Future<void> saveHighScore(String playerName, int score) async {
    await _db.child('highscores').push().set({
      'playerName': playerName,
      'score': score,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // Get high scores from the database
  Stream<DatabaseEvent> getHighScores() {
    return _db
        .child('highscores')
        .orderByChild('score')
        .limitToLast(10) // Limit to top 10 scores
        .onValue; // Listen to changes in the database
  }

  // Get all invites for the current user
  Stream<DatabaseEvent> getInvites(String userId) {
    return _db.child('invites').orderByChild('receiverId').equalTo(userId).onValue;
  }
}
