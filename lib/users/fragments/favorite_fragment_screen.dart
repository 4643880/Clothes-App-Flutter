import 'dart:convert';
import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/item/item_details_screen.dart';
import 'package:clothes_app/users/models/clothes.dart';
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
        body: {"user_id": currentLoggedInUser.user?.user_id.toString()},
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
            msg: "No Item Found in Favorite List.",
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
          children: [
            const Padding(
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
            const Padding(
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

            const SizedBox(height: 24),

            //displaying favorite List
            favoriteListItemDesignWidget(),
          ],
        ),
      ),
    );
  }

  favoriteListItemDesignWidget() {
    return FutureBuilder(
      future: getCurrentUserFavoriteList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data!.isEmpty) {
          devtools.log(snapshot.data.toString());
          return const Center(
            child: Text(
              "No favorite item found",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        }
        if (snapshot.data!.length > 0) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              Favorite eachFavoriteItemRecord = snapshot.data![index];

              // Getting value from favorite model and assigning to cloth model because i want to navigate to ItemDetailsScreen that requires cloth object
              Clothes cloth = Clothes(
                  item_id: int.parse(eachFavoriteItemRecord.item_id.toString()),
                  item_name: eachFavoriteItemRecord.item_name,
                  item_rating: double.parse(eachFavoriteItemRecord.item_rating.toString()),
                  item_tags: eachFavoriteItemRecord.item_tags.toString().split(', '),
                  item_price: double.parse(eachFavoriteItemRecord.item_price.toString()),
                  item_sizes: eachFavoriteItemRecord.item_sizes.toString().split(', '),
                  item_colors: eachFavoriteItemRecord.item_colors.toString().split(', '),
                  item_desc: eachFavoriteItemRecord.item_desc,
                  item_image: eachFavoriteItemRecord.item_image
              );


              return GestureDetector(
                onTap: () {
                  Get.to(ItemDetailsScreen(itemInfo: cloth,));
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                    16,
                    index == 0 ? 16 : 8,
                    16,
                    index == snapshot.data!.length - 1 ? 16 : 8,
                  ),
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
                      //name + price
                      //tags
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //name and price
                              Row(
                                children: [
                                  //name
                                  Expanded(
                                    child: Text(
                                      eachFavoriteItemRecord.item_name!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  //price
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 12),
                                    child: Text(
                                      "\$ " +
                                          eachFavoriteItemRecord.item_price
                                              .toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.purpleAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 16,
                              ),

                              //tags
                              Text(
                                "Tags: \n" +
                                    eachFavoriteItemRecord.item_tags
                                        .toString()
                                        .replaceAll("[", "")
                                        .replaceAll("]", ""),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      //image clothes
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: FadeInImage(
                          height: 130,
                          width: 130,
                          fit: BoxFit.cover,
                          placeholder:
                              const AssetImage("images/place_holder.png"),
                          image: NetworkImage(
                            eachFavoriteItemRecord.item_image!,
                          ),
                          imageErrorBuilder: (context, error, stackTraceError) {
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
              );
            },
          );
        } else {
          return const Center(
            child: Text("Empty, No Data."),
          );
        }
      },
    );
  }
}
