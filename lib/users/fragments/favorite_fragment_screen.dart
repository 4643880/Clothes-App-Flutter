import 'package:flutter/material.dart';

class FavoriteFragmentScreen extends StatelessWidget {
  const FavoriteFragmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Padding(
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
            Padding(
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

            //displaying favoriteList
          ],
        ),
      ),
    );
  }


}
