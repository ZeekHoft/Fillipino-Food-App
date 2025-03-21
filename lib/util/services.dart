import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class UploadApiImage {
  final String apiKey = "YOUR_OPENAI_API_KEY"; // Replace with your API key

  Future<String?> uploadImage(Uint8List bytes) async {
    Uri url = Uri.parse("https://api.openai.com/v1/images/generate");

    var request = http.MultipartRequest("POST", url);
    request.headers['Authorization'] = "Bearer $apiKey";
    request.headers['Content-Type'] = "application/json";

    var base64Image = base64Encode(bytes); // Convert image to Base64
    var body = jsonEncode({
      "model": "gpt-4-vision-preview", // Use the latest vision model
      "messages": [
        {"role": "system", "content": "Describe the uploaded image."},
        {
          "role": "user",
          "content": [
            {"type": "image", "data": base64Image} // Send the image
          ]
        }
      ],
      "max_tokens": 100
    });

    var response = await http.post(
      url,
      headers: request.headers,
      body: body,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["choices"][0]["message"]["content"];
    } else {
      return "Error: ${response.body}";
    }
  }
}
