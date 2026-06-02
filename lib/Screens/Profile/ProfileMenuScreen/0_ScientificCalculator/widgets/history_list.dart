import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/history.dart';
import 'clear_history_button.dart';
import 'empty_history.dart';
import 'history_card.dart';

class HistoryList extends StatefulWidget {
  const HistoryList({Key? key}) : super(key: key);

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  late Future _historyFuture;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _historyFuture = Provider.of<History>(
      context,
      listen: false,
    ).fetchAndSetHistory();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();

    if (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year) {
      return "Today";
    }

    final yesterday = now.subtract(const Duration(days: 1));

    if (date.day == yesterday.day &&
        date.month == yesterday.month &&
        date.year == yesterday.year) {
      return "Yesterday";
    }

    return DateFormat.yMMMd().format(date);
  }

  String formatTime(DateTime date) {
    return DateFormat.jm().format(date);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _historyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const EmptyHistory();
        } else {
          return Column(
            children: [
              Expanded(
                child: Container(
                  color: AppColors.primaryDark,
                  child: Consumer<History>(
                    builder: (context, historyProvider, _) {
                      if (historyProvider.history.isEmpty) {
                        return const EmptyHistory();
                      }

                      return Scrollbar(
                        controller: _scrollController,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: historyProvider.history.length,
                          itemBuilder: (context, index) {
                            final item = historyProvider.history[index];
                            final DateTime createdAt = item.createdAt;
                            return HistoryCard(
                              operation: item.operation,
                              result: item.result,
                              time: formatTime(createdAt),
                              date: formatDate(createdAt),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              const ClearHistoryButton(),
              SizedBox(height: 30),
            ],
          );
        }
      },
    );
  }
}
