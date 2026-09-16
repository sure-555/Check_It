import re
import os

def replace_in_file(filepath, old, new):
    if not os.path.exists(filepath): return
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    content = content.replace(old, new)
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

def regex_replace_in_file(filepath, pattern, new):
    if not os.path.exists(filepath): return
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    content = re.sub(pattern, new, content)
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

replace_in_file('lib/presentation/screens/history_screen.dart', '.withOpacity(', '.withValues(alpha: ')
replace_in_file('lib/presentation/screens/product_scanner_interface.dart', '.withOpacity(', '.withValues(alpha: ')

replace_in_file('lib/presentation/screens/profile_screen.dart', "import '../../providers/theme_provider.dart';\n", "")
replace_in_file('lib/presentation/screens/profile_screen.dart', "import 'compliance_rulebook_screen.dart';\n", "")
replace_in_file('lib/presentation/screens/profile_screen.dart', "import 'correct_vs_wrong_guide_screen.dart';\n", "")
replace_in_file('lib/presentation/screens/profile_screen.dart', "import 'voice_notes_screen.dart';\n", "")
replace_in_file('lib/presentation/screens/profile_screen.dart', '.withOpacity(', '.withValues(alpha: ')
regex_replace_in_file('lib/presentation/screens/profile_screen.dart', r"if \(trailingWidget != null\) trailingWidget,\s*if \(trailingText != null\)", "trailingWidget?,\n          if (trailingText != null)")

replace_in_file('lib/presentation/widgets/stitch_bottom_nav.dart', "import 'dart:ui';\n", "")

replace_in_file('lib/providers/scan_provider.dart', "import '../services/label_recognition/label_type.dart';\n", "")
replace_in_file('lib/providers/scan_provider.dart', "print(", "debugPrint(")
if os.path.exists('lib/providers/scan_provider.dart'):
    with open('lib/providers/scan_provider.dart', 'r', encoding='utf-8') as f:
        c = f.read()
        if "import 'package:flutter/foundation.dart';" not in c:
            c = "import 'package:flutter/foundation.dart';\n" + c
    with open('lib/providers/scan_provider.dart', 'w', encoding='utf-8') as f:
        f.write(c)


replace_in_file('lib/services/label_recognition/mlkit_text_recognizer.dart', "import '../text_cleaner.dart';\n", "")
regex_replace_in_file('lib/services/label_recognition/mlkit_text_recognizer.dart', r"double maxScore = 0;\s*", "")

replace_in_file('lib/services/label_recognition/shape_recognizer.dart', "print(", "debugPrint(")
if os.path.exists('lib/services/label_recognition/shape_recognizer.dart'):
    with open('lib/services/label_recognition/shape_recognizer.dart', 'r', encoding='utf-8') as f:
        c = f.read()
        if "import 'package:flutter/foundation.dart';" not in c:
            c = "import 'package:flutter/foundation.dart';\n" + c
    with open('lib/services/label_recognition/shape_recognizer.dart', 'w', encoding='utf-8') as f:
        f.write(c)

replace_in_file('lib/services/ocr_service.dart', "print(", "debugPrint(")
if os.path.exists('lib/services/ocr_service.dart'):
    with open('lib/services/ocr_service.dart', 'r', encoding='utf-8') as f:
        c = f.read()
        if "import 'package:flutter/foundation.dart';" not in c:
            c = "import 'package:flutter/foundation.dart';\n" + c
    with open('lib/services/ocr_service.dart', 'w', encoding='utf-8') as f:
        f.write(c)
