import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PdfStorageService {
  /// Cache androidInfo supaya tidak query platform channel 2x per proses simpan.
  Future<AndroidDeviceInfo?> _getAndroidInfo() async {
    if (!Platform.isAndroid) return null;
    return DeviceInfoPlugin().androidInfo;
  }

  Future<bool> _hasStoragePermission(
    BuildContext context,
    AndroidDeviceInfo? infoDevice,
  ) async {
    // True jika device bukan android
    if (!Platform.isAndroid || infoDevice == null) return true;

    // True jika android versi sdk >= 29 (scoped storage, tidak perlu permission)
    if (infoDevice.version.sdkInt >= 29) return true;

    // Request permission untuk android lama
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Izin Tidak diberikan")));
      }
      return false;
    }
    return true;
  }

  Future<bool> saveToDownloads({
    required BuildContext context,
    required Uint8List bytes,
    required String fileName,
    String mediaStoreAppFolder = "SAMBA",
  }) async {
    // Cek platform paling awal, sebelum menyentuh filesystem sama sekali.
    if (!Platform.isAndroid) return false;

    final info = await _getAndroidInfo();
    final granted = await _hasStoragePermission(context, info);
    if (!granted) return false;

    File? tempFile;

    try {
      final tempDir = await getTemporaryDirectory();
      tempFile = File('${tempDir.path}/$fileName');
      await tempFile.writeAsBytes(bytes);

      if (info!.version.sdkInt >= 29) {
        final mediaStore = MediaStore();
        MediaStore.appFolder = mediaStoreAppFolder;

        final result = await mediaStore.saveFile(
          tempFilePath: tempFile.path,
          dirType: DirType.download,
          dirName: DirName.download,
        );
        return result != null;
      } else {
        final downloadsDir = Directory('/storage/emulated/0/Download');
        if (!await downloadsDir.exists()) {
          await downloadsDir.create(recursive: true);
        }
        final file = File('${downloadsDir.path}/$fileName');
        await file.writeAsBytes(bytes);
        return true;
      }
    } catch (e, st) {
      debugPrint('PdfStorageService.saveToDownloads error: $e\n$st');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Gagal menyimpan file")));
      }
      return false;
    } finally {
      // Bersihkan temp file agar tidak menumpuk di cache, apapun hasilnya.
      if (tempFile != null && await tempFile.exists()) {
        await tempFile.delete();
      }
    }
  }
}
