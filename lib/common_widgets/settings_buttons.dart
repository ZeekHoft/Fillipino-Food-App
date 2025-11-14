import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingsButtons extends StatelessWidget {
  final Widget pageRoute;
  final Icon settingsIcon;
  final Text settingsText;

  const SettingsButtons(
      {super.key,
      required this.pageRoute,
      required this.settingsIcon,
      required this.settingsText});
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => pageRoute));
        },
        child: ListTile(
          leading: settingsIcon,
          title: settingsText,
        ));
  }
}
