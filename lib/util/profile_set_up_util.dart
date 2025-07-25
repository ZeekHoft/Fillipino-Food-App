// lib/models/user_profile.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileSetUpUtil {
  final String userId;
  final String? email;
  final String? username;

  // Personal Details (from UserDetails)
  final double? height;
  final double? weight;
  final String? gender;
  final DateTime? birthday;

  // Goals (from UserGoals)
  final List<String>? goals; // Store titles like "Gain Muscles"

  // Allergies & Dietary Restrictions (from UserAllergies)
  final double? caloricLimit;
  final List<String>? dietaryRestrictions; // Store enum names like "glutenFree"

  // Survey (from UserSurvey)
  final String? survey; // Store selected option string

  ProfileSetUpUtil({
    required this.userId,
    this.email,
    this.username,
    this.height,
    this.weight,
    this.gender,
    this.birthday,
    this.goals,
    this.caloricLimit,
    this.dietaryRestrictions,
    this.survey,
  });

  // Helper for copying with new values
  ProfileSetUpUtil copyWith({
    String? email,
    String? username,
    double? height,
    double? weight,
    String? gender,
    DateTime? birthday,
    List<String>? goals,
    double? caloricLimit,
    List<String>? dietaryRestrictions,
    String? survey,
  }) {
    return ProfileSetUpUtil(
      userId: userId, // userId should not change
      email: email ?? this.email,
      username: username ?? this.username,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      goals: goals ?? this.goals,
      caloricLimit: caloricLimit ?? this.caloricLimit,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      survey: survey ?? this.survey,
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'email': email,
      'username': username,
      'height': height,
      'weight': weight,
      'gender': gender,
      'birthday': birthday != null ? Timestamp.fromDate(birthday!) : null,
      'goals': goals,
      'caloricLimit': caloricLimit,
      'dietaryRestrictions': dietaryRestrictions,
      'survey': survey,
      'lastUpdated':
          FieldValue.serverTimestamp(), // Automatically record update time
    };
  }

  // Factory constructor to create from Firestore Map
  factory ProfileSetUpUtil.fromFirestore(Map<String, dynamic> data) {
    return ProfileSetUpUtil(
      userId: data['userId'],
      email: data['email'],
      username: data['username'],
      height: (data['height'] as num?)?.toDouble(),
      weight: (data['weight'] as num?)?.toDouble(),
      gender: data['gender'],
      birthday: (data['birthday'] as Timestamp?)?.toDate(),
      goals: (data['goals'] as List?)?.map((e) => e.toString()).toList(),
      caloricLimit: (data['caloricLimit'] as num?)?.toDouble(),
      dietaryRestrictions: (data['dietaryRestrictions'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      survey: data['survey'],
    );
  }
}
