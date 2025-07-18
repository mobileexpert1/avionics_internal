import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class ReceiptHelper {
  static const MethodChannel _channel = MethodChannel('com.avioflai.aviation/receipt');
  static String? _cachedBase64Receipt;

  /// Saves the App Store receipt file locally and returns the file path.
  static Future<String?> downloadReceipt({bool forceRefresh = false}) async {
    print("🛠️ downloadReceipt() called");

    try {
      if (_cachedBase64Receipt == null || forceRefresh) {
        print("Calling platform channel to get receipt...");
        final String base64Receipt = await _channel.invokeMethod('getReceiptData');
        print("Receipt fetched, length: ${base64Receipt.length}");
        _cachedBase64Receipt = base64Receipt;
      }

      final file = await _writeToFile(_cachedBase64Receipt!);

      if (await file.exists()) {
        print( "${file.path}");
        return file.path;
      } else {
        print("File not saved.");
        return null;
      }
    } catch (e) {
      print("Exception while downloading receipt: $e");
      return null;
    }
  }


  static Future<File> _writeToFile(String base64Content) async {
    final directory = await getApplicationDocumentsDirectory(); // better for persistent access
    final file = File('${directory.path}/appstore_receipt.txt');
    return file.writeAsString(base64Content);
  }
}
