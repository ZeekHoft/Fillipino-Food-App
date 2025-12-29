import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flilipino_food_app/common_widgets/edit_user_data_form.dart';
import 'package:flilipino_food_app/themes/app_theme.dart';
import 'package:flilipino_food_app/themes/color_themes.dart';
import 'package:flilipino_food_app/util/profile_data_storing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileData extends StatefulWidget {
  const EditProfileData({super.key});

  @override
  State<EditProfileData> createState() => _EditProfileDataState();
}

class _EditProfileDataState extends State<EditProfileData> {
  @override
  Widget build(BuildContext context) {
    final profileDataStoring = context.watch<ProfileDataStoring>();

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
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users_data')
              .doc(profileDataStoring.userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return DappliProgressIndicator();
            }

            var userData = snapshot.data!.data();
            List<dynamic> dietaryRestrictions =
                userData!['dietaryRestrictions'];
            int caloricLimit = userData['caloricLimit'];
            String username = userData['username'];
            int height = userData['height'];
            int weight = userData['weight'];
            String userId = userData['userId'];

            return UpdateForm(
              caloriesLimit: caloricLimit,
              userName: username,
              dietaryRestrictions: dietaryRestrictions,
              height: height,
              weight: weight,
              userId: userId,
            );
          },
        ));
  }
}

class UpdateForm extends StatefulWidget {
  final List<dynamic> dietaryRestrictions;
  // final String dietaryRestrictions;
  final String userName;
  final int caloriesLimit;
  final int height;
  final int weight;
  final String userId;
  const UpdateForm(
      {super.key,
      required this.caloriesLimit,
      required this.userName,
      required this.dietaryRestrictions,
      required this.height,
      required this.weight,
      required this.userId});

  @override
  State<UpdateForm> createState() => _UpdateFormState();
}

Future<void> _refreshPge(BuildContext context) async {
  final userData = Provider.of<ProfileDataStoring>(context, listen: false);
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    await userData.fetchUserData();
  }
}

class _UpdateFormState extends State<UpdateForm> {
  final dietaryRestrictionsController = TextEditingController();
  final userNameController = TextEditingController();
  final caloriesLimitController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  bool _isLoading = false;

  void updateUserData() async {
    setState(() {
      _isLoading = true;
    });
    var collection = FirebaseFirestore.instance.collection('users_data');
    List<String> updatedRestrictions = dietaryRestrictionsController
        .text // didn't porcess it as a list but a text/string
        .split(',')
        .map((e) => e.trim())
        .toList();

    await collection.doc(widget.userId).update({
      'dietaryRestrictions': updatedRestrictions,
      'caloricLimit': int.parse(caloriesLimitController.text),
      'username': userNameController.text, // String
      'height': int.parse(heightController.text),
      'weight': int.parse(weightController.text),
    });

    await _refreshPge(context);

    if (mounted) {
      Navigator.pop(context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    dietaryRestrictionsController.text =
        (widget.dietaryRestrictions).join(', ');
    userNameController.text = widget.userName;
    caloriesLimitController.text = widget.caloriesLimit
        .toString(); // convert not cast (as string) not good
    heightController.text =
        widget.height.toString(); // here and below dont use cast
    weightController.text = widget.weight.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _isLoading,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader("Personal Identity", Icons.person_outline),
            _buildFormCard([
              _buildFieldLabel("Username"),
              EditUserDataFormText(
                controller: userNameController,
                hint: 'Enter your new username',
              ),
            ]),
            const SizedBox(height: 24),
            _buildHeader("Body Metrics", Icons.straighten),
            _buildFormCard([
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel("Height (CM)"),
                        EditUserDataFormNumbers(
                          controller: heightController,
                          hint: 'CM',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel("Weight (KG)"),
                        EditUserDataFormNumbers(
                          controller: weightController,
                          hint: 'KG',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildFieldLabel("Daily Caloric Limit"),
              EditUserDataFormNumbers(
                controller: caloriesLimitController,
                hint: 'e.g. 2000',
              ),
            ]),
            const SizedBox(height: 24),
            _buildHeader("Dietary Safety", Icons.no_food_outlined),
            _buildFormCard([
              _buildFieldLabel("Allergies (Separate by comma)"),
              EditUserDataFormText(
                controller: dietaryRestrictionsController,
                hint: 'Garlic, Peanuts, Shrimp...',
              ),
              const SizedBox(height: 8),
              Text(
                "This helps us flag recipes that might be unsafe for you.",
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ]),
            const SizedBox(height: 40),
            Center(
              child: _isLoading
                  ? const DappliProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: AppColors.blueTheme,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: updateUserData,
                        child: const Text(
                          "SAVE CHANGES",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.blueTheme),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 1.1,
              color: AppColors.blueTheme,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }

  Widget _buildFormCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
