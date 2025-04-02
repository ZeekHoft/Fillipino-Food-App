import 'package:flilipino_food_app/pages/authentication_page/authentication_widgets/credential_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UsernameDialog extends StatefulWidget {
  const UsernameDialog({super.key});

  @override
  State<UsernameDialog> createState() => _UsernameDialogState();
}

class _UsernameDialogState extends State<UsernameDialog> {
  final usernameController = TextEditingController();
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Enter a username",
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "What should we call you?",
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          CredentialField(
            controller: usernameController,
            hintText: "Username",
            obscureText: false,
            onChangeFunc: (value) => setState(() {}),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: usernameController.text.isNotEmpty
              ? () async {
                  await storage.write(
                      key: "username", value: usernameController.text);
                  if (context.mounted) {
                    Navigator.pop(context, usernameController.text);
                  }
                }
              : null,
          child: const Text("Confirm"),
        ),
      ],
    );
  }
}
