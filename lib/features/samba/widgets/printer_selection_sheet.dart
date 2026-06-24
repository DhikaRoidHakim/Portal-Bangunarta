import 'package:bangunarta_portal/models/samba/cetak_simpanan_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:bangunarta_portal/features/samba/providers/samba_provider.dart';
import 'package:bangunarta_portal/features/samba/services/thermal_printer_service.dart';
import 'package:bangunarta_portal/models/samba/transaction_response_model.dart';

/// Bottom sheet untuk memilih printer dan menjalankan cetak
class PrinterSelectionSheet extends ConsumerStatefulWidget {
  final int transactionId;

  const PrinterSelectionSheet({super.key, required this.transactionId});

  @override
  ConsumerState<PrinterSelectionSheet> createState() =>
      _PrinterSelectionSheetState();
}

class _PrinterSelectionSheetState extends ConsumerState<PrinterSelectionSheet> {
  List<BluetoothInfo> _devices = [];
  bool _isLoading = true;
  bool _isPrinting = false;
  String? _connectedMac;

  /// Data cetak yang sudah berhasil diambil dari server.
  /// Disimpan agar retry tidak perlu hit endpoint lagi (counter tidak bertambah).
  CetakSimpananData? _cachedTxData;

  /// Tipe error untuk menentukan UI yang ditampilkan
  _ErrorType? _errorType;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    setState(() {
      _isLoading = true;
      _errorType = null;
      _errorMessage = null;
    });

    // Izin bluetooth
    final permResult = await ThermalPrinterService.requestBluetoothPermission();

    if (permResult == BluetoothPermissionResult.permanentlyDenied) {
      setState(() {
        _isLoading = false;
        _errorType = _ErrorType.permanentlyDenied;
        _errorMessage =
            'Izin Bluetooth ditolak secara permanen.\nBuka Pengaturan Aplikasi untuk mengaktifkannya kembali.';
      });
      return;
    }

    if (permResult == BluetoothPermissionResult.denied) {
      setState(() {
        _isLoading = false;
        _errorType = _ErrorType.denied;
        _errorMessage =
            'Izin Bluetooth diperlukan untuk terhubung ke printer.\nSilakan izinkan akses Bluetooth.';
      });
      return;
    }

    // Pengecekan bluetooth aktif
    final bluetoothOn = await ThermalPrinterService.isBluetoothEnabled();
    if (!bluetoothOn) {
      setState(() {
        _isLoading = false;
        _errorType = _ErrorType.bluetoothOff;
        _errorMessage =
            'Bluetooth tidak aktif.\nSilakan aktifkan Bluetooth terlebih dahulu.';
      });
      return;
    }

    // Mengambil daftar perangkat yang ada
    final devices = await ThermalPrinterService.getPairedDevices();

