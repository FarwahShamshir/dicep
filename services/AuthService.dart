import 'package:firebase_auth/firebase_auth.dart';
import 'DatabaseService.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up user with email and password and store username in Realtime Database
  Future<User?> signUp(String email, String password, String username) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = result.user;

    if (user != null) {
      // Save username to the Realtime Database
      await DatabaseService().addUser(user.uid, username, email);
    }
    return user;
  }

  // Sign in anonymously
  Future<User?> signInAnonymously() async {
    UserCredential userCredential = await _auth.signInAnonymously();
    return userCredential.user;
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  // Sign out user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Sign in user and handle errors
  void _signIn(BuildContext context, TextEditingController emailController, TextEditingController passwordController) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      await signInWithEmailAndPassword(email, password);
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user found for that email.')),
        );
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wrong password provided.')),
        );
      } else {
        print('Error: ${e.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      }
    } catch (e) {
      print('Unknown error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unknown error occurred. Please try again.')),
      );
    }
  }
}
