import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flilipino_food_app/common_widgets/social_post_inputs.dart';
import 'package:flilipino_food_app/util/profile_data_storing.dart';
import 'package:flilipino_food_app/util/social_data_storing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

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
  final uuid = const Uuid();
  // final _interactedAccounts = TextEditingController();

  @override
  void dispose() {
    _postDescription.dispose();
    _datetime.dispose();
    _shares.dispose();
    _likeCount.dispose();
    super.dispose();
  }

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
                SocialPostInputs(
                  controller: _postDescription,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  labelText: "Description",
                  errorText: 'Please enter Description',
                ),
                ElevatedButton(onPressed: _savePost, child: const Text("Post!"))
              ],
            ),
          ),
        ));
  }

  void _savePost() async {
    try {
      if (_formKey.currentState!.validate()) {
        final postDescription = _postDescription.text;
        //user watch for consistent chagnges such as names, allergies, dietary restriction etc... use read to only fetch the thing that is needed when something is finished
        final profileDataStoring = context.read<ProfileDataStoring>();
        final parameterPosts = SocialDataStoring(
            userId: profileDataStoring.userId!,
            postID: uuid.v1(),
            postPic: '',
            postDescription: postDescription,
            dateTimePost: DateTime.now());

        try {
          final postData = parameterPosts.toFirestore();
          await FirebaseFirestore.instance
              .collection('social_data')
              .add(postData);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Successfully Posted!!")));
          Navigator.pop(context);
          _postDescription.clear();
          _datetime.clear();
          _shares.clear();
          _likeCount.clear();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to post: $e')),
          );
        }
      }
    } catch (e) {
      print("ERROR HERE: $e");
    }
  }
}
