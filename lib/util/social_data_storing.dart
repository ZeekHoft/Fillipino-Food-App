import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class SocialDataStoring extends ChangeNotifier {
  String? _userId;
  List<Map<String, dynamic>> _posts = [];

  String? _postID;
  String? _postPic;
  String? _postDescription = 'Loading...';
  DateTime? _dateTimePost;
  int? _shares = 0;
  int? _likeCount = 0;
  Set? _likedAccounts = <String>{};
  List<String>? _ingredients = [];
  List<String>? _processSteps = [];
  bool _isLoading = true;

  //checks if the user is logged in or not, if not shows the loading data if they are logged in pulls their data
  late final StreamSubscription<User?> _authStateChangesSubscription;

  String? get userId => _userId;
  List<Map<String, dynamic>> get posts => _posts;

  String? get postID => _postID;
  String? get postPic => _postPic;
  String? get postDescription => _postDescription;
  DateTime? get dateTimePost => _dateTimePost;
  int? get shares => _shares;
  int? get likeCount => _likeCount;
  Set? get likedAccounts => _likedAccounts;
  List<String>? get ingredients => _ingredients;
  List<String>? get processSteps => _processSteps;
  bool get isLoading => _isLoading;

  SocialDataStoring() {
    _authStateChangesSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        fetchUserPost(user.uid);
      } else {
        clearPostData();
      }
    });
  }

  Future<void> fetchUserPost(String uid) async {
    _isLoading = true;
    notifyListeners();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      clearPostData();
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("social_data")
          .where("userId", isEqualTo: uid)
          .get();

      _posts = snapshot.docs.map((doc) {
        final postsData = doc.data();
        print('fetched: $postsData');
        return {
          "postID": postsData["postID"],
          "postPic": postsData["postPic"],
          "postDescription": postsData["postDescription"],
          "dateTimePost": (postsData["dateTimePost"] as Timestamp).toDate(),
          "shares": postsData["shares"],
          "likeCount": postsData["likeCount"],
          "likedAccounts": postsData["likedAccounts"] != null
              ? (postsData["likedAccounts"] as List?)?.toSet()
              : <String>{},
          "ingredients": postsData["ingredients"] != null
              ? (postsData["ingredients"] as List?)
                  ?.map((e) => e.toString())
                  .toList()
              : <String>[],
          "processSteps": postsData["processSteps"] != null
              ? (postsData["processSteps"] as List?)
                  ?.map((e) => e.toString())
                  .toList()
              : <String>[],
        };
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Fetching Error in user posts: $e");
      }

      _userId = "N/A UserID";
      _postID = "N/A postID";
      _postPic = null;
      _postDescription = "N/A";
      _dateTimePost = null;
      _shares = 0;
      _likeCount = 0;
      _likedAccounts = <String>{};
      _ingredients = [];
      _processSteps = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> triggerLike(
      String postId, String accountId, Set postLikedAccounts) async {
    if (postLikedAccounts.contains(accountId)) {
      // Remove account
      postLikedAccounts.remove(accountId);
    } else {
      postLikedAccounts.add(accountId);
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("social_data")
          .where("postID", isEqualTo: postId)
          .get();
      DocumentReference docRef = snapshot.docs[0].reference;
      await docRef.update({"likedAccounts": postLikedAccounts.toList()});

      print('Likes successfully updated!');
    } catch (e) {
      print('Error updating likes: $e');
    }

    notifyListeners();
  }
  // // dont uncoment was added by AI dont know why for the process yet
  // // Method to update ingredients for a specific post
  // Future<void> updateIngredients(
  //     String postId, List<String> ingredients) async {
  //   try {
  //     final snapshot = await FirebaseFirestore.instance
  //         .collection("social_data")
  //         .where("postID", isEqualTo: postId)
  //         .get();

  //     if (snapshot.docs.isNotEmpty) {
  //       DocumentReference docRef = snapshot.docs[0].reference;
  //       await docRef.update({"ingredients": ingredients});

  //       // Update local state
  //       final postIndex = _posts.indexWhere((post) => post["postID"] == postId);
  //       if (postIndex != -1) {
  //         _posts[postIndex]["ingredients"] = ingredients;
  //       }

  //       print('Ingredients successfully updated!');
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     print('Error updating ingredients: $e');
  //   }
  // }

  // // Method to update process steps for a specific post
  // Future<void> updateProcessSteps(
  //     String postId, List<String> processSteps) async {
  //   try {
  //     final snapshot = await FirebaseFirestore.instance
  //         .collection("social_data")
  //         .where("postID", isEqualTo: postId)
  //         .get();

  //     if (snapshot.docs.isNotEmpty) {
  //       DocumentReference docRef = snapshot.docs[0].reference;
  //       await docRef.update({"processSteps": processSteps});

  //       // Update local state
  //       final postIndex = _posts.indexWhere((post) => post["postID"] == postId);
  //       if (postIndex != -1) {
  //         _posts[postIndex]["processSteps"] = processSteps;
  //       }

  //       print('Process steps successfully updated!');
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     print('Error updating process steps: $e');
  //   }
  // }

  void clearPostData() {
    _userId = "N/A UserID";
    _postID = "N/A postID";
    _postPic = null;
    _postDescription = "N/A";
    _dateTimePost = null;
    _shares = 0;
    _likeCount = 0;
    _likedAccounts = <String>{};
    _ingredients = [];
    _processSteps = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _authStateChangesSubscription.cancel();
    super.dispose();
  }
}
