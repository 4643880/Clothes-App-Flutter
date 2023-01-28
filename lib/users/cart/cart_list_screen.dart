import 'dart:convert';
import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/controllers/cart_list_controller.dart';
import 'package:clothes_app/users/models/cart_model.dart';
import 'package:clothes_app/users/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as devtools show log;


class CartListScreen extends StatefulWidget {
  const CartListScreen({Key? key}) : super(key: key);

  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> {
  // Dependency Injection
  final currentLoggedInUser = Get.put(CurrentUserState());
  final cartListController = Get.put(CartListController());

  getCurrentUserCartList() async {
    List<Cart> cartListOfCurrentUser = [];
    try {
      String url = API.getCartList;
      var response = await http.post(
        Uri.parse(url),
        body: {
          "currentOnlineUserId": currentLoggedInUser.user?.user_id.toString()
        },
      );
      if(response.statusCode == 200){
        var jsonString = response.body;
        var decodedResponseBody = jsonDecode(jsonString);
        if (decodedResponseBody["success"] == true) {
          devtools.log(decodedResponseBody.toString());
          (decodedResponseBody["currentUserCartData"] as List).forEach((element) {
            cartListOfCurrentUser.add(Cart.fromJson(element));
          });

        }else{
          Fluttertoast.showToast(
            msg:
            "Something went wrong.",
          );
        }

        // Storing in the State Management
        cartListController.setCartList(cartListOfCurrentUser);
      } else {
        Fluttertoast.showToast(
          msg: "Error: Status is not 200.",
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
