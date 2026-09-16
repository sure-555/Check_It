import 'package:url_launcher/url_launcher.dart';
import '../models/scan_result.dart';

class ComplaintService {
  static const String _nchWhatsApp = "+918800001915";
  static const String _nchPortalUrl = "https://consumerhelpline.gov.in/";

  Future<void> submitViaWhatsApp(ScanResult result) async {
    final message = _formatComplaintMessage(result);
    final url = Uri.parse("whatsapp://send?phone=$_nchWhatsApp&text=${Uri.encodeComponent(message)}");
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // Fallback to web WhatsApp or portal
      final webUrl = Uri.parse("https://wa.me/$_nchWhatsApp?text=${Uri.encodeComponent(message)}");
      if (await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl);
      } else {
        throw Exception('Could not launch WhatsApp');
      }
    }
  }

  Future<void> submitViaPortal() async {
    final url = Uri.parse(_nchPortalUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw Exception('Could not launch NCH Portal');
    }
  }

  String _formatComplaintMessage(ScanResult result) {
    final buffer = StringBuffer();
    buffer.writeln("*Legal Metrology Violation Complaint*");
    buffer.writeln("Product: ${result.productName}");
    buffer.writeln("Brand: ${result.brand}");
    buffer.writeln("Location: ${result.location}");
    buffer.writeln("Date: ${result.scanDate.toIso8601String().split('T')[0]}");
    buffer.writeln("");
    buffer.writeln("*Violations Found:*");
    
    for (var violation in result.violations.where((v) => v.status == 'FAIL')) {
      buffer.writeln("- ${violation.ruleName}");
      buffer.writeln("  (${violation.description})");
    }
    
    return buffer.toString();
  }
}
