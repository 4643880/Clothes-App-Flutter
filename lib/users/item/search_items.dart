import 'dart:convert';
import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/cart/cart_list_screen.dart';
import 'package:clothes_app/users/item/item_details_screen.dart';
import 'package:clothes_app/users/models/clothes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as devtools show log;


class SearchItemsScreen extends StatefulWidget {
  final String? searchKeywords;
  const SearchItemsScreen({Key? key, this.searchKeywords}) : super(key: key);

  @override
  State<SearchItemsScreen> createState() => _SearchItemsScreenState();
}

class _SearchItemsScreenState extends State<SearchItemsScreen> {
  TextEditingController searchController = TextEditingController();

  Future<List<Clothes>> readSearchedItems() async {
    List<Clothes> searchedClothesItemsList = [];
    if(searchController.text != "") {
      try {
        String url = API.searchItems;
        var response = await http.post(
          Uri.parse(url),
          body: {
            "typed_keywords": searchController.text.toString()},
        );
        if (response.statusCode == 200) {
          var jsonString = response.body;
          var decodedResponseBody = jsonDecode(jsonString);
          if (decodedResponseBody["success"] == true) {
            devtools.log(decodedResponseBody.toString());
            (decodedResponseBody["itemsFoundData"] as List)
                .forEach((eachSearchedItem) {
              searchedClothesItemsList.add(Clothes.fromJson(eachSearchedItem));
            });
          } else {
            Fluttertoast.showToast(
              msg: "No Items Found.",
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
    return searchedClothesItemsList;
  }

  @override
  void initState() {
    searchController.text = widget.searchKeywords!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white24,
        title: showSearchBarWidget(),
        titleSpacing: 0,
        toolbarHeight: 70,

        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.purpleAccent,
          ),
        ),
      ),
      body: searchedClothesCollectionWidget(),
    );
  }

  Widget searchedClothesCollectionWidget() {
    return FutureBuilder(
      future: readSearchedItems(),
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
                      // index 0 means if it is first item them from top margin will be 16 if it is 3rd, 4th or any other item then margin will be 8
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
                                    "Tags:\n${eachClothItem.item_tags.toString().replaceAll('[', '').replaceAll(']', '').toUpperCase()}",
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

  Widget showSearchBarWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
            prefixIcon: IconButton(
                onPressed: () {
                  // Complete Built Function will call again in this, using future builder that's calling api again with new controller text
                  setState(() {

                  });
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.purple,
                )),
            suffixIcon: IconButton(
              onPressed: () {
                searchController.clear();
                setState(() {

                });
              },
              icon: const Icon(
                Icons.close,
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
}
