import 'package:clothes_app/users/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileFragmentScreen extends StatelessWidget {
  // Accessing Data From State
  CurrentUserState currentUserState = Get.put(CurrentUserState());
  // Init State of Dashboard Page fetching data from sharedPrefs and assigning to sate, then using that data in this page

  Widget userInfoItemProfile(
      {required IconData iconData, required String userData}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.grey),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 08),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 30,
            color: Colors.black,
          ),
          const SizedBox(
            width: 16,
          ),
          Text(
            userData,
            style: const TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: ListView(
        children: [
          Center(
            child: Image.asset(
              "images/woman.png",
              width: 240,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          userInfoItemProfile(
              iconData: Icons.person,
              userData: currentUserState.user?.user_name ?? ""),
          const SizedBox(
            height: 20,
          ),
          userInfoItemProfile(
              iconData: Icons.email,
              userData: currentUserState.user?.user_email ?? ""),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Material(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(32), //32
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  child: Text(
                    "Sign Out",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
