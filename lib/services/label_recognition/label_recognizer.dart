import 'dart:io';

abstract class LabelRecognizer {
  Future<String> recognizeLabel(File image);
}
