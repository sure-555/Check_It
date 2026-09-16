import 'dart:io';
import 'package:flutter/foundation.dart';
import 'label_recognizer.dart';
import 'shape_recognizer.dart';
import 'label_type.dart';

class MockOcrRecognizer implements LabelRecognizer {
  final ShapeRecognizer _shapeRecognizer = ShapeRecognizer();

  @override
  Future<String> recognizeLabel(File image) async {
    final labelType = await _shapeRecognizer.recognizeShape(image);
    
    debugPrint('CHECKIT: $labelType - text length: ${getTextForType(labelType).length}');
    return getTextForType(labelType);
  }

  static String getTextForType(LabelType type) {
    switch (type) {
      case LabelType.alooBhujiya:
        return '''
Imported Product Tasty Potato Snacks
Net Weight : 250 oz
MRP: 120/-
MFG Date : 1 0 0 0 1
Best Before : 90 Days
Batch No. : B123
FSSAI No. : 0123456790
Address: MG Road, Vadodara
''';
      case LabelType.chickenFillet:
        return '''
Fresh Chicken Breast Fillet Combo Pack Product
Net Weight: 500 g
MRP: 190.00
MFG Date: 12/08/2024
Best Before: 4 Days
Batch Code: CHK123
FSSAI No. : 12345678901234
Farm Fresh Foods Product
Address: 45 Poultry Farm, Rural
''';
      case LabelType.medicineBottle:
        return '''
Net Content : 100 Tablets
Traceability Code: 12345
Address: 123 Health Street, City, 400001
Storage: Store in a cool dry place
''';
      case LabelType.unknown:
        return '';
    }
  }
}
