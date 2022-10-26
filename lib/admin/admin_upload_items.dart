import 'dart:io';
import 'package:clothes_app/admin/admin_login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as devtools show log;
import 'package:http/http.dart' as http;


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

  // Form Key and Controllers
  var _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController sizesController = TextEditingController();
  TextEditingController colorsController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  var imageLink = "";

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

  //===========================================================
  //        Upload Item Form Screen Methods Starts Here
  //===========================================================
  // Documention of Imgur
  // https://apidocs.imgur.com/#2078c7e0-c2b8-4bc8-a646-6e544b087d0f

  uploadItemImage() async {
    var requestImgurApi = http.MultipartRequest(
      "POST",
      Uri.parse("https://api.imgur.com/3/image"),
    );

    // Image Name should be unique that's why using date time
    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    requestImgurApi.fields['title'] = imageName;
    requestImgurApi.headers['Authorization'] = 'Client-ID ' + '1c5e1bfd98a4871';

    // My Picked Or Captured Image
    var imageFile = await http.MultipartFile.fromPath(
      'image',
      pickedImageXFileVar!.path,
      filename: imageName,
    );

    requestImgurApi.files.add(imageFile);
    var responseFromImgurApi = await requestImgurApi.send();
    var result = await responseFromImgurApi.stream.bytesToString();

    devtools.log(result);

  }

  //===========================================================
  //        Upload Item Form Screen Methods Ends Here
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
      appBar: AppBar(
        automaticallyImplyLeading: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Colors.black54, Colors.deepPurple]),
          ),
        ),
        title: const Text("Upload New Item"),
        leading: IconButton(
          onPressed: () {
            Get.to(const AdminLoginScreen());
          },
          icon: const Icon(Icons.clear),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Done",
              style: TextStyle(
                color: Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Image of Header
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
          ),

          // Upload Item Form
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              // height: MediaQuery.of(context).size.height * 0.45,
              decoration: const BoxDecoration(
                color: Colors.white24,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, -3),
                  )
                ],
                borderRadius: BorderRadius.all(
                  Radius.circular(45),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Item Name
                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.title,
                                color: Colors.black,
                              ),
                              hintText: "Please Enter Item's Name",
                              // labelText: "Please Enter Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            validator: (value) {
                              var checkNull = value ?? "";
                              if (checkNull.isEmpty) {
                                return "Item's Name Can't be Empty";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          // Item Rating
                          TextFormField(
                            controller: ratingController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.rate_review,
                                color: Colors.black,
                              ),
                              hintText: "Please Enter Item's Rating",
                              // labelText: "Please Enter Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            validator: (value) {
                              var checkNull = value ?? "";
                              if (checkNull.isEmpty) {
                                return "Item's Rating Can't be Empty";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          // Item Tags
                          TextFormField(
                            controller: tagsController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.tag,
                                color: Colors.black,
                              ),
                              hintText: "Please Enter Tags For Item",
                              // labelText: "Please Enter Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            validator: (value) {
                              var checkNull = value ?? "";
                              if (checkNull.isEmpty) {
                                return "Tags of Item Can't be Empty";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          // Item Price
                          TextFormField(
                            controller: priceController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.price_change_outlined,
                                color: Colors.black,
                              ),
                              hintText: "Please Enter Item's Price",
                              // labelText: "Please Enter Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            validator: (value) {
                              var checkNull = value ?? "";
                              if (checkNull.isEmpty) {
                                return "Item's Price Can't be Empty";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          // Item Sizes
                          TextFormField(
                            controller: sizesController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.picture_in_picture,
                                color: Colors.black,
                              ),
                              hintText: "Please Enter Sizes of Item",
                              // labelText: "Please Enter Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            validator: (value) {
                              var checkNull = value ?? "";
                              if (checkNull.isEmpty) {
                                return "Item's Sizes Can't be Empty";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          // Item Colors
                          TextFormField(
                            controller: colorsController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.color_lens,
                                color: Colors.black,
                              ),
                              hintText: "Please Enter Colors of Item",
                              // labelText: "Please Enter Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            validator: (value) {
                              var checkNull = value ?? "";
                              if (checkNull.isEmpty) {
                                return "Item colors Can't be Empty";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          // Item Description
                          TextFormField(
                            controller: descriptionController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.description,
                                color: Colors.black,
                              ),
                              hintText: "Please Enter Item's Description",
                              // labelText: "Please Enter Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            validator: (value) {
                              var checkNull = value ?? "";
                              if (checkNull.isEmpty) {
                                return "Item's Description Can't be Empty";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),

                          Material(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  devtools.log("form passed");
                                  uploadItemImage();
                                } else {
                                  devtools.log("form failed");
                                  uploadItemImage();
                                }
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Text(
                                  "Upload Now",
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
                    // Email Field
                  ],
                ),
              ),
              // child: ,
            ),
          ),
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
