
import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/models/order_model.dart';
import 'package:clothes_app/users/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as devtools show log;

class OrderFragmentScreen extends StatelessWidget {
  OrderFragmentScreen({Key? key}) : super(key: key);

  final currentOnlineUser = Get.put(CurrentUserState());

  Future<List<Order>> getCurrentUserOrdersList() async {
    List<Order> ordersListOfCurrentUser = [];
    try {
      String url = API.getOrders;
      var response = await http.post(
        Uri.parse(url),
        body: {"user_id": currentOnlineUser.user?.user_id.toString()},
      );
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var decodedResponseBody = jsonDecode(jsonString);
        if (decodedResponseBody["success"] == true) {
          devtools.log(decodedResponseBody.toString());
          (decodedResponseBody["currentUserOrdersData"] as List)
              .forEach((eachOrder) {
            ordersListOfCurrentUser.add(Order.fromJson(eachOrder));
          });
        } else {
          Fluttertoast.showToast(
            msg: "No Item Found in Orders List.",
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
    return ordersListOfCurrentUser;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Order Fragment Screen")),
    );
  }
}
