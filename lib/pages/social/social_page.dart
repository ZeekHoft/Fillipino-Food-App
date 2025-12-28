import 'package:firebase_auth/firebase_auth.dart';
import 'package:flilipino_food_app/pages/social/social_post_dialog.dart';
import 'package:flilipino_food_app/pages/social/social_widgets/post_widget.dart';
import 'package:flilipino_food_app/themes/app_theme.dart';
import 'package:flilipino_food_app/util/social_data_storing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SocialPage extends StatefulWidget {
  final bool showUserPosts;
  const SocialPage({super.key, required this.showUserPosts});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SocialDataStoring>(
      builder: (context, socialData, child) {
        List socialPosts;

        // Choose to display all posts or only posts made by current user
        if (widget.showUserPosts) {
          socialPosts = socialData.history;
        } else {
          socialPosts = socialData.posts;
        }

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: widget.showUserPosts
              ? AppBar(
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
                )
              : null,
          floatingActionButton: !widget.showUserPosts
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: FloatingActionButton(
                    tooltip: "Create Post",
                    heroTag: "navigate_to_posting",
                    onPressed: () async {
                      // Add async here
                      final result = await Navigator.push(
                          // Add await here
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SocialPostDialog()));
                      // If post was successful, refresh the page
                      if (result == true && context.mounted) {
                        _refreshPage(context);
                      }
                    },
                    child: const Icon(Icons.post_add_outlined),
                  ),
                )
              : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          body: _buildScaffoldBody(socialData, socialPosts, context),
        );
      },
    );
  }

  /// Fetches posts using user UID
  Future<void> _refreshPage(BuildContext context) async {
    final socialData = Provider.of<SocialDataStoring>(context, listen: false);
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await socialData.fetchUserPost(currentUser.uid);
    }
  }

  /// Returns a widget depending on the state of socialData.
  Widget _buildScaffoldBody(SocialDataStoring socialData,
      List<dynamic> socialPosts, BuildContext context) {
    if (socialData.isLoading) {
      return const Center(child: DappliProgressIndicator());
    }

    if (socialPosts.isEmpty) {
      return const Center(child: Text("No posts available yet!"));
    }

    return RefreshIndicator(
      onRefresh: () => _refreshPage(context),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 64),
        itemCount: socialPosts.length,
        itemBuilder: (context, index) {
          final post = socialPosts[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: PostWidget(post: post),
          );
        },
      ),
    );
  }
}
