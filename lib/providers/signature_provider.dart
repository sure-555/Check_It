import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'dart:typed_data';

class SignatureProvider extends ChangeNotifier {
  List<Offset?> _points = [];
  List<Offset?> get points => List.unmodifiable(_points);

  final GlobalKey signatureBoundaryKey = GlobalKey();
  Uint8List? _savedSignatureBytes;

  Uint8List? get savedSignatureBytes => _savedSignatureBytes;
  bool get isEmpty => _points.isEmpty;
  int get pointCount => _points.length;

  void addPoint(Offset point) {
    _points = [..._points, point];
    notifyListeners();
  }

  void addBreak() {
    _points = [..._points, null];
    notifyListeners();
  }

  void clear() {
    _points = [];
    notifyListeners();
  }

  Future<void> saveSignature() async {
    try {
      final boundary = signatureBoundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) throw 'Canvas not ready';
      
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData != null) {
        final bytes = byteData.buffer.asUint8List();
        final box = Hive.box('profileBox');
        await box.put('inspector_signature', bytes);
        _savedSignatureBytes = bytes;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error saving signature: $e");
    }
  }

  Future<void> loadSignature() async {
    try {
      final box = Hive.box('profileBox');
      final bytes = box.get('inspector_signature');
      if (bytes != null && bytes is Uint8List) {
        _savedSignatureBytes = bytes;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading signature: $e");
    }
  }
}
