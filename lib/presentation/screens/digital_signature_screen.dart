import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/signature_provider.dart';
import '../../providers/auth_provider.dart';
import '../theme/stitch_theme.dart';

class SignaturePainter extends CustomPainter {
  final List<Offset?> points;

  SignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant SignaturePainter oldDelegate) {
    if (oldDelegate.points.length != points.length) return true;
    for (int i = 0; i < points.length; i++) {
      if (oldDelegate.points[i] != points[i]) return true;
    }
    return false;
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE7E5E4)
      ..strokeWidth = 1;
    const spacing = 20.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DigitalSignatureScreen extends StatefulWidget {
  const DigitalSignatureScreen({super.key});

  @override
  State<DigitalSignatureScreen> createState() => _DigitalSignatureScreenState();
}

class _DigitalSignatureScreenState extends State<DigitalSignatureScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SignatureProvider>().loadSignature();
    });
  }

  void _showPasswordDialogThenSave(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final signatureProvider = context.read<SignatureProvider>();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Verify Identity', style: TextStyle(fontFamily: 'Inter')),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Inspector Password',
              labelStyle: TextStyle(fontFamily: 'Inter'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontFamily: 'Inter')),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final input = passwordController.text;
                final bool isDemo123 = authProvider.inspectorId == 'INS-2026-001' && input == 'demo123';
                final bool isDemo456 = authProvider.inspectorId == 'INS-2026-002' && input == 'demo456';
                
                if (isDemo123 || isDemo456) {
                  await signatureProvider.saveSignature();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Signature saved successfully', style: TextStyle(fontFamily: 'Inter')),
                        backgroundColor: Color(0xFF059669),
                      ),
                    );
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Incorrect password', style: TextStyle(fontFamily: 'Inter')),
                        backgroundColor: Color(0xFFDC2626),
                      ),
                    );
                  }
                }
              },
              child: const Text('Verify & Save', style: TextStyle(color: Color(0xFF1C1917), fontFamily: 'Inter')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF9),
      appBar: AppBar(
        title: const Text('Digital Signature', style: TextStyle(color: Colors.white, fontFamily: 'Inter')),
        backgroundColor: const Color(0xFF1C1917),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 32,
              height: 280,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                border: Border.all(color: const Color(0xFFE7E5E4)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size.infinite,
                      painter: GridPainter(),
                    ),
                    Consumer<SignatureProvider>(
                      builder: (context, provider, child) {
                        return RepaintBoundary(
                          key: provider.signatureBoundaryKey,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onPanDown: (details) => provider.addPoint(details.localPosition),
                            onPanUpdate: (details) => provider.addPoint(details.localPosition),
                            onPanEnd: (_) => provider.addBreak(),
                            onPanCancel: () => provider.addBreak(),
                            child: CustomPaint(
                              size: Size.infinite,
                              painter: SignaturePainter(provider.points),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.read<SignatureProvider>().clear(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: const BorderSide(color: Color(0xFF1C1917)),
                      ),
                      child: const Text(
                        'Clear',
                        style: TextStyle(color: Color(0xFF1C1917), fontFamily: 'Inter'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showPasswordDialogThenSave(context),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                        backgroundColor: const Color(0xFF1C1917),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white, fontFamily: 'Inter'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Consumer<SignatureProvider>(
              builder: (context, provider, _) {
                if (provider.savedSignatureBytes == null) return const SizedBox.shrink();
                return Column(
                  children: [
                    const SizedBox(height: 32),
                    const Text(
                      'Preview Saved Signature',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C1917),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 120,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE7E5E4)),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          provider.savedSignatureBytes!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}
