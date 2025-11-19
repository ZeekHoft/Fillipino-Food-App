import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flilipino_food_app/common_widgets/social_post_dish_data.dart';
import 'package:flilipino_food_app/common_widgets/social_post_inputs.dart';
import 'package:flilipino_food_app/themes/app_theme.dart';
import 'package:flilipino_food_app/util/profile_data_storing.dart';
import 'package:flilipino_food_app/util/social_set_up_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class SocialPost extends StatefulWidget {
  const SocialPost({super.key});

  @override
  State<SocialPost> createState() => _SocialPostState();
}

class _SocialPostState extends State<SocialPost> {
  final _formKey = GlobalKey<FormState>();
  // final _postPic = TextEditingController();
  final _postDescription = TextEditingController();
  final _ingredientList = TextEditingController();
  final _processList = TextEditingController();
  final _datetime = TextEditingController();
  final _shares = TextEditingController();
  final _likeCount = TextEditingController();
  final _caloriePost = TextEditingController();

  // bool _isLoading = false;

  Uint8List? galleryBytes;
  final picker = ImagePicker();

  // final _interactedAccounts = TextEditingController();

  @override
  void dispose() {
    _postDescription.dispose();
    _ingredientList.dispose();
    _processList.dispose();
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      foregroundColor:
                          Theme.of(context).colorScheme.onSecondaryContainer),
                  child: const Text('Select Image from Gallery or Camera'),
                  onPressed: () {
                    _showPicker(context: context);
                  },
                ),
                Container(
                  child: galleryBytes == null
                      ? const Center(child: Text("Nothing is Selected."))
                      : Center(
                          child: Image.memory(galleryBytes!, fit: BoxFit.cover),
                        ),
                ),
                SocialPostInputs(
                  controller: _postDescription,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  labelText: "Description",
                  errorText: 'Please enter Description',
                  border: OutlineInputBorder(),
                ),
                const SizedBox(
                  height: 10,
                ),
                SocialPostDishData(
                  controller: _ingredientList,
                  labeltext: 'Enter ingredient',
                  hintext: 'e.g., Tomatoes, Onions, Garlic,...',
                  prefixicon: Icon(Icons.local_grocery_store_sharp),
                  border: OutlineInputBorder(),
                  keyboardtype: TextInputType.text,
                ),
                const SizedBox(
                  height: 10,
                ),
                SocialPostDishData(
                  controller: _processList,
                  labeltext: 'Enter Process',
                  hintext:
                      'e.g., Chop the onions and garlic, steam the tomatoes,...',
                  prefixicon: Icon(Icons.format_list_bulleted),
                  border: OutlineInputBorder(),
                  keyboardtype: TextInputType.text,
                ),
                const SizedBox(
                  height: 10,
                ),
                SocialPostDishData(
                  controller: _caloriePost,
                  labeltext: 'Enter Food Post Calories',
                  hintext: 'e.g., 100 or 1300',
                  prefixicon: Icon(Icons.numbers),
                  border: OutlineInputBorder(),
                  maxlength: 5,
                  keyboardtype: TextInputType.number,
                  inputformat: FilteringTextInputFormatter(RegExp(r'[0-9]'),
                      allow: true),
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(onPressed: _savePost, child: const Text("Post!"))
              ],
            ),
          ),
        ));
  }

  void _showPicker({required BuildContext context}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
        });
  }

  Future getImage(
    ImageSource img,
  ) async {
    // pick image from gallary
    final pickedFile = await picker.pickImage(source: img);
    // store it in a valid variable
    if (pickedFile != null) {
      // store that in global variable galleryBytes in the form of File
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        galleryBytes = bytes;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
          const SnackBar(content: Text('Nothing is selected')));
    }
  }

  Future _savePost() async {
    final profileDataStoring = context.read<ProfileDataStoring>();
    final username = profileDataStoring.username;
    final userId = profileDataStoring.userId;
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: DappliProgressIndicator(),
        );
      },
    );
    try {
      if (_formKey.currentState!.validate()) {
        final postDescription = _postDescription.text;
        final caloriePost = int.tryParse(_caloriePost.text); // parse to int
        // as the controller takes the users input as a string we covnert it to a list for each comma we seperate them
        final ingredientList = _ingredientList.text.isNotEmpty
            ? _ingredientList.text.split(',').map((e) => e.trim()).toList()
            : <String>[];
        final processList = _processList.text.isNotEmpty
            ? _processList.text.split(',').map((e) => e.trim()).toList()
            : <String>[];
        //user watch for consistent chagnges such as names, allergies, dietary restriction etc... use read to only fetch the thing that is needed when something is finished
        final postIDReference =
            FirebaseFirestore.instance.collection('social_data').doc();
        final postId = postIDReference.id;

        final parameterPosts = SocialSetUpUtil(
            userId: userId,
            postID: postId,
            // change the postpic from string ot Uint8List form social data storing
            postPic: "",
            likeCount: 0,
            shares: 0,
            postDescription: postDescription,
            postUsername: username,
            calories: caloriePost,
            ingredients: ingredientList,
            processSteps: processList,
            dateTimePost: DateTime.now(),
            likedAccounts: <String>{});
        // print("PICTURE HERE: $galleryBytes");
        try {
          final postData = parameterPosts.toFirestore();
          await FirebaseFirestore.instance
              .collection('social_data')
              .add(postData);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Successfully Posted!!")));
          Navigator.pop(context);
          _postDescription.clear();
          _ingredientList.clear();
          _processList.clear();
          _datetime.clear();
          _shares.clear();
          _likeCount.clear();
          setState(() {
            galleryBytes = null;
          });
        } catch (e) {
          print("Faile Post: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to post: $e')),
          );
        }
        Navigator.pop(context, true);
      }
    } catch (e) {
      print("ERROR HERE: $e");
    }
  }
}
