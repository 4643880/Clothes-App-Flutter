import 'dart:convert';
import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/controllers/cart_list_controller.dart';
import 'package:clothes_app/users/controllers/item_details_controller.dart';
import 'package:clothes_app/users/item/item_details_screen.dart';
import 'package:clothes_app/users/models/cart_model.dart';
import 'package:clothes_app/users/models/clothes.dart';
import 'package:clothes_app/users/order/order_now_screen.dart';
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
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var decodedResponseBody = jsonDecode(jsonString);
        if (decodedResponseBody["success"] == true) {
          devtools.log(decodedResponseBody.toString());
          (decodedResponseBody["currentUserCartData"] as List)
              .forEach((element) {
            cartListOfCurrentUser.add(Cart.fromJson(element));
          });
        } else {
          Fluttertoast.showToast(
            msg: "Cart List is Empty.",
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
    calculateTotalAmount();
    devtools.log(cartListController.total.toString());
  }

  calculateTotalAmount() {
    cartListController.setTotal(0);
    if (cartListController.selectedItemsList.length > 0) {
      cartListController.cartList.forEach((Cart itemInCart) {
        if (cartListController.selectedItemsList.contains(itemInCart.cart_id)) {
          // multiplying price with quantity and then assigning to variable
          double eachItemTotalAmount = (itemInCart.item_price!) *
              (double.parse(itemInCart.quantity.toString()));
          // passing each item's total amount to setter
          // 0 + 5 = 5 // in the beginning cart total is zero
          // 5 + 20 = 25 // forEach loop assigning amount again and again
          // 25 + 75 = 100
          cartListController
              .setTotal(cartListController.total + eachItemTotalAmount);
        }
      });
    }
  }

  // Only Selected Cart List Items Information
  List<Map<String, dynamic>> getSelectedCartListItemsInfo() {
    List<Map<String, dynamic>> selectedCartListItemsInfo = [];
    if (cartListController.selectedItemsList.length > 0) {
      cartListController.cartList.forEach((eachItemOfCartList) {
        if (cartListController.selectedItemsList
            .contains(eachItemOfCartList.cart_id)) {
          Map<String, dynamic> eachItemInformation = {
            "item_id": eachItemOfCartList.item_id,
            "item_name": eachItemOfCartList.item_name,
            "item_image": eachItemOfCartList.item_image,
            "color": eachItemOfCartList.color,
            "size": eachItemOfCartList.size,
            "quantity": eachItemOfCartList.quantity,
            "price": eachItemOfCartList.item_price,
            "totalAmount": eachItemOfCartList.item_price! *
                double.parse(eachItemOfCartList.quantity.toString()),
          };
          selectedCartListItemsInfo.add(eachItemInformation);
        }
      });
    }
    return selectedCartListItemsInfo;
  }

  @override
  void initState() {
    // Calling the Api
    getCurrentUserCartList();
    super.initState();
  }

  updateCurrentUserCartItemQuantity(
      {required int quantity, required int cartId}) async {
    List<Cart> cartListOfCurrentUser = [];
    try {
      String url = API.updateSelectedItemsQuantityInCart;
      var response = await http.post(
        Uri.parse(url),
        body: {"cart_id": cartId.toString(), "quantity": quantity.toString()},
      );
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var decodedResponseBody = jsonDecode(jsonString);
        if (decodedResponseBody["success"] == true) {
          devtools.log(decodedResponseBody.toString());
          // Again will Reload Cart Api for reading Data and assign to state management controller
          getCurrentUserCartList();
          Fluttertoast.showToast(
            msg: "Item Updated Successfully.",
          );
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
    calculateTotalAmount();
    devtools.log(cartListController.total.toString());
  }

  Future<void> deleteSelectedItemsFromCartList(int cartId) async {
    try {
      devtools.log(cartId.toString());
      String url = API.deleteSelectedItemsFromCart;
      var response = await http.post(
        Uri.parse(url),
        body: {"cart_id": cartId.toString()},
      );
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var decodedResponseBody = jsonDecode(jsonString);
        if (decodedResponseBody["success"] == true) {
          devtools.log(decodedResponseBody.toString());
          // Again will Reload Cart Api for reading Data
          getCurrentUserCartList();
          Fluttertoast.showToast(
            msg: "Item Deleted Successfully.",
          );
        } else {
          Fluttertoast.showToast(
            msg: "Your Cart List is Empty",
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("My Cart"),
        actions: [
          //to select all items
          Obx(
            () => IconButton(
              onPressed: () {
                // if isSelected true then will be false if false then will be true
                cartListController.setIsSelectedAllItems();
                // will remove all from the list
                cartListController.setClearAllSelectedItems();

                if (cartListController.isSelectedAllItems == true) {
                  cartListController.cartList.forEach((eachItem) {
                    cartListController.setAddSelected(eachItem.cart_id!);
                  });
                }

                calculateTotalAmount();
              },
              icon: Icon(
                cartListController.isSelectedAllItems
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color: cartListController.isSelectedAllItems
                    ? Colors.white
                    : Colors.grey,
              ),
            ),
          ),

          // to delete selected items
          GetBuilder(
            init: CartListController(),
            builder: (controller) {
              if (cartListController.selectedItemsList.length > 0) {
                return IconButton(
                  onPressed: () async {
                    var responseFromDialogBox = await Get.dialog(
                      AlertDialog(
                        backgroundColor: Colors.grey,
                        title: const Text("Delete"),
                        content: const Text(
                            "Are you sure to Delete selected items from your Cart List?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text(
                              "No",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back(result: "yesDelete");
                            },
                            child: const Text(
                              "Yes",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                    if (responseFromDialogBox == "yesDelete") {
                      // delete selected items now
                      cartListController.selectedItemsList
                          .forEach((eachSelectedItemsCartId) async {
                        // deleting from database using api
                        await deleteSelectedItemsFromCartList(
                            eachSelectedItemsCartId);
                        // Removing from state management's list
                        cartListController.selectedItemsList
                            .remove(eachSelectedItemsCartId);
                        cartListController.update();
                      });
                    }
                  },
                  icon: const Icon(
                    Icons.delete_sweep,
                    size: 26,
                    color: Colors.redAccent,
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      body: Obx(
        () => cartListController.cartList.isNotEmpty
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: cartListController.cartList.length,
                itemBuilder: (context, index) {
                  Cart eachCartItem = cartListController.cartList[index];
                  // Getting value from cart model and assigning to cloth model because i want to navigate to ItemDetailsScreen that requires cloth object
                  Clothes clothesModel = Clothes(
                      item_id: int.parse(eachCartItem.item_id.toString()),
                      item_name: eachCartItem.item_name,
                      item_rating:
                          double.parse(eachCartItem.item_rating.toString()),
                      item_tags: eachCartItem.item_tags.toString().split(', '),
                      item_price:
                          double.parse(eachCartItem.item_price.toString()),
                      item_sizes:
                          eachCartItem.item_sizes.toString().split(', '),
                      item_colors:
                          eachCartItem.item_colors.toString().split(', '),
                      item_desc: eachCartItem.item_desc,
                      item_image: eachCartItem.item_image);
                  return Row(
                    children: [
                      // check Icon Button
                      GetBuilder(
                        init: CartListController(),
                        builder: (controller) {
                          return IconButton(
                            onPressed: () {
                              if (cartListController.selectedItemsList
                                  .contains(eachCartItem.cart_id)) {
                                cartListController
                                    .setDeleteItem(eachCartItem.cart_id!);
                              } else {
                                cartListController
                                    .setAddSelected(eachCartItem.cart_id!);
                              }
                              calculateTotalAmount();
                              devtools.log(cartListController.selectedItemsList
                                  .toString());
                            },
                            icon: Icon(
                              cartListController.selectedItemsList
                                      .contains(eachCartItem.cart_id)
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: cartListController.isSelectedAllItems
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.to(ItemDetailsScreen(itemInfo: clothesModel));
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                // index 0 means if it is first item them from top margin will be 16 if it is 3rd, 4th or any other item then margin will be 8
                                0,
                                index == 0 ? 16 : 8,
                                16,
                                index == cartListController.cartList.length - 1
                                    ? 16
                                    : 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black,
                              boxShadow: const [
                                BoxShadow(
                                  offset: Offset(0, 0),
                                  blurRadius: 6,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Name
                                        Text(
                                          eachCartItem.item_name.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        // Color, size , Price
                                        Row(
                                          children: [
                                            // Color , size
                                            Expanded(
                                              child: Text(
                                                "Color: ${eachCartItem.color!.replaceAll('[', '').replaceAll(']', '')}" +
                                                    "\n" +
                                                    "Size:  ${eachCartItem.size!}",
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.white60,
                                                ),
                                              ),
                                            ),
                                            // price
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12, right: 12.0),
                                              child: Text(
                                                "\$" +
                                                    eachCartItem.item_price
                                                        .toString(),
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.purpleAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 0,
                                        ),
                                        // Increment & Decrement
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            //-
                                            IconButton(
                                              onPressed: () {
                                                // Value should not be less than 1
                                                if (eachCartItem.quantity! -
                                                        1 >=
                                                    1) {
                                                  updateCurrentUserCartItemQuantity(
                                                    cartId:
                                                        eachCartItem.cart_id!,
                                                    quantity:
                                                        eachCartItem.quantity! -
                                                            1,
                                                  );
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Quantity must be greater than 1");
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.remove_circle_outline,
                                                color: Colors.grey,
                                                size: 30,
                                              ),
                                            ),

                                            const SizedBox(
                                              width: 10,
                                            ),

                                            Text(
                                              eachCartItem.quantity.toString(),
                                              style: const TextStyle(
                                                color: Colors.purpleAccent,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                            const SizedBox(
                                              width: 10,
                                            ),

                                            //+
                                            IconButton(
                                              onPressed: () {
                                                updateCurrentUserCartItemQuantity(
                                                  cartId: eachCartItem.cart_id!,
                                                  quantity:
                                                      eachCartItem.quantity! +
                                                          1,
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.add_circle_outline,
                                                color: Colors.grey,
                                                size: 30,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //item image
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(22),
                                    bottomRight: Radius.circular(22),
                                  ),
                                  child: FadeInImage(
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                    placeholder: const AssetImage(
                                        "images/place_holder.png"),
                                    image: NetworkImage(
                                      eachCartItem.item_image!,
                                    ),
                                    imageErrorBuilder:
                                        (context, error, stackTraceError) {
                                      return const Center(
                                        child: Icon(
                                          Icons.broken_image_outlined,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              )
            : const Center(
                child: Text(
                  "Cart List is Empty",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
      ),
      bottomNavigationBar: GetBuilder(
        init: CartListController(),
        builder: (controller) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -3),
                  color: Colors.white24,
                  blurRadius: 6,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              children: [
                //total amount
                const Text(
                  "Total Amount:",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Obx(
                  () => Text(
                    "\$ " + cartListController.total.toStringAsFixed(2),
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Spacer(),

                //order now btn
                Material(
                  color: cartListController.selectedItemsList.length > 0
                      ? Colors.purpleAccent
                      : Colors.white24,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: () {
                      cartListController.selectedItemsList.length > 0
                          ? Get.to(
                              OrderNowScreen(
                                selectedCartListItemsInfo:
                                    getSelectedCartListItemsInfo(),
                                totalAmount: cartListController.total,
                                selectedCartIDs:
                                    cartListController.selectedItemsList,
                              ),
                            )
                          : null;
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Text(
                        "Order Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
