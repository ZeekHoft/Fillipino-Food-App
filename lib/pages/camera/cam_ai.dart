import 'dart:convert';
import 'package:flilipino_food_app/pages/home_page/home_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

// Main entry point of the Flutter application
// void main() {
//   runApp(const MyApp());
// }

// // MyApp is the root widget of the application
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'AI Recipe Generator',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//         fontFamily: 'Inter', // Using Inter font as per instructions
//       ),
//       home: const RecipeGeneratorScreen(),
//     );
//   }
// }

// RecipeGeneratorScreen is the main screen of the application
class RecipeGeneratorScreen extends StatefulWidget {
  const RecipeGeneratorScreen({super.key});

  @override
  State<RecipeGeneratorScreen> createState() => _RecipeGeneratorScreenState();
}

class _RecipeGeneratorScreenState extends State<RecipeGeneratorScreen> {
  // State variables to hold recipe data and UI state
  String? _recipeName;
  List<String>? _ingredientsList;
  List<String>? _instructions;
  String?
      _recipeImageBase64; // This will remain null as ChatGPT cannot generate images.
  bool _isLoading = false;
  String? _errorMessage;

  // Initialize ImagePicker instance
  final ImagePicker _picker = ImagePicker();

  // API key for ChatGPT - IMPORTANT: Replace with your actual API key.
  // For production, use environment variables or a secure configuration.
  final String _chatGptApiKey =
      dotenv.env["API_KEY_CHAT_GPT"]!; // Your ChatGPT API Key (e.g., sk-...)

  // Function to pick an image from the camera
  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _recipeName = null;
      _ingredientsList = null;
      _instructions = null;
      _recipeImageBase64 = null; // Reset image
    });

    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        // Read image bytes and encode to Base64
        List<int> imageBytes = await image.readAsBytes();
        String base64Image = base64Encode(imageBytes);

        // Step 1: Get ingredients from image using ChatGPT Vision API (e.g., GPT-4o)
        final String? identifiedIngredients =
            await _getIngredientsFromImage(base64Image);

        if (identifiedIngredients != null) {
          // Step 2: Generate recipe text using ChatGPT Text API
          final Map<String, dynamic>? recipeData =
              await _generateRecipeText(identifiedIngredients);

          if (recipeData != null) {
            setState(() {
              _recipeName = recipeData['recipeName'];
              _ingredientsList =
                  List<String>.from(recipeData['ingredientsList']);
              _instructions = List<String>.from(recipeData['instructions']);
            });

            // Note: ChatGPT does not generate images. _recipeImageBase64 will remain null.
            // If you need image generation, you would need to integrate a separate image generation API.
          }
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
      print('Error during recipe generation: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to call ChatGPT Vision API for ingredient recognition
  // Uses GPT-4o model for multimodal capabilities.
  Future<String?> _getIngredientsFromImage(String base64Image) async {
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_chatGptApiKey',
        },
        body: jsonEncode({
          "model": "gpt-4o", // Use a model capable of vision, e.g., gpt-4o
          "messages": [
            {
              "role": "user",
              "content": [
                {
                  "type": "text",
                  "text":
                      "What ingredients do you see in this image? List them concisely, separated by commas."
                },
                {
                  "type": "image_url",
                  "image_url": {"url": "data:image/jpeg;base64,$base64Image"}
                }
              ]
            }
          ],
          "max_tokens": 300, // Limit response length for ingredients
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // Extract and return ingredients text
        return jsonResponse['choices'][0]['message']['content'];
      } else {
        throw Exception(
            'Failed to get ingredients from ChatGPT: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error getting ingredients from image using ChatGPT: $e');
      rethrow;
    }
  }

  // Function to call ChatGPT Text API for recipe generation
  Future<Map<String, dynamic>?> _generateRecipeText(String ingredients) async {
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_chatGptApiKey',
        },
        body: jsonEncode({
          "model":
              "gpt-4o", // You can use gpt-3.5-turbo or gpt-4 for text generation
          "messages": [
            {
              "role": "system",
              "content":
                  "You are a helpful assistant that generates recipes. Your output must be a JSON object."
            },
            {
              "role": "user",
              "content":
                  "Based on these ingredients: $ingredients, generate a recipe. Provide the recipe name, a list of ingredients with quantities, and step-by-step instructions. Format the response as a JSON object with keys: 'recipeName' (string), 'ingredientsList' (array of strings), 'instructions' (array of strings)."
            }
          ],
          "response_format": {"type": "json_object"}, // Request JSON output
          "max_tokens": 1000, // Adjust as needed for recipe length
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final String jsonString =
            jsonResponse['choices'][0]['message']['content'];
        // The response content is already a JSON string, parse it directly
        return jsonDecode(jsonString);
      } else {
        throw Exception(
            'Failed to generate recipe text from ChatGPT: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error generating recipe text using ChatGPT: $e');
      rethrow;
    }
  }

  // This function is no longer used as ChatGPT does not generate images.
  // Kept for reference.
  // Future<String?> _generateRecipeImage(String recipeName) async {
  //   // ChatGPT does not provide image generation.
  //   // You would need a separate image generation API (like DALL-E or Imagen).
  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.exit_to_app)),
        title: const Text('AI Recipe Generator'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Button to pick image
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take Picture of Ingredients'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),

            // Loading indicator
            if (_isLoading)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('Generating recipe...',
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),

            // Error message display
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade400),
                ),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(
                      color: Colors.red.shade800, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),

            // Display generated recipe image (will be empty if using only ChatGPT)
            if (_recipeImageBase64 != null)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    base64Decode(_recipeImageBase64!),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 250, // Fixed height for recipe image
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 250,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Text('Could not load image',
                            style: TextStyle(color: Colors.black54)),
                      ),
                    ),
                  ),
                ),
              ),
            // Message if no image is generated
            if (!_isLoading &&
                _recipeName != null &&
                _recipeImageBase64 == null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Note: Image generation is not available with ChatGPT. You can integrate a separate image generation API (e.g., DALL-E) if needed.',
                  style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 20),

            // Display recipe name
            if (_recipeName != null)
              Text(
                _recipeName!,
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 20),

            // Display ingredients list
            if (_ingredientsList != null && _ingredientsList!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ingredients:',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(), // Disable scrolling for nested ListView
                      itemCount: _ingredientsList!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            '• ${_ingredientsList![index]}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),

            // Display instructions
            if (_instructions != null && _instructions!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Instructions:',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(), // Disable scrolling for nested ListView
                      itemCount: _instructions!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            '${index + 1}. ${_instructions![index]}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
