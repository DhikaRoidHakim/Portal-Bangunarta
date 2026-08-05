import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:bangunarta_portal/features/sigma/repository/sigma_repository.dart';
import 'package:bangunarta_portal/models/sigma/list_assets_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  late final MobileScannerController _controller;
  bool _isProcessing = false;
  bool _isTorchOn = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _extractAssetCode(String raw) {
    final clean = raw.trim();
    // 1. Try parsing JSON
    try {
      if (clean.startsWith('{') && clean.endsWith('}')) {
        final decoded = jsonDecode(clean);
        if (decoded is Map<String, dynamic>) {
          if (decoded.containsKey('kode_aset') && decoded['kode_aset'] != null) {
            return decoded['kode_aset'].toString();
          }
          if (decoded.containsKey('id') && decoded['id'] != null) {
            return decoded['id'].toString();
          }
        }
      }
    } catch (_) {}

    // 2. Try parsing URL
    if (clean.startsWith('http://') || clean.startsWith('https://')) {
      try {
        final uri = Uri.parse(clean);
        if (uri.pathSegments.isNotEmpty) {
          return uri.pathSegments.last;
        }
      } catch (_) {}
    }

    return clean;
  }

  Future<void> _handleDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? rawValue = barcodes.first.rawValue ?? barcodes.first.displayValue;
    if (rawValue == null || rawValue.isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    await _controller.stop();

    final assetCode = _extractAssetCode(rawValue);

    if (!mounted) return;

    // Show loading overlay
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF28A745)),
      ),
    );

    try {
      // 1. First search in list of assets
      final listResult = await SigmaRepository.instance.getListAssets();
      if (!mounted) return;
      Navigator.of(context).pop(); // Dismiss loading

      final match = listResult.data.firstWhere(
        (item) =>
            item.kodeAset.toLowerCase() == assetCode.toLowerCase() ||
            item.id.toLowerCase() == assetCode.toLowerCase(),
        orElse: () => const AssetsModel(
          id: '',
          kodeAset: '',
          namaAset: '',
          currentOfficeId: '',
          currentRoomId: '',
          createdAt: '',
          updatedAt: '',
          currentOfficeName: '',
          currentRoomName: '',
          totalMoves: 0,
          totalRepairs: 0,
          inRepair: false,
        ),
      );

      if (match.id.isNotEmpty || match.kodeAset.isNotEmpty) {
        if (mounted) {
          context.pushReplacement('/sigma/asset-detail', extra: match);
        }
        return;
      }

      // 2. If not found in list, try fetching detail endpoint directly by ID
      try {
        final detailResult = await SigmaRepository.instance.getDetailAsset(assetCode);
        if (detailResult.detail != null && mounted) {
          context.pushReplacement('/sigma/asset-detail', extra: detailResult.detail);
          return;
        }
      } catch (_) {}

      // If still not found, show error dialog
      if (mounted) {
        _showNotFoundDialog(assetCode);
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Dismiss loading if showing
        _showNotFoundDialog(assetCode);
      }
    }
  }

  void _showNotFoundDialog(String code) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off_rounded, color: const Color(0xFFDC3545), size: 48.sp),
              SizedBox(height: 16.h),
              Text(
                'Aset Tidak Ditemukan',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              SizedBox(height: 10.h),
              Text(
                'Kode Aset "$code" tidak terdaftar dalam sistem SIGMA.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: AppTheme.textSecondary),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    setState(() {
                      _isProcessing = false;
                    });
                    await _controller.start();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF28A745),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  child: const Text('Scan Ulang'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showManualInputDialog() {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Input Kode Aset Manual',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: textController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Contoh: AST-001',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton(
                    onPressed: () {
                      final input = textController.text.trim();
                      if (input.isNotEmpty) {
                        Navigator.pop(context);
                        _handleDetect(
                          BarcodeCapture(barcodes: [Barcode(rawValue: input)]),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF28A745),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Cari Aset'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. MobileScanner View
          MobileScanner(
            controller: _controller,
            onDetect: _handleDetect,
          ),

          // 2. Custom Overlay Scan Window
          _buildScannerOverlay(),

          // 3. Header Controls (Back, Flash, Camera Flip)
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            _isTorchOn ? Icons.flash_on : Icons.flash_off,
                            color: _isTorchOn ? Colors.yellow : Colors.white,
                          ),
                          onPressed: () async {
                            await _controller.toggleTorch();
                            setState(() {
                              _isTorchOn = !_isTorchOn;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.cameraswitch, color: Colors.white),
                          onPressed: () async {
                            await _controller.switchCamera();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 4. Bottom Manual Input Button & Guide Text
          Positioned(
            left: 20.w,
            right: 20.w,
            bottom: 40.h,
            child: Column(
              children: [
                Text(
                  'Arahkan kamera ke QR Code label aset SIGMA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    shadows: const [
                      Shadow(blurRadius: 4, color: Colors.black),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                ElevatedButton.icon(
                  onPressed: _showManualInputDialog,
                  icon: const Icon(Icons.keyboard, color: Colors.white),
                  label: const Text(
                    'Input Kode Manual',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF28A745),
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.6),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 260.w,
                  height: 260.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 260.w,
            height: 260.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: const Color(0xFF28A745), width: 3),
            ),
          ),
        ),
      ],
    );
  }
}
