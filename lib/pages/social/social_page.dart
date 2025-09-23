import 'package:flilipino_food_app/pages/social/social_post.dart';
import 'package:flutter/material.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: Text("data"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "navigate_to_posting",
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SocialPost()));
        },
        child: const Icon(Icons.add_a_photo),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
