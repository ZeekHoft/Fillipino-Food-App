import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class RecipeGeneratorAI extends StatelessWidget {
  final List<CameraDescription> cameras;

  const RecipeGeneratorAI({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filipino Recipe Finder',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: CameraScreen(cameras: cameras),
    );
  }
}

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isLoading = false;
  String? _capturedImagePath;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();

      setState(() {
        _capturedImagePath = image.path;
        _isLoading = true;
      });

      // Get recipes from ChatGPT
      final recipes = await _getRecipesFromImage(image.path);

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeResultScreen(
              imagePath: image.path,
              recipes: recipes,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<List<Recipe>> _getRecipesFromImage(String imagePath) async {
    // Replace with your OpenAI API key
    final apiKey = dotenv.env["API_KEY_CHAT_GPT"]!;

    final bytes = await File(imagePath).readAsBytes();
    final base64Image = base64Encode(bytes);

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4o',
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'text',
                'text':
                    '''Analyze this image and identify all the ingredients visible. 
Then provide EXACTLY 5 Filipino recipes that can be made using ONLY the ingredients you see in this image.

IMPORTANT RULES:
1. Only suggest recipes where ALL ingredients are visible in the image
2. Do not suggest recipes that require ingredients not shown
3. Provide exactly 5 recipes
4. All recipes must be Filipino cuisine

Format each recipe as:
RECIPE NAME: [name]
INGREDIENTS: [list ingredients from image]
INSTRUCTIONS: [step by step cooking instructions]
PREP TIME: [time]
---'''
              },
              {
                'type': 'image_url',
                'image_url': {'url': 'data:image/jpeg;base64,$base64Image'}
              }
            ]
          }
        ],
        'max_tokens': 2000,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['choices'][0]['message']['content'];
      return _parseRecipes(content);
    } else {
      throw Exception('Failed to get recipes: ${response.body}');
    }
  }

  List<Recipe> _parseRecipes(String content) {
    final recipes = <Recipe>[];
    final recipeBlocks = content.split('---');

    for (var block in recipeBlocks) {
      if (block.trim().isEmpty) continue;

      final nameMatch = RegExp(r'RECIPE NAME:\s*(.+)', caseSensitive: false)
          .firstMatch(block);
      final ingredientsMatch = RegExp(
              r'INGREDIENTS:\s*(.+?)(?=INSTRUCTIONS:|$)',
              caseSensitive: false,
              dotAll: true)
          .firstMatch(block);
      final instructionsMatch = RegExp(r'INSTRUCTIONS:\s*(.+?)(?=PREP TIME:|$)',
              caseSensitive: false, dotAll: true)
          .firstMatch(block);
      final prepTimeMatch =
          RegExp(r'PREP TIME:\s*(.+)', caseSensitive: false).firstMatch(block);

      if (nameMatch != null) {
        recipes.add(Recipe(
          name: nameMatch.group(1)?.trim() ?? 'Unknown Recipe',
          ingredients: ingredientsMatch?.group(1)?.trim() ?? 'N/A',
          instructions: instructionsMatch?.group(1)?.trim() ?? 'N/A',
          prepTime: prepTimeMatch?.group(1)?.trim() ?? 'N/A',
        ));
      }
    }

    return recipes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filipino Recipe Finder'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          if (_isLoading)
            Container(
              color: Colors.black87,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.orange),
                    SizedBox(height: 20),
                    Text(
                      'Analyzing ingredients...\nFinding Filipino recipes...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _takePicture,
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class Recipe {
  final String name;
  final String ingredients;
  final String instructions;
  final String prepTime;

  Recipe({
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.prepTime,
  });
}

class RecipeResultScreen extends StatelessWidget {
  final String imagePath;
  final List<Recipe> recipes;

  const RecipeResultScreen({
    Key? key,
    required this.imagePath,
    required this.recipes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filipino Recipes'),
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(imagePath)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: recipes.isEmpty
                ? const Center(
                    child: Text(
                      'No recipes found.\nTry taking another photo with clearer ingredients.',
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return Card(
                        margin: const EdgeInsets.all(12),
                        elevation: 4,
                        child: ExpansionTile(
                          title: Text(
                            recipe.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            'Prep Time: ${recipe.prepTime}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Ingredients:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(recipe.ingredients),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Instructions:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(recipe.instructions),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
