import 'package:flutter/material.dart';


class AdminUploadItemsScreen extends StatefulWidget {
  const AdminUploadItemsScreen({Key? key}) : super(key: key);

  @override
  State<AdminUploadItemsScreen> createState() => _AdminUploadItemsScreenState();
}

class _AdminUploadItemsScreenState extends State<AdminUploadItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Welcome Admin"),),
    );
  }
}
