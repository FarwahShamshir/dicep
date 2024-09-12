// screens/single_player_screen.dart
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/dice_widget.dart';
import '../widgets/custom_button.dart';

class SinglePlayerScreen extends StatefulWidget {
  @override
  _SinglePlayerScreenState createState() => _SinglePlayerScreenState();
}

class _SinglePlayerScreenState extends State<SinglePlayerScreen> {
  int _currentScore = 0;
  int _totalScore = 0;
  Random _random = Random();

  void _rollDice() {
    int roll = _random.nextInt(6) + 1;
    if (roll == 1) {
      _currentScore = 0;
      _endTurn();
    } else {
      setState(() {
        _currentScore += roll;
      });
    }
  }

  void _hold() {
    setState(() {
      _totalScore += _currentScore;
      _currentScore = 0;
      _checkForWinner();  // Check for a winner after holding
    });
  }

  void _endTurn() {
    setState(() {
      _currentScore = 0;
    });
  }

  void _checkForWinner() {
    if (_totalScore >= 100) {
      _showWinDialog('Player', _totalScore);
    }
  }

  void _showWinDialog(String player, int finalScore) async {
    // Save the highest score locally using SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? highestScore = prefs.getInt('highestScore');
    if (highestScore == null || finalScore > highestScore) {
      await prefs.setInt('highestScore', finalScore);
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$player Wins!'),
        content: Text('Final Score: $finalScore'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/highScores'); // Navigate to High Scores screen
            },
            child: Text('View High Scores'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();  // Close dialog and game screen
            },
            child: Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Single Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Score: $_totalScore',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            DiceWidget(diceValue: _random.nextInt(6) + 1),  // Random dice value for the widget
            SizedBox(height: 20),
            Text(
              'Current Turn: $_currentScore',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            CustomButton(
              label: 'Roll Dice',
              onPressed: _rollDice,
            ),
            SizedBox(height: 10),
            CustomButton(
              label: 'Hold',
              onPressed: _hold,
            ),
          ],
        ),
      ),
    );
  }
}
