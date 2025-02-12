import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Input extends StatefulWidget {
  const Input({super.key});

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DAPPLI"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('recipes').snapshots(),
        builder: (context, snapshot) {
          List<Widget> clientWidgets = [];

          if (snapshot.hasData) {
            final recipe = snapshot.data?.docs.reversed.toList();
            for (var recipes in recipe!) {
              final clientWidget = Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(recipes['name']),
                  Expanded(child: Text(recipes['ingredients'])),
                  Expanded(child: Text(recipes['process']))
                ],
              );
              clientWidgets.add(clientWidget);
            }
          }
          return ListView(
            children: clientWidgets,
          );
        },
      ),
    );
  }
}
