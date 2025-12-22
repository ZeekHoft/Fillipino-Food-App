// lib/pages/camera/ingredient_scanner_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flilipino_food_app/services/ingredient_detection_service.dart';
import 'package:flilipino_food_app/models/detection_result.dart';
import 'package:flilipino_food_app/pages/camera/ai_recipe_generator.dart';
import 'package:flilipino_food_app/pages/home_page/home_widgets/search_recipe.dart';

class IngredientScannerScreen extends StatefulWidget {
  const IngredientScannerScreen({super.key});

  @override
  State<IngredientScannerScreen> createState() =>
      _IngredientScannerScreenState();
}

class _IngredientScannerScreenState extends State<IngredientScannerScreen> {
  CameraController? _cameraController;
  late IngredientDetectionService _detectionService;

  List<DetectionResult> _detections = [];
  final Set<String> _selectedIngredients = {};

  bool _isCameraReady = false;
  bool _isProcessing = false;
  bool _isDisposed = false;

  String? _lastCapturedImagePath;
  bool _showingResults = false;
  Size? _capturedImageSize;

  @override
  void initState() {
    super.initState();
    _detectionService = IngredientDetectionService();
    _initializeDetectionService();
    _initializeCamera();
  }

  Future<void> _initializeDetectionService() async {
    await _detectionService.initialize();
    print(
        'Detection service initialized: ${_detectionService.isInitialized}');
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _showError('No camera found');
        return;
      }

      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();

      if (!mounted || _isDisposed) return;

      if (!_cameraController!.value.isInitialized) {
        throw Exception('Camera failed to initialize');
      }

      setState(() => _isCameraReady = true);

