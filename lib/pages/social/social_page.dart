import 'package:flilipino_food_app/pages/social/social_post.dart';
import 'package:flutter/material.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

// email
// userId
// username
// post
// likes
// comments

class _SocialPageState extends State<SocialPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SocialPost()));
              },
              child: Icon(Icons.add_a_photo))
        ],
      ),
    );
  }
}
