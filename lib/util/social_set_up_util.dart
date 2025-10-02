// postID, postPic, postDescription, datetime, shares/reposts, likeCount, accounts that interacted,

import 'package:cloud_firestore/cloud_firestore.dart';

class SocialSetUpUtil {
  final String? userId;
  String? postID;
  String? postPic;
  String? postDescription;
  DateTime? dateTimePost;
  int? shares;
  int? likeCount;
  Set<String>? likedAccounts;
  // List<String>? interactedAccounts;

  SocialSetUpUtil(
      {this.userId,
      this.postID,
      this.postPic,
      this.postDescription,
      this.dateTimePost,
      this.shares = 0,
      this.likeCount = 0,
      this.likedAccounts
      // List<String>? interactedAccounts,
      });

  // : interactedAccounts = interactedAccounts ?? [];
  // Convert to Map for Firestore

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'postID': postID,
      'postPic': postPic,
      'postDescription': postDescription,
      'dateTimePost': dateTimePost,
      'shares': shares,
      'likeCount': likeCount,
      'likedAccounts': likedAccounts
      //'interactedAccounts': interactedAccounts,
    };
  }
  // Factory constructor to create from Firestore Map

  factory SocialSetUpUtil.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return SocialSetUpUtil(
        userId: data['userId'],
        postID: data['postID'] ?? '',
        postPic: data['postPic'] ?? '',
        postDescription: data['postDescription'] ?? '',
        dateTimePost: (data['dateTimePost'] as Timestamp?)?.toDate(),
        shares: data['shares'] ?? '',
        likeCount: data['likeCount'] ?? '',
        likedAccounts: (data["likedAccounts"] as List?)
            ?.map((account) => account.toString())
            .toSet()
        // interactedAccounts: (data['interactedAccounts'] as List?)?.map((e) => e.toString()).toList()
        );
  }
}