      print('Preview size: ${_cameraController!.value.previewSize}');
    } catch (e, stackTrace) {
      print('Camera initialization error: $e');
      print(stackTrace);
      if (mounted) {
        _showError('Failed to initialize camera: ${e.toString()}');
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Future<void> _captureAndDetect() async {
    if (!mounted ||
        _isDisposed ||
        _isProcessing ||
        !_detectionService.isInitialized ||
        _cameraController == null ||
        !_cameraController!.value.isInitialized) {
      return;
    }

    setState(() {
      _isProcessing = true;
      _showingResults = false;
    });

    try {
      final XFile imageFile = await _cameraController!.takePicture();
      print('Image captured: ${imageFile.path}');

      final imageBytes = await File(imageFile.path).readAsBytes();
      final decodedImage = await decodeImageFromList(imageBytes);
      final actualWidth = decodedImage.width.toDouble();
      final actualHeight = decodedImage.height.toDouble();

      print('Actual image size: ${actualWidth}x${actualHeight}');

      final rawResults =
          await _detectionService.detectFromImagePath(imageFile.path);

      if (!mounted || _isDisposed) {
        await File(imageFile.path).delete();
        return;
      }

      if (rawResults.isEmpty) {
        setState(() => _isProcessing = false);
        await File(imageFile.path).delete();
        _showError('No ingredients detected. Try again.');
        return;
      }

      print('Got ${rawResults.length} raw detections');

      final scaleX = actualWidth / 640.0;
      final scaleY = actualHeight / 640.0;

      final results = rawResults.map((DetectionResult r) {
        // Original bounding box from the model (normalized to 640x640)
        final box = r.boundingBox;

        // Scale bounding box to actual captured image size
        final scaledBox = Rect.fromLTRB(
          box.left * scaleX,
          box.top * scaleY,
          box.right * scaleX,
          box.bottom * scaleY,
        );

        // Return a new DetectionResult with the scaled bounding box
        return DetectionResult(
          label: r.label,
          confidence: r.confidence,
          boundingBox: scaledBox,
          timestamp: r.timestamp,
        );
      }).toList();

      results.sort((a, b) => b.confidence.compareTo(a.confidence));

      if (!mounted || _isDisposed) return;

      setState(() {
        _detections = results;
        _lastCapturedImagePath = imageFile.path;
        _capturedImageSize = Size(actualWidth, actualHeight);
        _isProcessing = false;
        _showingResults = true;
      });

      print('Detection complete: ${results.length} ingredients found');
    } catch (e, stackTrace) {
      print('Detection error: $e');
      print(stackTrace);
      if (mounted && !_isDisposed) {
        setState(() => _isProcessing = false);
        _showError('Detection failed. Try again.');
      }
    }
  }

  void _retakePhoto() {
    setState(() {
      _showingResults = false;
      _detections.clear();
      _capturedImageSize = null;
      if (_lastCapturedImagePath != null) {
        File(_lastCapturedImagePath!).delete().catchError((e) {
          print('Could not delete temp file: $e');
        });
        _lastCapturedImagePath = null;
      }
    });
  }

  void _addDetectedIngredients() {
    final newIngredients = <String>[];

    for (var detection in _detections) {
      if (detection.isHighlyConfident &&
          !_selectedIngredients.contains(detection.label)) {
        _selectedIngredients.add(detection.label);
        newIngredients.add(detection.label);
      }
    }

    if (newIngredients.isNotEmpty) {
      setState(() {});
      _showSuccess('Added ${newIngredients.length} ingredient(s)');
      _retakePhoto();
    } else if (_detections.isNotEmpty) {
      _showError('No new high-confidence ingredients to add');
    }
  }

  void _showActionDialog() {
    if (_selectedIngredients.isEmpty) {
      _showError('Please scan at least one ingredient');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Action'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You have ${_selectedIngredients.length} ingredient(s) scanned.',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _selectedIngredients.map((ingredient) {
                return Chip(
                  label: Text(ingredient),
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _navigateToSearch();
            },
            icon: const Icon(Icons.search),
            label: const Text('Search Recipes'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _navigateToAIGenerator();
            },
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Generate with AI'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAIGenerator() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AIRecipeGenerator(
          detectedIngredients: _selectedIngredients.toList(),
        ),
      ),
    );
  }

  void _navigateToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchRecipe(
          initialIngredients: _selectedIngredients.toList(),
        ),
      ),
    );
  }

  void _clearAllIngredients() {
    setState(() {
      _selectedIngredients.clear();
      _detections.clear();
    });
    _showSuccess('Cleared all ingredients');
  }

  @override
  void dispose() {
    _isDisposed = true;
    _cameraController?.dispose();
    _cameraController = null;
    _detectionService.dispose();

    if (_lastCapturedImagePath != null) {
      File(_lastCapturedImagePath!).delete().catchError((e) {
        print('Could not delete temp file: $e');
      });
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_showingResults && _lastCapturedImagePath != null)
            _buildResultsView()
          else if (_isCameraReady && _cameraController != null)
            _buildCameraView()
          else
            _buildLoadingView(),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Ingredient Scanner',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _showingResults
                              ? 'Review detections'
                              : 'Tap camera to scan',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomControls(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 16),
          const Text(
            'Initializing camera...',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraView() {
    return Stack(
      children: [
        Positioned.fill(
          child: CameraPreview(_cameraController!),
        ),
        if (_isProcessing)
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Card(
                color: Colors.black87,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.secondary,
                          strokeWidth: 3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Analyzing ingredients...',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildResultsView() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.file(
            File(_lastCapturedImagePath!),
            fit: BoxFit.contain,
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: DetectionPainter(
              _detections,
              _capturedImageSize!,
              Theme.of(context).colorScheme,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withValues(alpha: 0.9),
            Colors.black.withValues(alpha: 0.7),
            Colors.transparent,
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_showingResults && _detections.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Detected Ingredients',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ..._detections.map((detection) {
                      final isAlreadyAdded =
                          _selectedIngredients.contains(detection.label);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '${detection.label}: ${detection.confidencePercent}',
                                style: TextStyle(
                                  color: isAlreadyAdded
                                      ? Colors.white54
                                      : Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (isAlreadyAdded)
                              const Icon(Icons.check,
                                  size: 18, color: Colors.white54),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _retakePhoto,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Retake'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _addDetectedIngredients,
                      icon: const Icon(Icons.add_circle),
                      label: const Text('Add Ingredients'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onSecondary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            if (_selectedIngredients.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.kitchen,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Collected (${_selectedIngredients.length})',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.clear_all, size: 18),
                          color: Theme.of(context).colorScheme.error,
                          onPressed: _clearAllIngredients,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: _selectedIngredients.map((ingredient) {
                        return Chip(
                          label: Text(
                            ingredient,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          deleteIcon: Icon(
                            Icons.close,
                            size: 16,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                          onDeleted: () => setState(() {
                            _selectedIngredients.remove(ingredient);
                          }),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showActionDialog,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Continue'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
            if (!_showingResults) ...[
              const SizedBox(height: 12),
              Center(
                child: FloatingActionButton.large(
                  onPressed: _isProcessing ? null : _captureAndDetect,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  elevation: 8,
                  child: Icon(
                    Icons.camera_alt,
                    size: 32,
                    color: _isProcessing
                        ? Colors.grey
                        : Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class DetectionPainter extends CustomPainter {
  final List<DetectionResult> detections;
  final Size imageSize;
  final ColorScheme colorScheme;

  DetectionPainter(this.detections, this.imageSize, this.colorScheme);

  @override
  void paint(Canvas canvas, Size size) {
    final imageAspect = imageSize.width / imageSize.height;
    final displayAspect = size.width / size.height;

    double scale;
    double offsetX = 0;
    double offsetY = 0;

    if (imageAspect > displayAspect) {
      scale = size.width / imageSize.width;
      final scaledHeight = imageSize.height * scale;
      offsetY = (size.height - scaledHeight) / 2;
    } else {
      scale = size.height / imageSize.height;
      final scaledWidth = imageSize.width * scale;
      offsetX = (size.width - scaledWidth) / 2;
    }

    for (var detection in detections) {
      final box = detection.boundingBox;

      final displayBox = Rect.fromLTRB(
        box.left * scale + offsetX,
        box.top * scale + offsetY,
        box.right * scale + offsetX,
        box.bottom * scale + offsetY,
      );

      final boxPaint = Paint()
        ..color = colorScheme.secondary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;
      canvas.drawRect(displayBox, boxPaint);

      final textSpan = TextSpan(
        text: '${detection.label} ${detection.confidencePercent}',
        style: TextStyle(
          color: colorScheme.onSecondary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final labelBgRect = Rect.fromLTWH(
        displayBox.left,
        displayBox.top - 26,
        textPainter.width + 12,
        26,
      );

      final bgPaint = Paint()..color = colorScheme.secondary;
      canvas.drawRect(labelBgRect, bgPaint);
      textPainter.paint(
          canvas, Offset(displayBox.left + 6, displayBox.top - 24));
    }
  }

  @override
  bool shouldRepaint(DetectionPainter oldDelegate) =>
      detections != oldDelegate.detections ||
      imageSize != oldDelegate.imageSize;
}
