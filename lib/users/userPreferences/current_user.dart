import 'package:clothes_app/users/models/user_model.dart';
import 'package:clothes_app/users/userPreferences/user_preferences.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CurrentUserState extends GetxController{

  Rx<User> currentUser = User(
    user_id: 1,
    user_name: "",
    user_email: "",
    user_password: ""
  ).obs;

  User? get user => currentUser.value;

  getUserInfo() async {
    User? getUserInfoFromLocalStorage = await UserPrefs.readUserInfo();
    currentUser.value = getUserInfoFromLocalStorage!;
  }
}