import 'dart:io';
import '../ocr_service.dart';
import 'label_recognizer.dart';

class MlKitTextRecognizer implements LabelRecognizer {
  final OcrService _ocrService = OcrService();

  @override
  Future<String> recognizeLabel(File image) async {
    // 1. Call OcrService to get OCR text
    final rawText = await _ocrService.extractText(image);

    // 2. Add a 1.5-second artificial delay to simulate AI processing
    await Future.delayed(const Duration(milliseconds: 1500));

    return rawText;
  }
}
