import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io' show Platform;

String toRupiah(String value) {
  final number = num.tryParse(value) ?? 0;
  return NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(number);
}

Future<String> getVersion() async {
  try {
    final info = await PackageInfo.fromPlatform();
    return 'Versi ${info.version}';
  } catch (e) {
    return 'Versi 1.0.0';
  }
}
