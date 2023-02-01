import 'package:clothes_app/users/fragments/favorite_fragment_screen.dart';
import 'package:clothes_app/users/fragments/home_fragment_screen.dart';
import 'package:clothes_app/users/fragments/order_fragment_screen.dart';
import 'package:clothes_app/users/fragments/profile_fragment_screen.dart';
import 'package:clothes_app/users/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class DashboardOfFragments extends StatelessWidget {
  // Dependency Injection
  CurrentUserState rememberCurrentUserObj = Get.put(CurrentUserState());

  List<Widget> fragmentScreens = [
    HomeFragmentScreen(),
    FavoriteFragmentScreen(),
    const OrderFragmentScreen(),
    ProfileFragmentScreen()
  ];

  List navigationButtonsProperties = [
    {
      "active_icon" : const Icon(Icons.home),
      "none_active_icon" : const Icon(Icons.home_outlined),
      "label" : "Home"
    },
    {
      "active_icon" : const Icon(Icons.favorite),
      "none_active_icon" : const Icon(Icons.favorite_outline),
      "label" : "Favorites"
    },
    {
      "active_icon" : const FaIcon(FontAwesomeIcons.boxOpen),
      "none_active_icon" : const FaIcon(FontAwesomeIcons.box),
      "label" : "Orders"
    },
    {
      "active_icon" : const Icon(Icons.person),
      "none_active_icon" : const Icon(Icons.person_outline),
      "label" : "Profile"
    },
  ];

  Rx<int> indexNumber = 0.obs;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CurrentUserState>(
      init: CurrentUserState(),
      initState: (state) {
        rememberCurrentUserObj.getUserInfo();
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black,
          // appBar: AppBar(title: const Text("Dashboard Fragment screen")),
          body: SafeArea(
            child: Obx(
              () {
                return fragmentScreens[indexNumber.value];
              },
            ),
          ),
          bottomNavigationBar: Obx(
            () => BottomNavigationBar(
              currentIndex: indexNumber.value,
              onTap: (value) {
                print(value);
                indexNumber.value = value;
              },
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white24,
              items: List.generate(4, (index) {
                return BottomNavigationBarItem(
                  backgroundColor: Colors.black,
                  icon: navigationButtonsProperties[index]["none_active_icon"],
                  activeIcon: navigationButtonsProperties[index]["active_icon"],
                  label: navigationButtonsProperties[index]["label"]
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
