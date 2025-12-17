import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flilipino_food_app/common_widgets/edit_user_data_form.dart';
import 'package:flilipino_food_app/themes/app_theme.dart';
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
    return Column(
      children: [
        AbsorbPointer(
          absorbing: _isLoading,
          child: Center(
            child: Column(
              children: [
                EditUserDataFormText(
                  controller: dietaryRestrictionsController,
                  hint: 'Dietary Restrictions update',
                ),
                EditUserDataFormText(
                  controller: userNameController,
                  hint: 'User name update',
                ),
                EditUserDataFormNumbers(
                  controller: caloriesLimitController,
                  hint: 'Calorie limit update',
                ),
                EditUserDataFormNumbers(
                  controller: heightController,
                  hint: 'Height update',
                ),
                EditUserDataFormNumbers(
                  controller: weightController,
                  hint: 'Weight update',
                ),
                SizedBox(
                  height: 40,
                ),
                Center(
                    child: _isLoading
                        ? const DappliProgressIndicator()
                        : ElevatedButton(
                            onPressed: () {
                              updateUserData();
                            },
                            child: const Text("Update data")))
              ],
            ),
          ),
        )
      ],
    );
  }
}
