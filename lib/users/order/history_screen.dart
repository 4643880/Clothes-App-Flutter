import 'dart:convert';
import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/models/order_model.dart';
import 'package:clothes_app/users/order/order_details_screen.dart';
import 'package:clothes_app/users/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as devtools show log;

import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({Key? key}) : super(key: key);

  final currentOnlineUser = Get.put(CurrentUserState());

  Future<List<Order>> getCurrentUserOrdersList() async {
    List<Order> ordersListOfCurrentUser = [];
    try {
      String url = API.getOrdersHistory;
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Order image       //history image
          //myOrder title     //history title
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 34, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //order icon image
                // my orders
                Column(
                  children: [
                    Image.asset(
                      "images/history_icon.png",
                      width: 140,
                    ),
                    const SizedBox(height: 8,),
                    const Text(
                      "My History",
                      style: TextStyle(
                        color: Colors.purpleAccent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8,),
                    //some info
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        "Here are your successfully received orders.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),



          //displaying the user orderList
          Expanded(
            child: displayOrdersList(context),
          ),
        ],
      ),
    );
  }

  Widget displayOrdersList(context) {
    return FutureBuilder(
      future: getCurrentUserOrdersList(),
      builder: (context, AsyncSnapshot<List<Order>> dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Center(
                child: Text(
                  "Connection Waiting...",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }
        if (dataSnapshot.data == null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Center(
                child: Text(
                  "No orders found yet...",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }
        if (dataSnapshot.data!.isNotEmpty) {
          List<Order> orderList = dataSnapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (context, index) {
              return const Divider(
                height: 5,
                thickness: 5,
              );
            },
            itemCount: orderList.length,
            itemBuilder: (context, index) {
              Order eachOrderData = orderList[index];

              return Card(
                color: Colors.white24,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: ListTile(
                    onTap: () {
                      Get.to(OrderDetailsScreen(
                        clickedOrderInfo: eachOrderData,
                      ));
                    },
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order ID # " + eachOrderData.order_id.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Amount: \$ " + eachOrderData.totalAmount.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.purpleAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //date
                        //time
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //date
                            Text(
                              DateFormat("dd MMMM, yyyy")
                                  .format(eachOrderData.dateTime!),
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 4),

                            //time
                            Text(
                              DateFormat("hh:mm a")
                                  .format(eachOrderData.dateTime!),
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 6),

                        const Icon(
                          Icons.navigate_next,
                          color: Colors.purpleAccent,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Center(
                child: Text(
                  "Nothing to show...",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }
      },
    );
  }
}
