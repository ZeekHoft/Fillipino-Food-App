import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;

class ClaudinaryUploader {
  static String cloudName = dotenv.env["CLOUDINARY_NAME"]!;
  static String cloudinaryPreset = dotenv.env["CLODINARY_PRESET"]!;

  static Future<String?> uploadFile(XFile file) async {
    try {
      final mimeTypeData = lookupMimeType(file.path)?.split('/');
      final uploadUrl =
          "https://api.cloudinary.com/v1_1/$cloudName/auto/upload";

      final request = http.MultipartRequest('POST', Uri.parse(uploadUrl))
        ..fields['upload_preset'] = cloudinaryPreset
        ..files.add(await http.MultipartFile.fromPath('file', file.path,
            contentType: mimeTypeData != null
                ? MediaType(mimeTypeData[0], mimeTypeData[1])
                : null));

      final response = await request.send();
      final result = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        final data = jsonDecode(result.body);
        return data['secure_url'];
      } else {
        print("failed");
        return null;
      }
    } catch (e) {
      print("upload error");
      return null;
    }
  }
}
