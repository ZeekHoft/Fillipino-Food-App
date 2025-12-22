// lib/services/ingredient_detection_service.dart
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:camera/camera.dart';

import '../models/detection_result.dart';

class IngredientDetectionService {
  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  // INITIALIZATION
  Future<void> initialize() async {
    try {
      // Load YOLOv8 TFLite model
      _interpreter = await Interpreter.fromAsset(
        'assets/models/filipino_ingredients.tflite',
        options: InterpreterOptions()..threads = 2,
      );

      // Load class labels
      final labelData = await rootBundle.loadString('assets/labels/labels.txt');
      _labels =
          labelData.split('\n').where((l) => l.trim().isNotEmpty).toList();

      _isInitialized = true;

      print('IngredientDetectionService initialized successfully.');
      print('Loaded ${_labels.length} labels.');
      print('Model input shape: ${_interpreter!.getInputTensor(0).shape}');
      print('Model output shape: ${_interpreter!.getOutputTensor(0).shape}');
      print('Input tensor type: ${_interpreter!.getInputTensor(0).type}');
    } catch (e, stack) {
      print('Initialization failed: $e');
      print(stack);
    }
  }

  // DETECT FROM IMAGE FILE PATH
  Future<List<DetectionResult>> detectFromImagePath(String imagePath) async {
    if (!_isInitialized || _interpreter == null) return [];

    try {
      final imageFile = File(imagePath);
      final bytes = await imageFile.readAsBytes();

      img.Image? image;
      try {
        image = img.decodeImage(bytes);
      } catch (e) {
        print('Failed to decode with default decoder, trying JPEG decoder: $e');
        image = img.decodeJpg(bytes);
      }

      if (image == null) {
        print('Failed to decode image from path: $imagePath');
        return [];
      }

      print('Image decoded: ${image.width}x${image.height}');
      return await _detectFromImage(image);
    } catch (e, stack) {
      print('Detection from path error: $e');
      print(stack);
      return [];
    }
  }

  // DETECTION FROM CAMERA IMAGE
  Future<List<DetectionResult>> detectFromCameraImage(
      CameraImage cameraImage) async {
    if (!_isInitialized || _interpreter == null) return [];

    try {
      final rgbImage = _convertYUV420toImage(cameraImage);
      return await _detectFromImage(rgbImage);
    } catch (e, stack) {
      print('Detection from camera error: $e');
      print(stack);
      return [];
    }
  }

  // CORE DETECTION LOGIC
  Future<List<DetectionResult>> _detectFromImage(img.Image image) async {
    try {
      // Resize to 640x640 (model input size)
      final resized = img.copyResize(image, width: 640, height: 640);

      // Normalize to [0, 1] for float32 model input
      final input = List.generate(
        1,
        (_) => List.generate(
          640,
          (y) => List.generate(
            640,
            (x) {
              final pixel = resized.getPixel(x, y);
              final r = pixel.r.toDouble() / 255.0;
              final g = pixel.g.toDouble() / 255.0;
              final b = pixel.b.toDouble() / 255.0;
              return [r, g, b];
            },
          ),
        ),
      );

      // Output buffer
      final outputShape = _interpreter!.getOutputTensor(0).shape;
      final totalSize = outputShape.reduce((a, b) => a * b);
      final output = List<double>.filled(totalSize, 0).reshape(outputShape);

      // Run inference
      _interpreter!.run(input, output);

      // Scale factors (MODEL → IMAGE)
      final double scaleX = image.width / 640;
      final double scaleY = image.height / 640;

      // Parse detections
      final parsed = _parseDetections(output[0], scaleX, scaleY);

      print('Got ${parsed.length} detections');
      if (parsed.isNotEmpty) {
        print('Sample detections: ${parsed.take(3).toList()}');
      }

      return parsed;
    } catch (e, stack) {
      print('Detection error: $e');
      print(stack);
      return [];
    }
  }

