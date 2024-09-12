// screens/ai_opponent_screen.dart
import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/dice_widget.dart';
import '../widgets/custom_button.dart';

class AIOpponentScreen extends StatefulWidget {
  @override
  _AIOpponentScreenState createState() => _AIOpponentScreenState();
}

class _AIOpponentScreenState extends State<AIOpponentScreen> {
  int _playerScore = 0;
  int _aiScore = 0;
  int _currentPlayerScore = 0;
  int _currentAIScore = 0;
  int _diceValue = 1;  // Track the current dice value to display
  Random _random = Random();
  bool _playerTurn = true;

  void _rollDice() async {
    int roll = _random.nextInt(6) + 1;
    setState(() {
      _diceValue = roll;  // Update dice value for the UI
    });

    if (_playerTurn) {
      if (roll == 1) {
        _currentPlayerScore = 0;
        _switchTurn();
      } else {
        setState(() {
          _currentPlayerScore += roll;
        });
      }
    } else {
      if (roll == 1) {
        _currentAIScore = 0;
        _switchTurn();
      } else {
        setState(() {
          _currentAIScore += roll;
        });

        await Future.delayed(Duration(seconds: 1));  // Simulate AI thinking delay

        if (_currentAIScore >= 20 || _aiScore + _currentAIScore >= 100) {
          _aiScore += _currentAIScore;
          _currentAIScore = 0;
          if (_aiScore >= 100) {
            _showWinDialog('AI');
          } else {
            _switchTurn();
          }
        } else {
          _rollDice();  // AI rolls again
        }
      }
    }
  }

  void _hold() {
    if (_playerTurn) {
      setState(() {
        _playerScore += _currentPlayerScore;
        _currentPlayerScore = 0;
        if (_playerScore >= 100) {
          _showWinDialog('Player');
        } else {
          _switchTurn();
        }
      });
    }
  }

  void _switchTurn() {
    setState(() {
      _playerTurn = !_playerTurn;
    });
    if (!_playerTurn) {
      Future.delayed(Duration(seconds: 1), _rollDice);
    }
  }

  void _showWinDialog(String winner) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$winner Wins!'),
        content: Text('Final Score: Player: $_playerScore, AI: $_aiScore'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
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
        title: Text('Play with AI'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Player Score with Human Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, size: 40, color: _playerTurn ? Colors.blue : Colors.grey),
                SizedBox(width: 10),
                Text(
                  'Player Score: $_playerScore',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
            SizedBox(height: 10),
            // AI Score with Robot Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.smart_toy, size: 40, color: !_playerTurn ? Colors.blue : Colors.grey),
                SizedBox(width: 10),
                Text(
                  'AI Score: $_aiScore',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Current Turn Indicator (Human or AI)
            Text(
              _playerTurn ? 'Your Turn' : 'AI\'s Turn',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            // Dice Widget
            DiceWidget(diceValue: _diceValue),  // Display the current dice value
            SizedBox(height: 20),
            // Player Controls (only shown if it's the player's turn)
            if (_playerTurn)
              CustomButton(
                label: 'Roll Dice',
                onPressed: _rollDice,
              ),
            if (_playerTurn)
              SizedBox(height: 10),
            if (_playerTurn)
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
