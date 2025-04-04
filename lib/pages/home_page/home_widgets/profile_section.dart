import 'package:flilipino_food_app/pages/home_page/home_widgets/username_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileSection extends StatefulWidget {
  const ProfileSection({super.key});

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  final storage = const FlutterSecureStorage();
  String? username;

  // Future<void> _getUsername() async {
  //   username = await storage.read(key: "username") ?? "";
  //   if (username == null || username!.isEmpty) {
  //     if (!mounted) return;
  //     username = await showDialog(
  //         context: context, builder: (context) => const UsernameDialog());
  //   }
  //   setState(() {});
  // } asks the users in app nickname

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _getUsername();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(radius: 32),
        const SizedBox(height: 8),
        if (username != null)
          Text(
            "Hello, $username",
            style: Theme.of(context).textTheme.labelLarge,
          ),
      ],
    );
  }
}
