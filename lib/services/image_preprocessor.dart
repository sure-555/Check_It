import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImagePreprocessor {
  static Future<String> preprocessImage(String imagePath, {bool highContrast = false, bool grayscaleDenoise = false}) async {
    final bytes = await File(imagePath).readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    if (image == null) return imagePath;

    // 1. Resize image to minimum 1500px on the shortest side (maintain aspect ratio)
    int shortestSide = image.width < image.height ? image.width : image.height;
    if (shortestSide < 1500) {
      if (image.width < image.height) {
        image = img.copyResize(image, width: 1500);
      } else {
        image = img.copyResize(image, height: 1500);
      }
    }

    // 2. Convert to grayscale
    image = img.grayscale(image);

    // 3 & 5. Contrast enhancement (+50%) and Brightness increase (+20%)
    image = img.adjustColor(image, contrast: 1.5, brightness: 1.2);

    // 4. Apply mild sharpening filter
    image = img.convolution(image, filter: [0, -1, 0, -1, 5, -1, 0, -1, 0]);

    // Save to temp file
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/preprocessed_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await tempFile.writeAsBytes(img.encodeJpg(image, quality: 90));
    
    return tempFile.path;
  }
}
