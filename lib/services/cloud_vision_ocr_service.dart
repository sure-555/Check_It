import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';
import '../config/api_keys.dart';

class CloudVisionOcrService {
  static final String _apiUrl = 
    'https://vision.googleapis.com/v1/images:annotate?key=${ApiKeys.googleCloudVisionApiKey}';

  Future<String> extractText(String imagePath) async {
    try {
      File file = File(imagePath);
      final imageBytes = await file.readAsBytes();
      List<int> bytes;

      img.Image? image = img.decodeImage(imageBytes);
      if (image != null) {
        if (image.width > 1024) {
          image = img.copyResize(image, width: 1024);
        }
        bytes = img.encodeJpg(image, quality: 85);
      } else {
        bytes = imageBytes;
      }

      final base64Image = base64Encode(bytes);

      final requestBody = {
        "requests": [
          {
            "image": {
              "content": base64Image
            },
            "features": [
              {
                "type": "TEXT_DETECTION",
                "maxResults": 1
              }
            ]
          }
        ]
      };

      debugPrint("API Key: ${ApiKeys.googleCloudVisionApiKey.substring(0, 10)}...");
      debugPrint("Image size: ${bytes.length} bytes");

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      ).timeout(const Duration(seconds: 15));

      debugPrint("Status: ${response.statusCode}");
      debugPrint("Body: ${response.body.length > 100 ? response.body.substring(0, 100) : response.body}");

      if (response.statusCode == 403) {
        return "ERROR: API key invalid. Go to console.cloud.google.com -> APIs & Services -> Credentials -> verify your key.";
      }
      if (response.statusCode == 400) {
        return "ERROR: Bad request. Check JSON format in cloud_vision_ocr_service.dart.";
      }
      if (response.statusCode == 0) {
        return "ERROR: No internet. Enable mobile data or WiFi.";
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final responses = data['responses'] as List<dynamic>?;
        
        if (responses != null && responses.isNotEmpty) {
          final firstResponse = responses[0] as Map<String, dynamic>?;
          if (firstResponse != null && firstResponse.containsKey('textAnnotations')) {
            final textAnnotations = firstResponse['textAnnotations'] as List<dynamic>?;
            if (textAnnotations != null && textAnnotations.isNotEmpty) {
              final fullText = textAnnotations[0]['description']?.toString() ?? '';
              return fullText.trim();
            }
          }
        }
        return 'ERROR: No text found in image. Try a clearer photo.';
      } else {
        return 'ERROR: API returned ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      if (e is SocketException) {
        return "ERROR: No internet. Enable mobile data or WiFi.";
      }
      return 'ERROR: ${e.toString()}';
    }
  }
}
