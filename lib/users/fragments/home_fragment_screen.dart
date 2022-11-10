import 'dart:convert';
import 'package:clothes_app/users/item/item_details_screen.dart';
import 'package:clothes_app/users/models/clothes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:clothes_app/api_connection/api_connection.dart';
import 'dart:developer' as devtools show log;

class HomeFragmentScreen extends StatefulWidget {
  @override
  State<HomeFragmentScreen> createState() => _HomeFragmentScreenState();
}

class _HomeFragmentScreenState extends State<HomeFragmentScreen> {
  TextEditingController searchController = TextEditingController();

  // Trending Clothes API
  Future<List<Clothes>> getTrendingClothItems() async {
    List<Clothes> trendingClothesItemsList = [];
    try {
      var url = API.getTrendingClothes;

      devtools.log(url);

      var response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        var jsonString = response.body;
        var decodedResponseBodyOfTrending = jsonDecode(jsonString);

        if (decodedResponseBodyOfTrending["success"] == true) {
          devtools.log(decodedResponseBodyOfTrending.toString());
          (decodedResponseBodyOfTrending["clothItemsData"] as List)
              .forEach((itemRecord) {
            trendingClothesItemsList.add(Clothes.fromJson(itemRecord));
          });
        }
      } else {
        Fluttertoast.showToast(
          msg: "Error: Status is not 200.",
        );
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }

    return trendingClothesItemsList;
  }

  // All New Clothes API
  Future<List<Clothes>> getAllNewClothesCollection() async {
    List<Clothes> allNewClothesItemsList = [];
    try {
      var url = API.getAllNewClothesCollection;

      devtools.log(url);

      var response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        var jsonString = response.body;
        var decodedResponseBodyOfAllNewCollection = jsonDecode(jsonString);

        if (decodedResponseBodyOfAllNewCollection["success"] == true) {
          devtools.log(decodedResponseBodyOfAllNewCollection.toString());
          (decodedResponseBodyOfAllNewCollection["clothItemsData"] as List)
              .forEach((itemRecord) {
            allNewClothesItemsList.add(Clothes.fromJson(itemRecord));
          });
        }
      } else {
        Fluttertoast.showToast(
          msg: "Error: Status is not 200.",
        );
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }

    return allNewClothesItemsList;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          // Search Bar Widget
          showSearchBarWidget(),
          // Trending or Popular Items
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Text(
              "Trending",
              style: TextStyle(
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
          ),
          trendingMostPopularItemsWidget(),

          // All New Collection or Items
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Text(
              "New Collections",
              style: TextStyle(
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
          ),
          allNewClothesCollectionWidget(),
        ],
      ),
    );
  }

  Widget showSearchBarWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
            prefixIcon: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: Colors.purple,
                )),
            suffixIcon: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.shopping_cart,
                color: Colors.purple,
              ),
            ),
            hintText: "Search best Clothes Here",
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              borderSide: BorderSide(width: 2, color: Colors.purpleAccent),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              borderSide: BorderSide(width: 2, color: Colors.purple),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              borderSide: BorderSide(width: 2, color: Colors.purpleAccent),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            fillColor: Colors.black,
            filled: true),
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget trendingMostPopularItemsWidget() {
    return FutureBuilder(
      future: getTrendingClothItems(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return SizedBox(
                height: 260,
                child: ListView.builder(
                  itemCount: snapshot.data?.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    Clothes eachClothItem = snapshot.data![index];
                    var itemsList = snapshot.data;
                    return GestureDetector(
                      onTap: () {
                        Get.to(ItemDetailsScreen(itemInfo: eachClothItem));
                      },
                      child: Container(
                        width: 200,
                        margin: EdgeInsets.fromLTRB(
                          (index == 0) ? 16 : 8,
                          10,
                          (index == snapshot.data!.length - 1) ? 16 : 8,
                          10,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black,
                            boxShadow: const [
                              BoxShadow(
                                  offset: Offset(0, 3),
                                  blurRadius: 6,
                                  color: Colors.grey)
                            ]),
                        child: Column(
                          children: [
                            // Item Image
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              child: FadeInImage(
                                height: 140,
                                width: 200,
                                fit: BoxFit.cover,
                                placeholder:
                                    const AssetImage("images/place_holder.png"),
                                image:
                                    NetworkImage(itemsList![index].item_image!),
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(Icons.broken_image_outlined),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Name and Price
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          itemsList[index].item_name ?? "",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "\$ ${itemsList[index]
                                                    .item_price}" ??
                                            "",
                                        style: const TextStyle(
                                            color: Colors.purpleAccent,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  // Rating Stars
                                  Row(
                                    children: [
                                      RatingBar.builder(
                                        initialRating:
                                            itemsList[index].item_rating!,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemBuilder: (context, index) {
                                          return const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          );
                                        },
                                        onRatingUpdate: (value) {},
                                        ignoreGestures: true,
                                        itemSize: 20,
                                        unratedColor: Colors.grey,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "( ${itemsList[index]
                                                .item_rating} )",
                                        style: const TextStyle(
                                            color: Colors.purpleAccent,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Text(itemsList[index].item_name ?? ""),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        } else {
          return const Center(
            child: Text(
              "No Trending Items Found",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          );
        }
      },
    );
  }

  Widget allNewClothesCollectionWidget() {
    return FutureBuilder(
      future: getAllNewClothesCollection(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return ListView.builder(
                itemCount: snapshot.data?.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  Clothes eachClothItem = snapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(ItemDetailsScreen(itemInfo: eachClothItem));
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
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Name, Price and Tags
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Name and Price
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          eachClothItem.item_name ?? "",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 12,
                                        ),
                                        child: Text(
                                          "\$ ${eachClothItem.item_price}" ??
                                              "",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.purpleAccent,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  // Tags
                                  Text(
                                    "Tags:\n${eachClothItem.item_tags
                                            .toString()
                                            .replaceAll('[', '')
                                            .replaceAll(']', '')
                                            .toUpperCase()}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                                // topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                // bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            child: FadeInImage(
                              width: 130,
                              height: 130,
                              fit: BoxFit.cover,
                              placeholder:
                                  const AssetImage("images/place_holder.png"),
                              image: NetworkImage(eachClothItem.item_image!),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(Icons.broken_image_outlined),
                                );
                              },
                            ),
                          ),
                          // Item Image
                        ],
                      ),
                    ),
                  );
                },
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        } else {
          return const Center(
            child: Text(
              "No New Collection Items Found",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          );
        }
      },
    );
  }
}
