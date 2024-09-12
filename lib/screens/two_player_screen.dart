// screens/two_player_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TwoPlayerScreen extends StatefulWidget {
  final String roomId;

  TwoPlayerScreen({required this.roomId});

  @override
  _TwoPlayerScreenState createState() => _TwoPlayerScreenState();
}

class _TwoPlayerScreenState extends State<TwoPlayerScreen> {
  DatabaseReference _gameRef = FirebaseDatabase.instance.ref();
  List<dynamic> _players = [];
  int _diceValue = 1;

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  void _loadPlayers() {
    _gameRef.child('rooms').child(widget.roomId).child('players').onValue.listen((DatabaseEvent event) {
      setState(() {
        _players = (event.snapshot.value as Map<dynamic, dynamic>).values.toList();
      });
    });
  }

  void _rollDice() {
    setState(() {
      _diceValue = (1 + (6 * (new DateTime.now().millisecondsSinceEpoch % 1000) ~/ 1000)) % 6 + 1;
    });
    _gameRef.child('rooms').child(widget.roomId).update({
      'diceValue': _diceValue,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multiplayer Game - Room: ${widget.roomId}'),
      ),
      body: Column(
        children: [
          Text('Players in Room:'),
          ..._players.map((player) => Text(player['username'])).toList(),
          SizedBox(height: 20),
          Text('Dice Value: $_diceValue'),
          ElevatedButton(
            onPressed: _rollDice,
            child: Text('Roll Dice'),
          ),
        ],
      ),
    );
  }
}
