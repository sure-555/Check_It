import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'label_type.dart';

class ShapeRecognizer {
  Future<LabelType> recognizeShape(File image) async {
    final bytes = await image.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final width = frame.image.width.toDouble();
    final height = frame.image.height.toDouble();
    final ratio = width / height;
    
    debugPrint('[LabelGuard:Shape] Image ratio: ${ratio.toStringAsFixed(2)} (${width.toInt()}x${height.toInt()})');
    
    // Aloo Bhujiya = wide landscape label
    if (ratio > 1.15) return LabelType.alooBhujiya;
    
    // Medicine Bottle = tall portrait
    if (ratio < 0.85) return LabelType.medicineBottle;
    
    // Chicken Fillet = square-ish (everything else)
    return LabelType.chickenFillet;
  }
}
