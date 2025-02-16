import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

//reusable stream so that this can give accesss to other pages without re building the whole streambuilder
class RecipeStreamBuilder extends InheritedWidget {
  final Stream<QuerySnapshot> recipeStream =
      FirebaseFirestore.instance.collection('recipes').snapshots();

  RecipeStreamBuilder({super.key, required super.child});

  static RecipeStreamBuilder? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RecipeStreamBuilder>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
