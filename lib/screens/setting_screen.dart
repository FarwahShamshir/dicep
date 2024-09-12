// screens/setting_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _targetScore = 100;
  String _difficulty = 'Medium';
  bool _darkTheme = false; // This will control the theme mode

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _targetScore = await SettingsService.loadTargetScore();
    _difficulty = await SettingsService.loadDifficulty();
    _darkTheme = await SettingsService.loadThemePreference();
    setState(() {});
  }

  void _saveSettings() {
    SettingsService.saveTargetScore(_targetScore);
    SettingsService.saveDifficulty(_difficulty);
    SettingsService.saveThemePreference(_darkTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Target Score',
              style: TextStyle(fontSize: 20),
            ),
            DropdownButton<int>(
              value: _targetScore,
              items: [50, 100, 150, 200].map((score) {
                return DropdownMenuItem<int>(
                  value: score,
                  child: Text(score.toString()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _targetScore = value!;
                  _saveSettings();
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'AI Difficulty',
              style: TextStyle(fontSize: 20),
            ),
            DropdownButton<String>(
              value: _difficulty,
              items: ['Easy', 'Medium', 'Hard'].map((difficulty) {
                return DropdownMenuItem<String>(
                  value: difficulty,
                  child: Text(difficulty),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _difficulty = value!;
                  _saveSettings();
                });
              },
            ),
            SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListTile(
                  leading: Icon(Icons.light_mode),
                  title: Text('Light Theme'),
                  onTap: () {
                    setState(() {
                      _darkTheme = false; // Set light theme preference
                    });
                    Get.changeThemeMode(ThemeMode.light); // Switch to light theme
                    _saveSettings(); // Save the theme preference
                  },
                ),
                ListTile(
                  leading: Icon(Icons.dark_mode),
                  title: Text('Dark Theme'),
                  onTap: () {
                    setState(() {
                      _darkTheme = true; // Set dark theme preference
                    });
                    Get.changeThemeMode(ThemeMode.dark); // Switch to dark theme
                    _saveSettings(); // Save the theme preference
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
