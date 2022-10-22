import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:clothes_app/users/fragments/favorite_fragment_screen.dart';
import 'package:clothes_app/users/fragments/home_fragment_screen.dart';
import 'package:clothes_app/users/fragments/order_fragment_screen.dart';
import 'package:clothes_app/users/fragments/profile_fragment_screen.dart';
import 'package:clothes_app/users/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardOfFragments extends StatelessWidget {
  // Dependency Injection
  CurrentUserState rememberCurrentUserObj = Get.put(CurrentUserState());

  List<Widget> fragmentScreens = [
    const HomeFragmentScreen(),
    const FavoriteFragmentScreen(),
    const OrderFragmentScreen(),
    const ProfileFragmentScreen()
  ];

  List navigationButtonsProperties = [
    {
      "active_icon" : Icons.home,
      "none_active_icon" : Icons.home_outlined,
      "label" : "Home"
    },
    {
      "active_icon" : Icons.favorite,
      "none_active_icon" : Icons.favorite_outline,
      "label" : "Favorites"
    },
    {
      "active_icon" : FontAwesomeIcons.boxOpen,
      "none_active_icon" : FontAwesomeIcons.box,
      "label" : "Orders"
    },
    {
      "active_icon" : Icons.person,
      "none_active_icon" : Icons.person_outline,
      "label" : "Profile"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CurrentUserState>(
      init: CurrentUserState(),
      initState: (state) {
        rememberCurrentUserObj.getUserInfo();
      },
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: const Text("Dashboard Fragment screen"),),
        );
      },
    );
  }
}
