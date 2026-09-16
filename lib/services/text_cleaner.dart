class TextCleaner {
  static String clean(String rawText) {
    if (rawText.isEmpty) return rawText;

    final List<String> lines = rawText.split('\n');
    final List<String> cleanedLines = [];

    final urlRegex = RegExp(r'(http|https|www\.|udm=|\.com/|/images/)', caseSensitive: false);
    final htmlRegex = RegExp(r'<[^>]*>');
    final blocklist = [
      "Barcode Label Guru",
      "Billing Software Guru",
      "Ask Gemini",
      "Product Label Designs with Free Barcode"
    ];
    final keywords = [
      "Product", "MRP", "Net", "Weight", "Ingredients", "Batch", "Date", "Address", "Contact", 
      "FSSAI", "Price", "Content", "Storage", "Temp", "Degree", "Days", "GM", "g", "ml", "L", 
      "kg", "No.", "Code", "Email", "Phone", "Support"
    ];
    final keywordRegex = RegExp(keywords.join('|'), caseSensitive: false);

    for (var line in lines) {
      String trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      // Remove lines longer than 30 characters with NO spaces
      if (trimmed.length > 30 && !trimmed.contains(' ')) {
        continue;
      }

      // Remove URL patterns
      if (urlRegex.hasMatch(trimmed)) {
        continue;
      }

      // Remove watermark/header text
      bool hasBlocklist = false;
      for (var phrase in blocklist) {
        if (trimmed.toLowerCase().contains(phrase.toLowerCase())) {
          hasBlocklist = true;
          break;
        }
      }
      if (hasBlocklist) continue;

      // Remove HTML tags
      trimmed = trimmed.replaceAll(htmlRegex, '').trim();
      if (trimmed.isEmpty) continue;

      // Keep only lines that contain at least one recognizable label keyword
      if (keywordRegex.hasMatch(trimmed)) {
        cleanedLines.add(trimmed);
      }
    }

    return cleanedLines.join('\n');
  }
}
