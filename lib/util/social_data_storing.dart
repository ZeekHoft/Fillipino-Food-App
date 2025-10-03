// required this.userId,
// required this.postID,
// required this.postPic,
// required this.postDescription,
// required this.dateTimePost,
// this.shares = 0,
// this.likeCount = 0,

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
  bool get isLoading => _isLoading;

  SocialDataStoring() {
    _authStateChangesSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        fetchUserPost(user.uid);
      } else {
        //clearPostData
      }
    });
  }

  Future<void> fetchUserPost(String uid) async {
    _isLoading = true;
    notifyListeners();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      //clearPostData();
      return;
    }
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
            : <String>{}
      };
    }).toList();

    //old code not built for pulling a list of data
    // if (snapshot.docs.isNotEmpty) {
    //   final userPosts = snapshot.docs.first.data()!;
    //   _userId = userPosts["userId"] ?? "N/A";
    //   _postID = userPosts["postID"] ?? "N/A";
    //   _postPic = userPosts["postPic"] ?? "N/A";
    //   _postDescription = userPosts["postDescription"] ?? "N/A";
    //   final Timestamp? birthdayTimestamp =
    //       userPosts["dateTimePost"] as Timestamp?;
    //   _dateTimePost = birthdayTimestamp?.toDate();
    //   _shares = userPosts["shares"] ?? 0;
    //   _likeCount = userPosts["likeCount"] ?? 0;
    // } else {
    //   _userId = "N/A UserID";
    //   _postID = "N/A psotID";
    //   _postPic = null;
    //   _postDescription = "N/A";
    //   _dateTimePost = null;
    //   _shares = 0;
    //   _likeCount = 0;
    // }

    try {} catch (e) {
      if (kDebugMode) {
        print("Fetching Error in user posts: $e");
      }

      _userId = "N/A UserID";
      _postID = "N/A psotID";
      _postPic = null;
      _postDescription = "N/A";
      _dateTimePost = null;
      _shares = 0;
      _likeCount = 0;
      _likedAccounts = <String>{};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> triggerLike(
      String postId, String accountId, Set postLikedAccounts) async {
    if (postLikedAccounts.contains(accountId)) {
      // Remove acc
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

  void clearPostData() {
    _userId = "N/A UserID";
    _postID = "N/A psotID";
    _postPic = null;
    _postDescription = "N/A";
    _dateTimePost = null;
    _shares = 0;
    _likeCount = 0;
    _likedAccounts = <String>{};
    notifyListeners();
  }

  @override
  void dispose() {
    _authStateChangesSubscription.cancel();
    super.dispose();
  }
}
