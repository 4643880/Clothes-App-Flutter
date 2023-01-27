import 'package:clothes_app/users/controllers/item_details_controller.dart';
import 'package:clothes_app/users/models/clothes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Clothes itemInfo;
  const ItemDetailsScreen({Key? key, required this.itemInfo}) : super(key: key);

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  // Dependency Injection
  final itemDetailsController = Get.put(ItemDetailsController());

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        // fit: StackFit.expand,
        children: [
          // Item Image
          FadeInImage(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            fit: BoxFit.cover,
            placeholder: const AssetImage("images/place_holder.png"),
            image: NetworkImage(widget.itemInfo.item_image!),
            imageErrorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(Icons.broken_image_outlined),
              );
            },
          ),
          // Item Information
          Align(
            alignment: Alignment.bottomCenter,
            child: itemInfoWidget(),
          ),
        ],
      ),
    );
  }

  // ItemInfoWidget
  Widget itemInfoWidget() {
    return Container(
      // margin: EdgeInsets.only(bottom: 30),
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(35),
          topLeft: Radius.circular(35),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -3),
            blurRadius: 6,
            color: Colors.purpleAccent,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 18,
            ),

            Center(
              child: Container(
                height: 8,
                width: 140,
                decoration: BoxDecoration(
                  color: Colors.purpleAccent,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            // Item Name
            Text(
              widget.itemInfo.item_name!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.purpleAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rating Bar with Rating Number
                // Tags
                // Price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rating Bar with Rating Number
                      Row(
                        children: [
                          RatingBar.builder(
                            initialRating: widget.itemInfo.item_rating!,
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
                            "( ${widget.itemInfo.item_rating} )",
                            style: const TextStyle(
                                color: Colors.purpleAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      // Tags
                      Text(
                        "Tags\n${widget.itemInfo.item_tags.toString().replaceAll('[', "").replaceAll("]", "").toUpperCase()}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      // Price
                      Text(
                        "\$${widget.itemInfo.item_price}",
                        style: const TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                // Quantity Item Controller
                Obx(
                      () => Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          itemDetailsController.setQuantityItem(
                            itemDetailsController.quantity + 1,
                          );
                        },
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        itemDetailsController.quantity.toString(),
                        style: const TextStyle(
                          color: Colors.purpleAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Value should not be less than 1
                          if(itemDetailsController.quantity -1 >= 1){
                            itemDetailsController.setQuantityItem(
                              itemDetailsController.quantity - 1,
                            );
                          }else{
                            Fluttertoast.showToast(msg: "Quantity must be greater than 1");
                          }

                        },
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Size

          ],
        ),
      ),
    );
  }
}
