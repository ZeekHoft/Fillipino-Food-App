import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class UploadApiImage {
  Future<dynamic> uploadImage(
    Uint8List bytes,
    String fileName,
  ) async {
    Uri url = Uri.parse("");
    var request = http.MultipartRequest("POST", url);
    var myFile = http.MultipartFile(
      "file",
      http.ByteStream.fromBytes(bytes),
      bytes.length,
    );
    request.files.add(myFile);
    final response = await request.send();
    if (response.statusCode == 201) {
      var data = await response.stream.bytesToString();
      return jsonDecode(data);
    } else {
      return null;
    }
  }
}
