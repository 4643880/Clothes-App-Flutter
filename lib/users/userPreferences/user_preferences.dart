import 'dart:convert';
import 'package:clothes_app/users/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RememberUserPrefs{
  // Save User Info
  static Future<void> saveAndRememberUser(User userInfo) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    final userJsonData = jsonEncode(userInfo.toJson());
    await prefs.setString(
      'currentUserCredentials',
      userJsonData,
    );


  }

}