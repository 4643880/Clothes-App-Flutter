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
  // Capture a photo With Camera
  late final XFile? capturedImgWithCamera;

  // Pick an image From Gallery
  late final XFile? pickedImgFromGallery;


  captureImageWithPhoneCamera() async {
    capturedImgWithCamera = await _picker.pickImage(
      source: ImageSource.camera,
    );
    Get.back();
  }
  pickImageFromGallery() async {
    pickedImgFromGallery = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    Get.back();
  }

  // await _picker.pickImage(source: ImageSource.gallery);
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

  @override
  Widget build(BuildContext context) {
    return defaultScreen();
  }
}
