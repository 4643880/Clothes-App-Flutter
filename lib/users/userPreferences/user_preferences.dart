import 'dart:convert';
import 'package:clothes_app/users/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs{



  // Save User Info
  static Future<void> saveAndRememberUserInfo(User userInfo) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final userJsonData = jsonEncode(userInfo.toJson());
    await prefs.setString(
      'currentUserCredentials',
      userJsonData,
    );
  }



  // Read User Info
  static Future<User?> readUserInfo() async {
    User? currentUser;
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    String? userInfo = prefs.getString('currentUserCredentials');
    if(userInfo != null){
      Map<String, dynamic> userDecodedData = jsonDecode(userInfo);
      // Assigning to Model
      currentUser = User.fromJson(userDecodedData);
    }
    return currentUser;

  }

}