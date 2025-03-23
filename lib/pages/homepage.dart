import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;

  Homepage({super.key});
  void singOutButton() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: singOutButton, icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Text("HOMEPAGE DEFAULT ${user.email}"),
    );
  }
}
