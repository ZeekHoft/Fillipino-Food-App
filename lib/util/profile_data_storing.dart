//make OOP type sht to make this data accessible to other pages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileDataStoring extends ChangeNotifier {
  //
  String _username =
      'Loading...'; // create instances for  Default loading states
  String _email = 'Loading...';
  int _caloriesLimit = 0;
  String _allergies = 'Loading...';
  bool _isLoading = true;

  String get username => _username;
  String get email => _email;
  int get caloriesLimit => _caloriesLimit;
  String get allergies => _allergies;
  bool get isLoading => _isLoading;

  Future<void> fetchUserData() async {
    _isLoading = true;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      _username = 'Guest';
      _email = 'Not logged in';
      _caloriesLimit = 0;
      _allergies = 'None';
      _isLoading = false;

      notifyListeners(); // listen for any changes that might occur incase currentUser isn't null
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(
              "users_data") // getting data equal to email / find user by email
          .where("email", isEqualTo: currentUser!.email)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final userData = snapshot.docs.first
            .data(); //all data being retreive and specify them below user the term userData
        _username = userData["username"] ?? "N/A";
        _email = userData["email"] ?? "N/A";
        _caloriesLimit = userData["calories"] ?? 0;
        // final caloriesValue = userData["calories"] ?? 0;
        _allergies = (userData["allergies"] as List<dynamic>? ?? []).join(", ");
      }
    } catch (e) {
      print("Fetching Error in user data: ${e}");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
