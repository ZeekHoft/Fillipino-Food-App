import 'package:firebase_auth/firebase_auth.dart';
import 'package:flilipino_food_app/pages/social/social_post.dart';
import 'package:flilipino_food_app/pages/social/social_widgets/post_widget.dart';
import 'package:flilipino_food_app/themes/app_theme.dart';
import 'package:flilipino_food_app/util/social_data_storing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SocialPage extends StatefulWidget {
  final bool screenChnage;
  const SocialPage({super.key, required this.screenChnage});

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

    // get user uid as reference
    Future<void> _refreshPge(BuildContext context) async {
      final socialData = Provider.of<SocialDataStoring>(context, listen: false);
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await socialData.fetchUserPost(currentUser.uid);
        await socialData.countUserPost(currentUser.uid);
      }
    }

    if (widget.screenChnage == false) {
      return Scaffold(
        body:
            Consumer<SocialDataStoring>(builder: (context, socialData, child) {
          if (socialData.isLoading) {
            return const Center(child: DappliProgressIndicator());
          }
          if (socialData.posts.isEmpty) {
            return const Center(
              child: Text("No posts available yet"),
            );
          }
          //make the refresher widget a parent of the contents widget
          return RefreshIndicator(
            onRefresh: () => _refreshPge(context),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 64),
              itemCount: socialData.posts.length,
              itemBuilder: (context, index) {
                final post = socialData.posts[index];
                return PostWidget(post: post);
              },
            ),
          );
        }),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: FloatingActionButton(
            tooltip: "Create Post",
            heroTag: "navigate_to_posting",
            onPressed: () async {
              // Add async here
              final result = await Navigator.push(
                  // Add await here
                  context,
                  MaterialPageRoute(builder: (context) => const SocialPost()));
              // If post was successful, refresh the page
              if (result == true) {
                _refreshPge(context);
              }
            },
            child: const Icon(Icons.add_a_photo),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          titleSpacing: 10.0,
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
            ),
          ),
        ),
        body:
            Consumer<SocialDataStoring>(builder: (context, socialData, child) {
          if (socialData.isLoading) {
            return const Center(child: DappliProgressIndicator());
          }
          if (socialData.history.isEmpty) {
            return const Center(
              child: Text("No history available yet"),
            );
          }
          //make the refresher widget a parent of the contents widget
          return RefreshIndicator(
            onRefresh: () => _refreshPge(context),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 64),
              itemCount: socialData.history.length,
              itemBuilder: (context, index) {
                final post = socialData.history[index];
                return PostWidget(post: post);
              },
            ),
          );
        }),
        // floatingActionButton: Padding(
        //   padding: const EdgeInsets.only(bottom: 12.0),
        //   child: FloatingActionButton(
        //     tooltip: "Create Post",
        //     heroTag: "navigate_to_posting",
        //     onPressed: () {
        //       Navigator.push(context,
        //           MaterialPageRoute(builder: (context) => const SocialPost()));
        //     },
        //     child: const Icon(Icons.add_a_photo),
        //   ),
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      );
    }
  }
}
