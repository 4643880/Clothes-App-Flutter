import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AdminUploadItemsScreen extends StatefulWidget {
  const AdminUploadItemsScreen({Key? key}) : super(key: key);

  @override
  State<AdminUploadItemsScreen> createState() => _AdminUploadItemsScreenState();
}

class _AdminUploadItemsScreenState extends State<AdminUploadItemsScreen> {
  // Object of Image Picker
  final ImagePicker _picker = ImagePicker();

  // Will Assign Image to this variable
  XFile? pickedImageXFileVar;

  //===========================================================
  //        Default Screen Methods Starts Here
  //===========================================================

  captureImageWithPhoneCamera() async {
    final pickedImageXFileWithCamera = await _picker.pickImage(
      source: ImageSource.camera,
    );

    Get.back();

    setState(() {
      pickedImageXFileVar = pickedImageXFileWithCamera;
    });
  }

  pickImageFromGallery() async {
    final pickedImageXFileFromGallery = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    Get.back();

    setState(() {
      pickedImageXFileVar = pickedImageXFileFromGallery;
    });
  }

  showDialogBoxForPickingImage() {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: Colors.black87,
          title: const Text(
            "Item Image",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.deepPurple),
          ),
          children: [
            SimpleDialogOption(
              onPressed: () {
                captureImageWithPhoneCamera();
              },
              child: const Text(
                "Capture With Phone Camera",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                pickImageFromGallery();
              },
              child: const Text(
                "Pick Image From Gallery",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SimpleDialogOption(
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  //===========================================================
  //        Default Screen Methods Ends Here
  //===========================================================

  Widget defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Colors.black54, Colors.deepPurple]),
          ),
        ),
        title: const Text("Welcome Admin"),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.black54, Colors.deepPurple]),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_photo_alternate,
                color: Colors.white54,
                size: 200,
              ),
              Material(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () {
                    showDialogBoxForPickingImage();
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "Add New Item",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget uploadItemFormScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: FileImage(
                    File(pickedImageXFileVar!.path),
                  ),
                  fit: BoxFit.cover),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (pickedImageXFileVar == null)
        ? defaultScreen()
        : uploadItemFormScreen();
  }
}
