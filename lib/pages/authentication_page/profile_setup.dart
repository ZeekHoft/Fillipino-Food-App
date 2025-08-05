import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flilipino_food_app/common_widgets/link_text_button.dart';
import 'package:flilipino_food_app/pages/authentication_page/authenticate.dart';
import 'package:flilipino_food_app/pages/authentication_page/authentication_widgets/profile_setup_pages.dart';
import 'package:flilipino_food_app/pages/home_page/home_layout.dart';
import 'package:flilipino_food_app/util/profile_data_storing.dart';
import 'package:flilipino_food_app/util/profile_set_up_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Individual pages for each step of setting up the profile

class ProfileSetup extends StatefulWidget {
  final String uid;
  final String? email;
  final String? username;

  const ProfileSetup(
      {super.key,
      required this.uid,
      required this.email,
      required this.username});

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup>
    with TickerProviderStateMixin {
  late PageController _pageViewController;
  int _currentPageIndex = 0;
  // bool _isLastPage = false;
  bool _isLoading = false;

  late ProfileSetUpUtil _currentUserProfile;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _currentUserProfile = ProfileSetUpUtil(
        userId: widget.uid, email: widget.email, username: widget.username);
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  // Callbacks to update _currentUserProfile from child widgets
  void _updateUserDetails({
    double? height,
    double? weight,
    String? gender,
    DateTime? birthday,
  }) {
    _currentUserProfile = _currentUserProfile.copyWith(
      height: height,
      weight: weight,
      gender: gender,
      birthday: birthday,
    );
  }

  void _updateUserGoals(List<String> goals) {
    _currentUserProfile = _currentUserProfile.copyWith(goals: goals);
  }

  void _updateUserAllergies({
    double? caloricLimit,
    List<String>? dietaryRestrictions,
  }) {
    _currentUserProfile = _currentUserProfile.copyWith(
      caloricLimit: caloricLimit,
      dietaryRestrictions: dietaryRestrictions,
    );
  }

  void _updateUserSurvey(String? survey) {
    _currentUserProfile = _currentUserProfile.copyWith(survey: survey);
  }

  Future<void> _submitUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Basic validation: Check if essential fields are not null
      if (_currentUserProfile.height == null ||
          _currentUserProfile.weight == null ||
          _currentUserProfile.gender == null ||
          _currentUserProfile.birthday == null ||
          _currentUserProfile.goals == null ||
          _currentUserProfile.caloricLimit == null ||
          _currentUserProfile.dietaryRestrictions == null ||
          _currentUserProfile.survey == null) {
        // print(_currentUserProfile.height);
        // print(_currentUserProfile.weight);
        // print(_currentUserProfile.gender);
        // print(_currentUserProfile.birthday);
        // print(_currentUserProfile.goals);
        // print(_currentUserProfile.caloricLimit);
        // print(_currentUserProfile.dietaryRestrictions);
        // print(_currentUserProfile.survey);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please fill all required profile details.')),
        );

        return;
      }

