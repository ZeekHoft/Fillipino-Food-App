//models/detection_result.dart
import 'dart:ui';

class DetectionResult {
  final String label;
  final double confidence;
  final Rect boundingBox;
  final DateTime timestamp;

  static const double highConfidenceThreshold = 0.70;

  DetectionResult({
    required this.label,
    required this.confidence,
    required this.boundingBox,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  bool get isHighlyConfident => confidence >= highConfidenceThreshold;

  /// "87.3"
  String get confidencePercent => (confidence * 100).toStringAsFixed(1);

  double get width => boundingBox.width;
  double get height => boundingBox.height;
  double get area => width * height;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DetectionResult && other.label == label;

  @override
  int get hashCode => label.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'confidence': confidence,
      'left': boundingBox.left,
      'top': boundingBox.top,
      'right': boundingBox.right,
      'bottom': boundingBox.bottom,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory DetectionResult.fromMap(Map<String, dynamic> map) {
    return DetectionResult(
      label: map['label'] as String,
      confidence: (map['confidence'] as num).toDouble(),
      boundingBox: Rect.fromLTRB(
        (map['left'] as num).toDouble(),
        (map['top'] as num).toDouble(),
        (map['right'] as num).toDouble(),
        (map['bottom'] as num).toDouble(),
      ),
      timestamp: DateTime.tryParse(map['timestamp'] ?? ''),
    );
  }

  @override
  String toString() =>
      'DetectionResult(label: $label, confidence: ${confidencePercent}%)';
}
