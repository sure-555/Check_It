import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService {
  final TextRecognizer _recognizer = TextRecognizer();

  Future<String> extractText(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final result = await _recognizer.processImage(inputImage);
      final text = result.text;
      debugPrint('[LabelGuard:MLKit] Extracted text length: ${text.length}');
      debugPrint('[LabelGuard:MLKit] Text preview: ${text.substring(0, text.length > 200 ? 200 : text.length)}');
      return text;
    } catch (e) {
      debugPrint('[LabelGuard:MLKit] OCR Error: $e');
      return '';
    }
  }
}
