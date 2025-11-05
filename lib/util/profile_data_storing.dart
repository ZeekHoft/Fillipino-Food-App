//make OOP type sht to make this data accessible to other pages

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ProfileDataStoring extends ChangeNotifier {
  //
  String _username =
      'Loading...'; // create instances for  Default loading states
  String _email = 'Loading...';
  int _caloriesLimit = 0;
  String _allergies = 'Loading...';
  String _gender = "Loading...";
  double? _height;
  double? _weight;
  DateTime? _birthday;
  List<String> _goals = [];
  bool _isLoading = true;
  String? _survey;
  String? _userId;

  late final StreamSubscription<User?> _authStateChangesSubscription;

  String get username => _username;
  String get email => _email;
  int get caloriesLimit => _caloriesLimit;
  String get allergies => _allergies;
  String get gender => _gender;
  double? get height => _height;
  double? get weight => _weight;
  DateTime? get birthday => _birthday;
  List<String> get goals => _goals;
  String? get surevey => _survey;
  bool get isLoading => _isLoading;
  String? get userId => _userId;

  ProfileDataStoring() {
    _authStateChangesSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        fetchUserData();
      } else {
        clearUserData();
      }
    });
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    _isLoading = true;
    notifyListeners();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      clearUserData();
      return;
    }

    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection("users_data")
          .doc(currentUser.uid)
          .get();
      // top level fields, specific pieces of information that are displayed on the first page
      if (docSnapshot.exists) {
        final userData = docSnapshot.data()!;
        _email = userData["email"] ?? currentUser.email ?? "N/A";
        _username = userData["username"] ?? "N/A";
        _caloriesLimit = userData["caloric_limit"] ?? 0;
        _allergies =
            (userData["dietaryRestrictions"] as List<dynamic>?)?.join(", ") ??
                "None";
        _goals = List<String>.from(userData["goals"] ?? []);
        _survey = userData["survey_source"] as String?;

        _gender = userData["gender"] ?? "N/A";
        _height =
            (userData["height"] as num?)?.toDouble(); // Cast num to double
        _weight =
            (userData["weight"] as num?)?.toDouble(); // Cast num to double
        final Timestamp? birthdayTimestamp = userData["birthday"] as Timestamp?;
        _birthday = birthdayTimestamp?.toDate();
        _userId = userData["userId"] ?? "N/A UserID";
      } else {
        // This case would mean a user is authenticated but no profile document exists
        // (e.g., if they were created before profile setup was completed or if there's a data sync issue)
        _email = currentUser.email ?? 'N/A';
        _username = 'N/A (Profile not set)'; // More descriptive
        _caloriesLimit = 0;
        _allergies = 'None';
        _gender = 'N/A';
        _height = null;
        _weight = null;
        _birthday = null;
        _goals = [];
        _survey = null;
        _userId = "N/A UserID";

        if (kDebugMode) {
          print(
              "No user profile document found for UID: ${currentUser.uid} in 'users' collection.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Fetching Error in user data: $e");
      }
      // Set to N/A on error
      _email = currentUser.email ?? 'N/A';
      _username = 'Error loading';
      _caloriesLimit = 0;
      _allergies = 'Error';
      _gender = 'Error';
      _height = null;
      _weight = null;
      _birthday = null;
      _goals = [];
      _survey = null;
      _userId = "Error no UserID";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // final currentUser = FirebaseAuth.instance.currentUser;
  // if (currentUser == null) {
  //   _username = 'Guest';
  //   _email = 'Not logged in';
  //   _caloriesLimit = 0;
  //   _allergies = 'None';
  //   _isLoading = false;

  //   notifyListeners(); // listen for any changes that might occur incase currentUser isn't null
  //   return;
  // }

  // try {
  //   final snapshot = await FirebaseFirestore.instance
  //       .collection(
  //           "users_data") // getting data equal to email / find user by email
  //       .where("uid", isEqualTo: currentUser.uid)
  //       .limit(1)
  //       .get();
  //   if (snapshot.docs.isNotEmpty) {
  //     final userData = snapshot.docs.first
  //         .data(); //all data being retreive and specify them below user the term userData
  //     _username = userData["username"] ?? "N/A";
  //     _email = userData["email"] ?? "N/A";
  //     _caloriesLimit = userData["calories"] ?? 0;
  //     // final caloriesValue = userData["calories"] ?? 0;
  //     _allergies = (userData["allergies"] as List<dynamic>? ?? []).join(", ");
  //   }
  // } catch (e) {
  //   if (kDebugMode) {
  //     print("Fetching Error in user data: ${e}");
  //   }
  // } finally {
  //   _isLoading = false;
  //   notifyListeners();
  // }
  void clearUserData() {
    _email = "Not logged in";
    _username = "Not logged in";
    _caloriesLimit = 0;
    _allergies = "None";
    _gender = "N/A";
    _height = null;
    _weight = null;
    _birthday = null;
    _goals = [];
    _survey = null;
    _isLoading = false;
    _userId = "Error no UserID";
    notifyListeners();
  }

  @override
  void dispose() {
    _authStateChangesSubscription.cancel();
    super.dispose();
  }
}
