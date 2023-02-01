import 'dart:convert';
import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/models/favorite_model.dart';
import 'package:clothes_app/users/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as devtools show log;



class FavoriteFragmentScreen extends StatelessWidget {
  FavoriteFragmentScreen({Key? key}) : super(key: key);
  // Dependency Injection
  final currentLoggedInUser = Get.put(CurrentUserState());

  Future<List<Favorite>> getCurrentUserFavoriteList() async {
    List<Favorite> favoriteListOfCurrentUser = [];
    try {
      String url = API.readFavorite;
      var response = await http.post(
        Uri.parse(url),
        body: {
          "user_id": currentLoggedInUser.user?.user_id.toString()
        },
      );
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var decodedResponseBody = jsonDecode(jsonString);
        if (decodedResponseBody["success"] == true) {
          devtools.log(decodedResponseBody.toString());
          (decodedResponseBody["currentUserFavoriteData"] as List)
              .forEach((eachFavoriteItem) {
            favoriteListOfCurrentUser.add(Favorite.fromJson(eachFavoriteItem));
          });
        } else {
          Fluttertoast.showToast(
            msg: "Something went wrong.",
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Error: Status is not 200.",
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    return favoriteListOfCurrentUser;

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 8, 8),
              child: Text(
                "My Favorite List:",
                style: TextStyle(
                  color: Colors.purpleAccent,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 8, 8),
              child: Text(
                "Order these best clothes for yourself now.",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),

            SizedBox(height: 24),

            //displaying favoriteList
          ],
        ),
      ),
    );
  }


}
