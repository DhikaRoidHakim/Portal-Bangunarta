import 'package:flutter/material.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';

void showSipebriAboutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Tentang SIPEBRI',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppTheme.textPrimary,
        ),
      ),
      content: const Text(
        'SIPEBRI (Sistem Permohonan Kredit) adalah modul aplikasi internal BPR Bangunarta untuk mendokumentasikan, menganalisis, dan memantau setiap pengajuan kredit debitur secara real-time.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text(
            'Tutup',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}
