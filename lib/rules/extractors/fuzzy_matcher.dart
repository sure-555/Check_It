class FuzzyMatcher {
  static final Map<String, List<String>> _dictionary = {
    "MRP": ["mrp", "m.r.p", "mrp:", "mrp.", "mrp-", "mrp..", "m-r-p", "एम.आर.पी."],
    "Net Weight": ["net weight", "net wt", "net wt.", "netwt", "net wt :", "वजन", "मात्रा", "quantity", "net quantity"],
    "FSSAI": ["fssai", "fssai no", "fssai:", "fssai no."],
    "Batch": ["batch", "batch no", "batch:", "b.no", "b.no.", "lot"],
    "MFG": ["mfg", "mfg date", "manufacturing date", "mfg. date", "packed on", "तिथि", "mfd"],
    "Best Before": ["best before", "best before:", "use by", "use by:", "expiry", "exp date", "consume before"],
    "Ingredients": ["ingredients", "contains", "composition", "सामग्री"]
  };

  static String _normalize(String input) {
    return input.replaceAll(RegExp(r'[^\p{L}\p{N}]', unicode: true), '').toLowerCase();
  }

  static int _levenshtein(String s, String t) {
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    List<int> v0 = List<int>.filled(t.length + 1, 0);
    List<int> v1 = List<int>.filled(t.length + 1, 0);

    for (int i = 0; i <= t.length; i++) {
      v0[i] = i;
    }

    for (int i = 0; i < s.length; i++) {
      v1[0] = i + 1;
      for (int j = 0; j < t.length; j++) {
        int cost = (s[i] == t[j]) ? 0 : 1;
        v1[j + 1] = [v1[j] + 1, v0[j + 1] + 1, v0[j] + cost].reduce((a, b) => a < b ? a : b);
      }
      for (int j = 0; j <= t.length; j++) {
        v0[j] = v1[j];
      }
    }

    return v0[t.length];
  }

  static bool isMatch(String keyword, String text) {
    String normalizedText = _normalize(text);
    if (normalizedText.isEmpty) return false;

    List<String> variants = _dictionary[keyword] ?? [keyword.toLowerCase()];

    for (String variant in variants) {
      String normVariant = _normalize(variant);
      if (normVariant.isEmpty) continue;

      if (normalizedText.contains(normVariant)) return true;

      // Check edit distance for words in text that are similar length
      List<String> words = text.split(RegExp(r'\s+'));
      for (String word in words) {
        String normWord = _normalize(word);
        if (normWord.length >= 3 && normVariant.length >= 3) {
          int dist = _levenshtein(normWord, normVariant);
          if (dist <= 2) return true;
        }
      }
    }
    return false;
  }

  static bool containsAnyFoodTerm(String text) {
    final foodTerms = ['edible', 'oil', 'sugar', 'salt', 'masala', 'powder', 'fssai', 'food', 'snack'];
    String normText = text.toLowerCase();
    for (String term in foodTerms) {
      if (normText.contains(term)) return true;
    }
    return false;
  }
}
