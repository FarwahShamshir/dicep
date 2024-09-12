// services/settings_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _keyTargetScore = 'target_score';
  static const String _keyDifficulty = 'difficulty';
  static const String _keyTheme = 'dark_theme';

  // Save the target score
  static Future<void> saveTargetScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_keyTargetScore, score);
  }

  // Load the target score
  static Future<int> loadTargetScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyTargetScore) ?? 100; // Default target score is 100
  }

  // Save the game difficulty
  static Future<void> saveDifficulty(String difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyDifficulty, difficulty);
  }

  // Load the game difficulty
  static Future<String> loadDifficulty() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDifficulty) ?? 'Medium'; // Default difficulty is 'Medium'
  }

  // Save the theme preference (light or dark)
  static Future<void> saveThemePreference(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_keyTheme, isDark);
  }

  // Load the theme preference
  static Future<bool> loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyTheme) ?? false; // Default to light theme
  }
}
