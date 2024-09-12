// screens/high_score_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../services/DatabaseService.dart';
class HighScoresScreen extends StatelessWidget {
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('High Scores'),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: _databaseService.getHighScores(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(child: CircularProgressIndicator());
          }
          final scores = (snapshot.data!.snapshot.value as Map<dynamic, dynamic>).values.toList();
          scores.sort((a, b) => b['score'].compareTo(a['score'])); // Sort by score

          return ListView.builder(
            itemCount: scores.length,
            itemBuilder: (context, index) {
              final scoreData = scores[index];
              return ListTile(
                title: Text(scoreData['playerName']),
                trailing: Text(scoreData['score'].toString()),
              );
            },
          );
        },
      ),
    );
  }
}
