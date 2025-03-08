import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flilipino_food_app/util/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Image_Picker extends StatefulWidget {
  const Image_Picker({super.key});

  @override
  State<Image_Picker> createState() => _Image_PickerState();
}

class _Image_PickerState extends State<Image_Picker> {
  @override
  String IsImageUpload = "";
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    Uint8List bytes = await image.readAsBytes();
                    UploadApiImage()
                        .uploadImage(bytes, image.name)
                        .then((value) {
                      setState(() {
                        IsImageUpload = value['location'].toString();
                      });
                      print(
                          "uplaode successfully eto link par: ${value.toString()}");
                    }).onError(
                      (error, stackTrace) {
                        print(error.toString());
                      },
                    );
                  }
                },
                child: const Text(
                  "Upload Image",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}
