class OcrBlock {
  final String text;
  final double left;
  final double top;
  final double right;
  final double bottom;
  final double centerX;
  final double centerY;

  OcrBlock({
    required this.text,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  })  : centerX = (left + right) / 2,
        centerY = (top + bottom) / 2;
}

class OcrResult {
  final String rawText;
  final List<OcrBlock> blocks;
  final String? error;

  OcrResult({required this.rawText, required this.blocks, this.error});
}