      await FirebaseFirestore.instance
          .collection("users_data") // The unified collection
          .doc(_currentUserProfile.userId) // Use UID as document ID
          .set(_currentUserProfile
              .toFirestore()); // Convert model to Map for Firestore

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile setup complete!')),
      );

      // Navigate to your main app screen
      Provider.of<ProfileDataStoring>(context, listen: false).fetchUserData();

      Navigator.pushAndRemoveUntil(
        // Use pushAndRemoveUntil to clear navigation stack
        context,
        MaterialPageRoute(
            builder: (context) => const Authenticate()), // Your main app page
        (route) => false, // Remove all previous routes
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error saving user profile: $e");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save profile: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handlePageChanged(int currentPageIndex) {
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void _goNextPage() {
    if (_currentPageIndex < 3) {
      //change this to 3 not 1, during this time the allergy and how did you hear about us is still not implemented
      // Assuming 0-indexed pages, last page is index 3
      _pageViewController.nextPage(
        duration: Durations.medium3,
        curve: Easing.standard,
      );
    } else {
      // This is the last page, attempt to submit
      _submitUserProfile();
    }
  }

  void _goBackPage() {
    if (_currentPageIndex > 0) {
      _pageViewController.previousPage(
        duration: Durations.medium3,
        curve: Easing.standard,
      );
    }
  }

  // void _skipProfileSetup() {
  //   // Optionally save partial data or just navigate
  //   // For now, just navigate to home page without saving if skipped.
  //   Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(builder: (context) => const HomeLayout()),
  //     (route) => false,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final List<Widget> setupPages = [
      UserDetails(
        onDataChanged: _updateUserDetails,
        initialData: _currentUserProfile,
      ),
      UserGoals(
        onDataChanged: _updateUserGoals,
        initialGoals: _currentUserProfile.goals,
      ),
      UserAllergies(
        onDataChanged: _updateUserAllergies,
        initialCaloricLimit: _currentUserProfile.caloricLimit,
        initialDietaryRestrictions: _currentUserProfile.dietaryRestrictions,
      ),
      UserSurvey(
        onDataChanged: _updateUserSurvey,
        initialSelection: _currentUserProfile.survey,
      )
    ];

    final bool isLastPage = _currentPageIndex == setupPages.length - 1;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 32,
              ),
              child: PageIndicator(
                  totalPages: setupPages.length,
                  currentPageIndex: _currentPageIndex,
                  onUpdateCurrentPage: (index) {
                    // Allow tapping indicator to change page

                    _pageViewController.animateToPage(index,
                        duration: Durations.medium3, curve: Easing.legacy);
                  }),
            ),
            Expanded(
              child: PageView(
                  controller: _pageViewController,
                  onPageChanged: _handlePageChanged,
                  physics:
                      const NeverScrollableScrollPhysics(), // Prevent manual swiping
                  children: setupPages),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _goBackPage,
              child: const Text("Go Back"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              // Exit when on the last page of process
              onPressed: _isLoading ? null : _goNextPage,
              child: isLastPage ? const Text("Done") : const Text("Next"),
            ),
            const SizedBox(height: 16),
            // Center(
            //     child: LinkTextButton(
            //   text: "Skip",
            //   onTap: _isLoading ? null : _skipProfileSetup,
            // )),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // void _handlePageChanged(int currentPageIndex) {
  //   setState(() {
  //     _currentPageIndex = currentPageIndex;
  //     // Determine if currently on last page
  //     if (_currentPageIndex == setupPages.length - 1) {
  //       _isLastPage = true;
  //     } else {
  //       _isLastPage = false;
  //     }
  //   });
  // }

  // void _goNextPage() {
  //   _currentPageIndex += 1;
  //   _pageViewController.animateToPage(_currentPageIndex,
  //       duration: Durations.medium3, curve: Easing.standard);
  // }

  // void _closeProfileSetup() {
  //   print("SEND DATA HERE");
  //   Navigator.pop(context);
  // }
}

// Page indicator displayed on top of page
class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.totalPages,
    required this.currentPageIndex,
    required this.onUpdateCurrentPage,
  });

  final int totalPages;
  final int currentPageIndex;
  final void Function(int) onUpdateCurrentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
        children: List.generate(
      totalPages,
      (index) {
        return IndicatorSegment(
          isCurrentIndex: index == currentPageIndex,
        );
      },
    ));
  }
}

class IndicatorSegment extends StatelessWidget {
  const IndicatorSegment({super.key, required this.isCurrentIndex});

  final bool isCurrentIndex;

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).colorScheme.primary;
    final unactiveColor = Theme.of(context).colorScheme.surface;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Container(
          height: 6,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: isCurrentIndex ? activeColor : unactiveColor),
        ),
      ),
    );
  }
}
