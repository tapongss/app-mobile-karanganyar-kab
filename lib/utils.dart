import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openUrl(BuildContext context, String url) async {
  bool ok = false;
  try {
    ok = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } catch (_) {}
  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tidak dapat membuka tautan. Periksa koneksi Anda.')),
    );
  }
}

Future<void> openMaps(BuildContext context, String query) => openUrl(
      context,
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}',
    );
