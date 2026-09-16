import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../config/app_colors.dart';
import '../config/constants.dart';
import '../providers/scan_provider.dart';
import '../providers/auth_provider.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  int _selectedTab = 0; // 0: Front, 1: Back, 2: Side
  final List<String> _tabs = ['Front', 'Back', 'Side'];
  
  String? _capturedImagePath;
  Uint8List? _capturedImageBytes;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        _cameraController = CameraController(_cameras![0], ResolutionPreset.high);
        await _cameraController!.initialize();
        if (mounted) setState(() {});
      }
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    try {
      final XFile file = await _cameraController!.takePicture();
      final bytes = await file.readAsBytes();
      setState(() {
        _capturedImagePath = file.path;
        _capturedImageBytes = bytes;
      });
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _capturedImagePath = image.path;
        _capturedImageBytes = bytes;
      });
    }
  }

  void _analyzeImage() async {
    if (_capturedImagePath == null || _capturedImageBytes == null) return;
    
    final inspectorId = context.read<AuthProvider>().inspectorId ?? 'GUEST';
    
    final scanProvider = context.read<ScanProvider>();
    scanProvider.performScan([_capturedImagePath!], [_capturedImageBytes!], inspectorId);
    
    context.go(Constants.routeAnalysis);
  }

  Widget _buildCameraPreview() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_cameraController!),
          // Overlay guide
          Center(
            child: Container(
              width: 250,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.forestEmerald, width: 3),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(8),
              child: const Text('Align label here', style: TextStyle(color: Colors.white, shadows: [Shadow(blurRadius: 4)])),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: kIsWeb && _capturedImageBytes != null
          ? Image.memory(_capturedImageBytes!, fit: BoxFit.cover)
          : Image.file(
              File(_capturedImagePath!),
              fit: BoxFit.cover,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.primary, 
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Scan Product', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_off),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_tabs.length, (index) {
                  final isActive = _selectedTab == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTab = index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      padding: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isActive ? AppColors.silverGray : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        _tabs[index],
                        style: textTheme.bodyMedium?.copyWith(
                          color: isActive ? Colors.white : AppColors.silverGray,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            
            // Preview Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: _capturedImagePath == null ? _buildCameraPreview() : _buildImagePreview(),
                ),
              ),
            ),
            
            // Bottom Controls
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: _capturedImagePath == null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.photo_library, color: Colors.white, size: 32),
                          onPressed: _pickFromGallery,
                        ),
                        GestureDetector(
                          onTap: _takePicture,
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child: Center(
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.flip_camera_ios, color: Colors.white, size: 32),
                          onPressed: () {},
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white),
                            ),
                            onPressed: () {
                              setState(() {
                                _capturedImagePath = null;
                                _capturedImageBytes = null;
                              });
                            },
                            child: const Text('Retake'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _analyzeImage,
                            child: const Text('Analyze'),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
