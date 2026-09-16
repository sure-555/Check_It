import 'dart:math';
import '../models/ocr_result.dart';

class SpatialMatcher {
  static OcrBlock? matchHorizontal(OcrBlock anchor, List<OcrBlock> allBlocks, {double maxDistanceY = 1.5}) {
    List<OcrBlock> candidates = [];
    double anchorHeight = anchor.bottom - anchor.top;

    for (var block in allBlocks) {
      if (block == anchor) continue;
      
      // Nearest block to the RIGHT
      if (block.left > anchor.right - (anchorHeight * 0.5)) { 
        // vertical center falls within anchor's vertical range, loosely
        if (block.centerY >= anchor.top - (anchorHeight * 0.5) && 
            block.centerY <= anchor.bottom + (anchorHeight * 0.5)) {
          candidates.add(block);
        }
      }
    }

    if (candidates.isEmpty) return null;

    candidates.sort((a, b) => (a.left - anchor.right).abs().compareTo((b.left - anchor.right).abs()));
    return candidates.first;
  }

  static OcrBlock? matchVertical(OcrBlock anchor, List<OcrBlock> allBlocks, {double maxDistanceY = 2.0}) {
    List<OcrBlock> candidates = [];
    double anchorHeight = anchor.bottom - anchor.top;

    for (var block in allBlocks) {
      if (block == anchor) continue;
      
      // Nearest block BELOW
      if (block.top >= anchor.bottom - (anchorHeight * 0.5) && 
          block.top <= anchor.bottom + (anchorHeight * maxDistanceY)) {
        // Horizontal center should somewhat align
        if (block.centerX >= anchor.left - anchorHeight && 
            block.centerX <= anchor.right + anchorHeight) {
          candidates.add(block);
        }
      }
    }

    if (candidates.isEmpty) return null;

    candidates.sort((a, b) => (a.top - anchor.bottom).abs().compareTo((b.top - anchor.bottom).abs()));
    return candidates.first;
  }

  static OcrBlock? findValue(OcrBlock anchor, List<OcrBlock> allBlocks) {
    // 1. Horizontal Pairing
    OcrBlock? result = matchHorizontal(anchor, allBlocks);
    
    // 2. Vertical Fallback
    if (result == null || (result.left - anchor.right) > (anchor.bottom - anchor.top) * 5) {
      OcrBlock? vertical = matchVertical(anchor, allBlocks);
      if (vertical != null) {
        result = vertical;
      }
    }

    // 3. Multi-line Values chaining (naive approach)
    if (result != null) {
      String text = result.text.trim();
      if (text.endsWith(':') || text.endsWith(',') || text.length < 3 || text == '-' || text == '.') {
        OcrBlock? nextResult = matchHorizontal(result, allBlocks) ?? matchVertical(result, allBlocks);
        if (nextResult != null) {
          // Merge blocks
          return OcrBlock(
            text: '${result.text} ${nextResult.text}',
            left: min(result.left, nextResult.left),
            top: min(result.top, nextResult.top),
            right: max(result.right, nextResult.right),
            bottom: max(result.bottom, nextResult.bottom),
          );
        }
      }
    }

    return result;
  }
}
