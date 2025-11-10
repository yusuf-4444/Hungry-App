import 'package:shared_preferences/shared_preferences.dart';

class PrefHelper {
  static const String _tokenKey = "auth_token";
  static const String _isGuestKey = "is_guest";
  static const String _isLoggedKey = "is_logged_in";

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> setGuestMode(bool isGuest) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isGuestKey, isGuest);
  }

  static Future<bool> isGuest() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isGuestKey) ?? false;
  }

  static Future<void> setLoggedIn(bool isLoogedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedKey, isLoogedIn);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedKey) ?? false;
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_isGuestKey);
    await prefs.remove(_isLoggedKey);
  }
}