    setState(() {
      _isLoading = false;
      _devices = devices;
      _connectedMac = null;
    });
  }

  Future<void> _connectAndPrint(BluetoothInfo device) async {
    if (_isPrinting) return;

    setState(() {
      _isPrinting = true;
      _errorMessage = null;
      _errorType = null;
    });

    final connected = await ThermalPrinterService.connect(device.macAdress);
    if (!mounted) return;
    if (!connected) {
      setState(() {
        _isPrinting = false;
        _errorType = _ErrorType.printFailed;
        _errorMessage =
            'Gagal terhubung ke ${device.name} setelah beberapa percobaan.\nPastikan printer menyala, dalam jangkauan Bluetooth, dan tidak terhubung ke perangkat lain.';
      });
      return;
    }

    setState(() => _connectedMac = device.macAdress);
    CetakSimpananData txData;
    try {
      if (_cachedTxData != null) {
        txData = _cachedTxData!;
      } else {
        final cetakResult = await ref
            .read(cetakTransactionProvider(widget.transactionId).future)
            .timeout(const Duration(seconds: 10));
        txData = cetakResult.data;
        _cachedTxData = txData;
      }
    } catch (_) {
      await ThermalPrinterService.disconnect();
      if (!mounted) return;
      setState(() {
        _isPrinting = false;
        _connectedMac = null;
        _errorType = _ErrorType.printFailed;
        _errorMessage = 'Gagal mengambil data cetak dari server.';
      });
      return;
    }

    final printed = await ThermalPrinterService.printTransactionReceipt(
      txData,
      macAddress: device.macAdress,
    );

    await ThermalPrinterService.disconnect();

    if (!mounted) return;
    setState(() {
      _isPrinting = false;
      _connectedMac = null;
    });

    if (!mounted) return;

    if (printed) {
      // Bersihkan cache setelah cetak berhasil
      _cachedTxData = null;
      Navigator.pop(context);
      _showSuccessSnackbar();
    } else {
      setState(() {
        _errorType = _ErrorType.printFailed;
        _errorMessage =
            'Gagal mencetak. Pastikan printer siap dan kertas tersedia.\nTekan \'Coba Lagi\' untuk mencetak ulang tanpa menambah counter cetak.';
      });
    }
  }

  void _showSuccessSnackbar() {
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.hideCurrentSnackBar();
    messenger?.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: const Duration(seconds: 3),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFDCFCE7), width: 1.5),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF16A34A),
                size: 22,
              ),
              SizedBox(width: 12),
              Text(
                'Cetak berhasil!',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF15803D),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(0, 0, 0, bottomInset + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(99),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.print_rounded,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pilih Printer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'Pilih printer thermal yang sudah terpasang',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  color: AppTheme.textSecondary,
                  iconSize: 20,
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 0.8, color: Color(0xFFF1F5F9)),

          // Content
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    // ── Loading ───────────────────────────────────────────
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            children: [
              CircularProgressIndicator(color: AppTheme.primaryColor),
              SizedBox(height: 16),
              Text(
                'Memeriksa izin & mencari printer...',
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    // ── Ditolak Permanen → arahkan ke Settings ────────────
    if (_errorType == _ErrorType.permanentlyDenied) {
      return _buildErrorState(
        icon: Icons.bluetooth_disabled_rounded,
        iconColor: Colors.red,
        iconBg: Colors.red.withValues(alpha: 0.08),
        message: _errorMessage!,
        primaryLabel: 'Buka Pengaturan',
        onPrimary: () async {
          await openAppSettings();
        },
        secondaryLabel: 'Tutup',
        onSecondary: () => Navigator.pop(context),
      );
    }

    // ── Ditolak → minta lagi ──────────────────────────────
    if (_errorType == _ErrorType.denied) {
      return _buildErrorState(
        icon: Icons.bluetooth_disabled_rounded,
        iconColor: Colors.orange,
        iconBg: Colors.orange.withValues(alpha: 0.08),
        message: _errorMessage!,
        primaryLabel: 'Izinkan Bluetooth',
        onPrimary: _initialize,
        secondaryLabel: 'Batalkan',
        onSecondary: () => Navigator.pop(context),
      );
    }

    // ── Bluetooth mati ────────────────────────────────────
    if (_errorType == _ErrorType.bluetoothOff) {
      return _buildErrorState(
        icon: Icons.bluetooth_disabled_rounded,
        iconColor: Colors.orange,
        iconBg: Colors.orange.withValues(alpha: 0.08),
        message: _errorMessage!,
        primaryLabel: 'Coba Lagi',
        onPrimary: _initialize,
        secondaryLabel: 'Tutup',
        onSecondary: () => Navigator.pop(context),
      );
    }

    // ── Tidak ada printer dipasangkan ─────────────────────
    if (_devices.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                color: AppTheme.primaryColor.withValues(alpha: 0.7),
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tidak ada printer yang ditemukan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Pastikan printer thermal sudah dipasangkan\nmelalui menu Bluetooth di pengaturan HP.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: _initialize,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Perbarui Daftar'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                side: const BorderSide(color: AppTheme.primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // ── Daftar printer ────────────────────────────────────
    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.35,
          ),
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: _devices.length,
            separatorBuilder: (_, _) => const Divider(
              height: 1,
              thickness: 0.8,
              color: Color(0xFFF1F5F9),
              indent: 20,
              endIndent: 20,
            ),
            itemBuilder: (_, index) {
              final device = _devices[index];
              final isThisPrinting =
                  _isPrinting && _connectedMac == device.macAdress;

              return _PrinterTile(
                device: device,
                isPrinting: isThisPrinting,
                isDisabled: _isPrinting,
                onTap: () => _connectAndPrint(device),
              );
            },
          ),
        ),

        // Error inline (gagal cetak)
        if (_errorType == _ErrorType.printFailed && _errorMessage != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: Colors.redAccent,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.redAccent,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Badge "data aman" jika sudah ada cache
                  if (_cachedTxData != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Colors.orange.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.cloud_done_outlined,
                            size: 13,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Data tersimpan – cetak ulang tidak menambah counter',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

        // Info hint
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 14,
                color: AppTheme.textSecondary.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Printer harus dipasangkan terlebih dahulu melalui menu Bluetooth di pengaturan HP.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String message,
    required String primaryLabel,
    required VoidCallback onPrimary,
    required String secondaryLabel,
    required VoidCallback onSecondary,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 36),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onSecondary,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.textSecondary,
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(secondaryLabel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onPrimary,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    primaryLabel,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

enum _ErrorType { denied, permanentlyDenied, bluetoothOff, printFailed }

class _PrinterTile extends StatelessWidget {
  final BluetoothInfo device;
  final bool isPrinting;
  final bool isDisabled;
  final VoidCallback onTap;

  const _PrinterTile({
    required this.device,
    required this.isPrinting,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              // Printer icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isPrinting
                      ? AppTheme.primaryColor.withValues(alpha: 0.12)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isPrinting
                        ? AppTheme.primaryColor.withValues(alpha: 0.3)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: isPrinting
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.primaryColor,
                        ),
                      )
                    : Icon(
                        Icons.print_rounded,
                        size: 20,
                        color: isDisabled
                            ? AppTheme.textSecondary.withValues(alpha: 0.4)
                            : AppTheme.primaryColor.withValues(alpha: 0.8),
                      ),
              ),
              const SizedBox(width: 14),

              // Device info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.name.isNotEmpty
                          ? device.name
                          : 'Printer Tanpa Nama',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDisabled && !isPrinting
                            ? AppTheme.textSecondary.withValues(alpha: 0.5)
                            : AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      device.macAdress,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary.withValues(alpha: 0.6),
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),

              // Status
              if (isPrinting)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Mencetak...',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                )
              else if (!isDisabled)
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.textSecondary.withValues(alpha: 0.4),
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
