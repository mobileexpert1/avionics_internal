
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ReceiptHelper {
  static const MethodChannel _channel = MethodChannel('com.avioflai.aviation/receipt');
  static String? _cachedBase64Receipt;

  static Future<void> fetchAndShareReceipt({bool forceRefresh = false}) async {
    try {
      if (_cachedBase64Receipt == null || forceRefresh) {
        final String base64Receipt = await _channel.invokeMethod('getReceiptData');
        _cachedBase64Receipt = base64Receipt;
      }

      final file = await _writeToFile(_cachedBase64Receipt!);
      Share.shareXFiles([XFile(file.path)], text: "App Store Receipt");

      print("✅ Receipt shared-=-=-=-=-=-=\n${_cachedBase64Receipt!}");
    } catch (e) {
      print("❌ Failed to get receipt: $e");
    }
  }

  static Future<File> _writeToFile(String base64Content) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/appstore_receipt.txt');
    return file.writeAsString(base64Content);
  }
}
