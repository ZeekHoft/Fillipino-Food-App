import 'package:flilipino_food_app/pages/social/social_post.dart';
import 'package:flilipino_food_app/pages/social/social_widgets/post_widget.dart';
import 'package:flilipino_food_app/util/social_data_storing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  @override
  Widget build(BuildContext context) {
    //Old code replaced by Consumer, watch rebuilds both sides pulling and display,
    //while consumer only rebuilds the display part
    // final socialDataStoring = context.watch<SocialDataStoring>();
    // final postContent = socialDataStoring.postDescription.toString();
    // final postLikes = socialDataStoring.likeCount.toString();
    // final postShares = socialDataStoring.shares.toString();

    return Scaffold(
      body: Consumer<SocialDataStoring>(builder: (context, socialData, child) {
        if (socialData.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (socialData.posts.isEmpty) {
          return const Center(
            child: Text("No posts available yet"),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 64),
          itemCount: socialData.posts.length,
          itemBuilder: (context, index) {
            final post = socialData.posts[index];
            return PostWidget(post: post);
          },
        );
      }),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: FloatingActionButton(
          tooltip: "Create Post",
          heroTag: "navigate_to_posting",
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SocialPost()));
          },
          child: const Icon(Icons.add_a_photo),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
