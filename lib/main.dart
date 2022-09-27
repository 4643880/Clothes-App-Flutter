import 'package:clothes_app/users/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  // To Ensure that there is not empty white screen
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clothes App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: FutureBuilder(
        builder: (context, snapshot) {
          return const LoginScreen();
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
