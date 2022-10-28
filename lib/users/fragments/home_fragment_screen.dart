import 'package:flutter/material.dart';

class HomeFragmentScreen extends StatelessWidget {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Search Bar Widget
          showSearchBarWidget(),
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
              onPressed: (){},
              icon: const Icon(Icons.search, color: Colors.purple,)),
          suffixIcon: IconButton(
            onPressed: (){},
            icon: const Icon(Icons.shopping_cart, color: Colors.purple,),
          ),
          hintText: "Search best Clothes Here",
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            borderSide:
            BorderSide(
                width: 2,
                color: Colors.purpleAccent),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            borderSide:
            BorderSide(
                width: 2,
                color: Colors.purple),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            borderSide:
            BorderSide(
                width: 2,
                color: Colors.purpleAccent),
          ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          fillColor: Colors.black,
            filled: true
        ),
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}

// TextFormField(
// controller: _emailController,
// decoration: const InputDecoration(
// prefixIcon: Icon(
// Icons.email,
// color: Colors.black,
// ),
// hintText: "Please Enter Email",
// // labelText: "Please Enter Email",
// border: OutlineInputBorder(
// borderRadius: BorderRadius.all(
// Radius.circular(20),
// ),
// borderSide:
// BorderSide(color: Colors.white60),
// ),
// enabledBorder: OutlineInputBorder(
// borderRadius: BorderRadius.all(
// Radius.circular(20),
// ),
// borderSide:
// BorderSide(color: Colors.white60),
// ),
// disabledBorder: OutlineInputBorder(
// borderRadius: BorderRadius.all(
// Radius.circular(20),
// ),
// borderSide:
// BorderSide(color: Colors.white60),
// ),
// focusedBorder: OutlineInputBorder(
// borderRadius: BorderRadius.all(
// Radius.circular(20),
// ),
// borderSide:
// BorderSide(color: Colors.white60),
// ),
// contentPadding: EdgeInsets.symmetric(
// horizontal: 14, vertical: 6),
// fillColor: Colors.white,
// filled: true,
// ),
// validator: (value) {
// var checkNull = value ?? "";
// if (checkNull.isEmpty) {
// return "Email Can't be Empty";
// }
// return null;
// },
// ),