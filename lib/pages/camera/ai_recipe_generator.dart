// lib/pages/camera/ai_recipe_generator.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AIRecipeGenerator extends StatefulWidget {
  final List<String> detectedIngredients;

  const AIRecipeGenerator({
    super.key,
    required this.detectedIngredients,
  });

  @override
  State<AIRecipeGenerator> createState() => _AIRecipeGeneratorState();
}

class _AIRecipeGeneratorState extends State<AIRecipeGenerator> {
  late final String _chatGptApiKey;

  String? _recipeName;
  List<String>? _ingredientsList;
  List<String>? _instructions;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _chatGptApiKey = dotenv.env["OPENAI_API_KEY"]!;
    print('API Key loaded: ${_chatGptApiKey.substring(0, 10)}...');
    print('API Key length: ${_chatGptApiKey.length}');

    // Automatically generate recipe when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateRecipeFromIngredients();
    });
  }

  Future<void> _generateRecipeFromIngredients() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _recipeName = null;
      _ingredientsList = null;
      _instructions = null;
    });

    try {
      // Convert ingredients list to comma-separated string
      final ingredientsString = widget.detectedIngredients.join(', ');

      // Generate recipe text using ChatGPT Text API
      final Map<String, dynamic>? recipeData =
          await _generateRecipeText(ingredientsString);

      if (recipeData != null) {
        setState(() {
          _recipeName = recipeData['recipeName'];
          _ingredientsList = List<String>.from(recipeData['ingredientsList']);
          _instructions = List<String>.from(recipeData['instructions']);
        });
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
          "model": "gpt-4o",
          "messages": [
            {
              "role": "system",
              "content":
                  "You are a helpful assistant that generates Filipino recipes. Your output must be a JSON object."
            },
            {
              "role": "user",
              "content":
                  "Based on these ingredients: $ingredients, generate a Filipino recipe. Provide the recipe name, a list of ingredients with quantities, and step-by-step instructions. Format the response as a JSON object with keys: 'recipeName' (string), 'ingredientsList' (array of strings), 'instructions' (array of strings)."
            }
          ],
          "response_format": {"type": "json_object"},
          "max_tokens": 1000,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final String jsonString =
            jsonResponse['choices'][0]['message']['content'];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('AI Recipe Generator'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Display detected ingredients
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.kitchen,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Detected Ingredients',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.detectedIngredients.map((ingredient) {
                        return Chip(
                          label: Text(ingredient),
                          backgroundColor:
                              Theme.of(context).colorScheme.secondaryContainer,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Loading indicator
            if (_isLoading)
              Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Generating recipe with AI...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),

            // Error message display
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            // Display recipe name
            if (_recipeName != null)
              Text(
                _recipeName!,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 20),

            // Display ingredients list
            if (_ingredientsList != null && _ingredientsList!.isNotEmpty)
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ingredients:',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _ingredientsList!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _ingredientsList![index],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),

            // Display instructions
            if (_instructions != null && _instructions!.isNotEmpty)
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Instructions:',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _instructions!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _instructions![index],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

            // Retry button
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton.icon(
                  onPressed: _generateRecipeFromIngredients,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