  // PARSE DETECTIONS (YOLOV8 FORMAT)
  List<DetectionResult> _parseDetections(
    List<dynamic> rawOutput,
    double scaleX,
    double scaleY,
  ) {
    const double confThreshold = 0.60;
    final List<DetectionResult> detections = [];

    final int numPredictions = rawOutput[0].length;
    final int numClasses = rawOutput.length - 4;

    print(
        'DEBUG: Processing $numPredictions predictions with $numClasses classes');

    for (int i = 0; i < numPredictions; i++) {
      final double xCenter = rawOutput[0][i].toDouble();
      final double yCenter = rawOutput[1][i].toDouble();
      final double width = rawOutput[2][i].toDouble();
      final double height = rawOutput[3][i].toDouble();

      double maxConf = 0.0;
      int bestClass = 0;

      for (int c = 0; c < numClasses; c++) {
        final double classProb = rawOutput[4 + c][i].toDouble();
        if (classProb > maxConf) {
          maxConf = classProb;
          bestClass = c;
        }
      }

      if (maxConf < confThreshold) continue;

      final double x1 = (xCenter - width / 2) * scaleX;
      final double y1 = (yCenter - height / 2) * scaleY;
      final double x2 = (xCenter + width / 2) * scaleX;
      final double y2 = (yCenter + height / 2) * scaleY;

      final String label =
          bestClass < _labels.length ? _labels[bestClass] : 'unknown';

      detections.add(
        DetectionResult(
          label: label,
          confidence: maxConf,
          boundingBox: Rect.fromLTRB(x1, y1, x2, y2),
        ),
      );
    }

    print(
        'Found ${detections.length} detections above ${(confThreshold * 100).toStringAsFixed(0)}% confidence');

    return _applyNMS(detections, 0.55);
  }

  // NON-MAXIMUM SUPPRESSION
  List<DetectionResult> _applyNMS(
    List<DetectionResult> detections,
    double iouThreshold,
  ) {
    if (detections.isEmpty) return [];

    detections.sort((a, b) => b.confidence.compareTo(a.confidence));

    final List<DetectionResult> keep = [];
    final List<bool> suppressed = List.filled(detections.length, false);

    for (int i = 0; i < detections.length; i++) {
      if (suppressed[i]) continue;

      keep.add(detections[i]);
      final a = detections[i].boundingBox;

      for (int j = i + 1; j < detections.length; j++) {
        if (suppressed[j]) continue;

        final b = detections[j].boundingBox;
        final iou = _calculateIoU(a, b);

        if (iou > iouThreshold) {
          suppressed[j] = true;
        }
      }
    }

    print('NMS: ${detections.length} → ${keep.length} detections');
    return keep;
  }

  // INTERSECTION OVER UNION
  double _calculateIoU(Rect a, Rect b) {
    final double x1 = max(a.left, b.left);
    final double y1 = max(a.top, b.top);
    final double x2 = min(a.right, b.right);
    final double y2 = min(a.bottom, b.bottom);

    if (x2 < x1 || y2 < y1) return 0.0;

    final double intersection = (x2 - x1) * (y2 - y1);
    final double union = a.width * a.height + b.width * b.height - intersection;

    return intersection / union;
  }

  // YUV → RGB
  img.Image _convertYUV420toImage(CameraImage image) {
    final width = image.width;
    final height = image.height;
    final imgImage = img.Image(width: width, height: height);

    final Y = image.planes[0].bytes;
    final U = image.planes[1].bytes;
    final V = image.planes[2].bytes;
    final strideY = image.planes[0].bytesPerRow;
    final strideU = image.planes[1].bytesPerRow;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final yp = y * strideY + x;
        final uvIndex = (y ~/ 2) * strideU + (x ~/ 2);

        final Yval = Y[yp];
        final Uval = U[uvIndex];
        final Vval = V[uvIndex];

        final r = (Yval + 1.402 * (Vval - 128)).clamp(0, 255).toInt();
        final g = (Yval - 0.344136 * (Uval - 128) - 0.714136 * (Vval - 128))
            .clamp(0, 255)
            .toInt();
        final b = (Yval + 1.772 * (Uval - 128)).clamp(0, 255).toInt();

        imgImage.setPixelRgb(x, y, r, g, b);
      }
    }

    return imgImage;
  }

  // CLEANUP
  void dispose() {
    _interpreter?.close();
    _isInitialized = false;
    print('IngredientDetectionService disposed');
  }
}
