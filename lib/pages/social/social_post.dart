import 'package:flutter/material.dart';

class SocialPost extends StatefulWidget {
  const SocialPost({super.key});

  @override
  State<SocialPost> createState() => _SocialPostState();
}

class _SocialPostState extends State<SocialPost> {
  final _formKey = GlobalKey<FormState>();
  final _postPic = TextEditingController();
  final _postDescription = TextEditingController();
  final _datetime = TextEditingController();
  final _shares = TextEditingController();
  final _likeCount = TextEditingController();
  // final _interactedAccounts = TextEditingController();

// postID, postPic, postDescription, datetime, shares/reposts, likeCount, accounts that interacted,
  @override
  Widget build(BuildContext context) {
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
        body: Padding(
          padding: EdgeInsetsGeometry.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: TextFormField(
                    controller: _postDescription,
                    decoration: const InputDecoration(labelText: "Description"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
