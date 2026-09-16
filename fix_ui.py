import re

def insert_before_nav_home(filepath, new_line):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    content = re.sub(r'(\s*"navHome":)', f'\n  {new_line},\\1', content)
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

insert_before_nav_home('lib/l10n/app_en.arb', '\"analysisReportTitle\": \"Analysis Report\"')
insert_before_nav_home('lib/l10n/app_hi.arb', '\"analysisReportTitle\": \"???????? ???????\"')
insert_before_nav_home('lib/l10n/app_ta.arb', '\"analysisReportTitle\": \"??????????? ???????\"')

with open('lib/l10n/app_ta.arb', 'r', encoding='utf-8') as f:
    ta = f.read()
ta = ta.replace('\"dashInspectorDashboard\": \"???????? ??????????\",', '\"dashInspectorDashboard\": \"???????\",')
ta = ta.replace('\"profileTitle\": \"???????? ?????????\",', '\"profileTitle\": \"?????????\",')
with open('lib/l10n/app_ta.arb', 'w', encoding='utf-8') as f:
    f.write(ta)

with open('lib/presentation/screens/compliance_result_analysis.dart', 'r', encoding='utf-8') as f:
    cra = f.read()
cra = cra.replace(\"const Text('Analysis Report')\", \"Text(AppLocalizations.of(context)!.analysisReportTitle)\")
cra = cra.replace(\"'Analysis Report'\", \"AppLocalizations.of(context)!.analysisReportTitle\")
if 'app_localizations.dart' not in cra:
    cra = cra.replace(\"import 'package:flutter/material.dart';\", \"import 'package:flutter/material.dart';\\nimport 'package:label_guard/l10n/app_localizations.dart';\")
with open('lib/presentation/screens/compliance_result_analysis.dart', 'w', encoding='utf-8') as f:
    f.write(cra)

with open('lib/presentation/widgets/stitch_bottom_nav.dart', 'r', encoding='utf-8') as f:
    sbn = f.read()

nav_item_old = \"\"\"    return GestureDetector(
      onTap: () => onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        height: 64,\"\"\"
nav_item_new = \"\"\"    return Expanded(
      child: GestureDetector(
        onTap: () => onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: 64,\"\"\"
sbn = sbn.replace(nav_item_old, nav_item_new)

text_old = \"\"\"              Text(
                label,
                style: StitchTheme.labelMd.copyWith( // Fallback if google_fonts isn't imported, but wait, I can just use TextStyle since Inter is standard in StitchTheme
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),\"\"\"
text_new = \"\"\"              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: StitchTheme.labelMd.copyWith(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),\"\"\"
sbn = sbn.replace(text_old, text_new)
with open('lib/presentation/widgets/stitch_bottom_nav.dart', 'w', encoding='utf-8') as f:
    f.write(sbn)
