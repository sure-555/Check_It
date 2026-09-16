import 'dart:io';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../theme/stitch_theme.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

import '../../main.dart';
import 'package:provider/provider.dart';
import '../../providers/scan_provider.dart';
import 'package:label_guard/l10n/app_localizations.dart';

enum ScannerState {
  searching,
  detecting,
  holding,
  previewing,
  analyzing,
}

class ProductScannerInterface extends StatefulWidget {
  const ProductScannerInterface({super.key});

  @override
  State<ProductScannerInterface> createState() => _ProductScannerInterfaceState();
}

class _ProductScannerInterfaceState extends State<ProductScannerInterface>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanAnimationController;
  CameraController? _cameraController;

  final List<String?> _capturedAngles = List.filled(3, null);
  int _currentAngleIndex = 0;
  int _selectedCameraIndex = 0;
  
  // Simulation & State
  ScannerState _currentState = ScannerState.searching;
  Timer? _simulationTimer;
  Timer? _previewTimer;
  String? _previewImagePath;
  final FocusNode _focusNode = FocusNode();
  static const MethodChannel _volumeChannel = MethodChannel('com.labelguard/volume');

  void _toggleCamera() {
    if (cameras.length > 1) {
      setState(() {
        _selectedCameraIndex = (_selectedCameraIndex + 1) % cameras.length;
      });
      _initializeCamera();
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    HardwareKeyboard.instance.addHandler(_handleHardwareKey);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ScanProvider>().fetchLocation();
      }
    });
    
    _volumeChannel.setMethodCallHandler((call) async {
      if (call.method == 'volumeDown') {
        if (_currentState == ScannerState.holding || 
            _currentState == ScannerState.detecting || 
            _currentState == ScannerState.searching) {
          _captureFrame();
        }
      }
    });

    _scanAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    
    _initializeCamera().then((_) {
      _startSimulation();
    });
  }

  Future<void> _initializeCamera() async {
    if (cameras.isEmpty) return;
    
    _cameraController = CameraController(
      cameras[_selectedCameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );
    
    try {
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint("Camera initialization error: $e");
    }
  }

  void _startSimulation() {
    if (_allCaptured) return;
    
    _simulationTimer?.cancel();
    if (mounted) {
      setState(() {
        _currentState = ScannerState.searching;
      });
    }
    
    _simulationTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted || _currentState != ScannerState.searching) return;
      setState(() {
        _currentState = ScannerState.detecting;
      });
      
      _simulationTimer = Timer(const Duration(seconds: 1), () {
        if (!mounted || _currentState != ScannerState.detecting) return;
        setState(() {
          _currentState = ScannerState.holding;
        });
      });
    });
  }

  bool _handleHardwareKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown || 
          event.logicalKey == LogicalKeyboardKey.audioVolumeDown) {
        if (_currentState == ScannerState.holding || 
            _currentState == ScannerState.detecting || 
            _currentState == ScannerState.searching) {
          _captureFrame();
          return true;
        }
      }
    }
    return false;
  }

  Future<void> _captureFrame() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    
    try {
      _simulationTimer?.cancel();
      final image = await _cameraController!.takePicture();
      if (!mounted) return;
      
      setState(() {
        _previewImagePath = image.path;
        _currentState = ScannerState.previewing;
      });
      
      _previewTimer = Timer(const Duration(seconds: 3), () {
        _confirmPreview();
      });
    } catch (e) {
      debugPrint("Failed to take picture: $e");
    }
  }

  void _confirmPreview() {
    if (!mounted) return;
    _previewTimer?.cancel();
    setState(() {
      _capturedAngles[_currentAngleIndex] = _previewImagePath;
      _previewImagePath = null;
      if (_currentAngleIndex < 2) {
        _currentAngleIndex++;
        _startSimulation();
      } else {
        _currentState = ScannerState.analyzing;
      }
    });
  }

  void _retakePreview() {
    _previewTimer?.cancel();
    setState(() {
      _previewImagePath = null;
      _startSimulation();
    });
  }

  @override
  void dispose() {
    _volumeChannel.setMethodCallHandler(null);
    HardwareKeyboard.instance.removeHandler(_handleHardwareKey);
    _focusNode.dispose();
    _simulationTimer?.cancel();
    _previewTimer?.cancel();
    _scanAnimationController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _analyze() async {
    if (!_allCaptured) return;
    final scanProvider = context.read<ScanProvider>();
    await scanProvider.analyzeLabel(File(_capturedAngles[0]!), context);
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null && mounted) {
      setState(() {
        _capturedAngles[_currentAngleIndex] = image.path;
        if (_currentAngleIndex < 2) {
          _currentAngleIndex++;
          _startSimulation();
        } else {
          _currentState = ScannerState.analyzing;
        }
      });
    }
  }

  bool get _allCaptured => _capturedAngles.every((path) => path != null);

  String _getScanInstruction(BuildContext context, int index) {
    final l10n = AppLocalizations.of(context)!;
    if (index == 0) return l10n.scanInstructionFront;
    if (index == 1) return l10n.scanInstructionLeft;
    if (index == 2) return l10n.scanInstructionRight;
    return "";
  }

  String _getAngleName(BuildContext context, int index) {
    final l10n = AppLocalizations.of(context)!;
    if (index == 0) return l10n.scanSideFront;
    if (index == 1) return l10n.scanSideLeft;
    if (index == 2) return l10n.scanSideRight;
    return "";
  }

  Widget _buildAngleIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(3, (index) {
        bool isCompleted = _capturedAngles[index] != null;
        bool isActive = index == _currentAngleIndex;
        
        return Opacity(
          opacity: (isActive || isCompleted) ? 1.0 : 0.5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted 
                      ? StitchTheme.secondary 
                      : (isActive ? StitchTheme.secondary.withValues(alpha: 0.2) : Colors.transparent),
                  border: Border.all(
                    color: isCompleted || isActive ? StitchTheme.secondary : Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: isCompleted
                    ? const Icon(Icons.check, color: Color(0xFF1C1917), size: 24)
                    : Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: StitchTheme.onPrimary,
                          height: 1.0,
                        ),
                      ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _getAngleName(context, index),
                style: StitchTheme.labelMd.copyWith(
                  color: StitchTheme.onPrimary,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDynamicStatusText(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String text = "";
    Color color = Colors.white54;
    
    if (_currentState == ScannerState.detecting) {
      text = l10n.scanStatusLabelDetected;
      color = Colors.white;
    } else if (_currentState == ScannerState.holding) {
      text = l10n.scanStatusHoldSteady;
      color = StitchTheme.secondary;
    } else if (_currentState == ScannerState.searching) {
      text = l10n.scanStatusSearching;
      color = Colors.white54;
    }
    
    return SizedBox(
      width: 140,
      height: 48,
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            text,
            key: ValueKey(text),
            style: StitchTheme.titleMd.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scanProvider = context.watch<ScanProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF1C1917),
      body: Stack(
        children: [
          // Background Camera Feed
          Positioned.fill(
            child: _cameraController != null && _cameraController!.value.isInitialized
                ? CameraPreview(_cameraController!)
                : Container(color: const Color(0xFF1C1917)),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.transparent,
                    const Color(0xFF1C1917).withValues(alpha: 0.6),
                  ],
                  radius: 1.5,
                  center: Alignment.center,
                ),
              ),
            ),
          ),
  
            // Top App Bar
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: StitchTheme.surface.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: const Center(
                            child: Icon(Icons.arrow_back, color: StitchTheme.onPrimary),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'CheckIt',
                    style: StitchTheme.headlineMd.copyWith(
                      color: StitchTheme.onPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: StitchTheme.surface.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: const Center(
                            child: Icon(Icons.flash_on, color: StitchTheme.onPrimary),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
  
            // Scanning Area
            Positioned.fill(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!_allCaptured && _currentState != ScannerState.previewing) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _getScanInstruction(context, _currentAngleIndex),
                              style: StitchTheme.titleMd.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppLocalizations.of(context)!.scanInstructionAlign,
                              style: StitchTheme.bodyMd.copyWith(color: Colors.white70, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    // Scanning Frame
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Inner subtle border
                            Positioned(
                              top: 16,
                              bottom: 16,
                              left: 16,
                              right: 16,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
  
                            // Scanner Brackets
                            Positioned(
                              top: 0,
                              left: 0,
                              child: _buildBracket(top: true, left: true),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: _buildBracket(top: true, left: false),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: _buildBracket(top: false, left: true),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: _buildBracket(top: false, left: false),
                            ),
  
                            // Animated Scan Line (only when not previewing/analyzing)
                            if (_currentState != ScannerState.previewing && !_allCaptured)
                              AnimatedBuilder(
                                animation: _scanAnimationController,
                                builder: (context, child) {
                                  final value = _scanAnimationController.value;
                                  return Positioned(
                                    top: value * MediaQuery.of(context).size.width * 0.75,
                                    left: 0,
                                    right: 0,
                                    child: Opacity(
                                      opacity: value < 0.1 ? value * 10 : (value > 0.9 ? (1.0 - value) * 10 : 1.0),
                                      child: Container(
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: StitchTheme.secondary,
                                          boxShadow: [
                                            BoxShadow(
                                              color: StitchTheme.secondary.withValues(alpha: 0.6),
                                              blurRadius: 8,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
  
            // Bottom Controls
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Progress Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: StitchTheme.surface.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: StitchTheme.secondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.scanProgressText(_allCaptured ? 3 : _currentAngleIndex + 1, 3).toUpperCase(),
                          style: StitchTheme.labelMd.copyWith(
                            color: StitchTheme.onPrimary, 
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Indicators
                  _buildAngleIndicators(),
                  const SizedBox(height: 32),
                  
                  // Bottom background panel for Capture Area
                  ClipRect(
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                      child: Container(
                        padding: EdgeInsets.only(
                          top: 24,
                          bottom: MediaQuery.of(context).padding.bottom + 24,
                          left: 20,
                          right: 20,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1917).withValues(alpha: 0.8),
                          border: Border(
                            top: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: _pickFromGallery,
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: StitchTheme.surface.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(Icons.photo_library, color: StitchTheme.onPrimary),
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            
                            // Center Action (Analyze or Status Text)
                            _allCaptured
                              ? ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: StitchTheme.primary,
                                    foregroundColor: StitchTheme.onPrimary,
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  onPressed: _analyze,
                                  icon: const Icon(Icons.analytics),
                                  label: Text(AppLocalizations.of(context)!.scanBtnAnalyze, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                )
                              : _buildDynamicStatusText(context),
                              
                            const SizedBox(width: 24),
                            
                            GestureDetector(
                              onTap: _toggleCamera,
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: StitchTheme.surface.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(Icons.flip_camera_ios, color: StitchTheme.onPrimary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Preview Overlay
            if (_currentState == ScannerState.previewing && _previewImagePath != null)
              Positioned.fill(
                child: Container(
                  color: const Color(0xFF1C1917).withValues(alpha: 0.95),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.scanStatusCapturedTitle(_getAngleName(context, _currentAngleIndex).toUpperCase()),
                          style: StitchTheme.headlineSm.copyWith(
                            color: StitchTheme.secondary, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 32),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          height: MediaQuery.of(context).size.width * 0.75,
                          decoration: BoxDecoration(
                            border: Border.all(color: StitchTheme.secondary, width: 4),
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: kIsWeb 
                                  ? NetworkImage(_previewImagePath!) as ImageProvider 
                                  : FileImage(File(_previewImagePath!)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              onPressed: _retakePreview,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white),
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(AppLocalizations.of(context)!.scanBtnRetake, style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 24),
                            ElevatedButton(
                              onPressed: _confirmPreview,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: StitchTheme.secondary,
                                foregroundColor: const Color(0xFF1C1917),
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(AppLocalizations.of(context)!.scanBtnContinue, style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ),
  
            // Analysis Loading Overlay
            if (scanProvider.isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.8),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(color: StitchTheme.secondary),
                        const SizedBox(height: 24),
                        Text(
                          scanProvider.processingStep, 
                          style: StitchTheme.bodyLg.copyWith(
                            color: Colors.white, 
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
    );
  }

  Widget _buildBracket({required bool top, required bool left}) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        border: Border(
          top: top ? const BorderSide(color: Colors.white, width: 4) : BorderSide.none,
          bottom: !top ? const BorderSide(color: Colors.white, width: 4) : BorderSide.none,
          left: left ? const BorderSide(color: Colors.white, width: 4) : BorderSide.none,
          right: !left ? const BorderSide(color: Colors.white, width: 4) : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: top && left ? const Radius.circular(8) : Radius.zero,
          topRight: top && !left ? const Radius.circular(8) : Radius.zero,
          bottomLeft: !top && left ? const Radius.circular(8) : Radius.zero,
          bottomRight: !top && !left ? const Radius.circular(8) : Radius.zero,
        ),
      ),
    );
  }
}
