import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/history_item.dart';

class History with ChangeNotifier {

  List<HistoryItem> _history = [];

  List<HistoryItem> get history => [..._history];

  List<String> get historyAsListString {
    return _history
        .map((historyItem) => json.encode(historyItem.toMap))
        .toList();
  }

  void addHistoryItem(String operation, String result) async {
    bool isSameLastCalculation = _history.isNotEmpty &&
        _history.last.operation == operation &&
        _history.last.result == result;

    if (result.isEmpty || isSameLastCalculation) return;

    if (_history.length > 8) _history.removeAt(0);

    final addedHistoryItem = HistoryItem(
      operation: operation,
      result: result,
      createdAt: DateTime.now(),
    );
    _history.add(addedHistoryItem);
    _history.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('history', historyAsListString);
  }

  Future<void> fetchAndSetHistory() async {
    final prefs = await SharedPreferences.getInstance();

    final loadedHistory = prefs.getStringList('history');

    if (loadedHistory == null) return;

    _history = loadedHistory.map((stringHistoryItem) {
      return HistoryItem.fromMap(json.decode(stringHistoryItem));
    }).toList();
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _history.clear();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('history');
  }
}
