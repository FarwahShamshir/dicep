// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/AuthService.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  User? user;
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _signInAnonymously(); // Automatically sign in the user anonymously for now
  }

  Future<void> _signInAnonymously() async {
    try {
      user = await _authService.signInAnonymously(); // Sign in anonymously if needed
    } catch (e) {
      // Handle sign-in error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-in failed. Please try again.')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Stop showing the loading indicator
      });
    }
  }

  void _signOut() async {
    await _authService.signOut(); // Sign the user out
    Navigator.pushReplacementNamed(context, '/signin'); // Return to the Signin screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dice Game'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator() // Show loading indicator while signing in
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CustomButton(
                  label: 'Single Player',
                  onPressed: () {
                    Navigator.pushNamed(context, '/singlePlayer');
                  },
                ),
                SizedBox(height: 10),
                CustomButton(
                  label: 'Play with AI',
                  onPressed: () {
                    Navigator.pushNamed(context, '/aiOpponent');
                  },
                ),
                SizedBox(height: 10),
                CustomButton(
                  label: 'Invite Players',
                  onPressed: () {
                    Navigator.pushNamed(context, '/invite');
                  },
                ),
                SizedBox(height: 10),
                CustomButton(
                  label: 'Two Player Mode',
                  onPressed: () {
                    Navigator.pushNamed(context, '/twoPlayer', arguments: 'room_id_here'); // Replace with actual room ID
                  },
                ),
                SizedBox(height: 30),
                CustomButton(
                  label: 'Settings',
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
                SizedBox(height: 10),
                CustomButton(
                  label: 'Rules',
                  onPressed: () {
                    Navigator.pushNamed(context, '/rules');
                  },
                ),
                SizedBox(height: 10),
                CustomButton(
                  label: 'High Scores',
                  onPressed: () {
                    Navigator.pushNamed(context, '/highScores');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
