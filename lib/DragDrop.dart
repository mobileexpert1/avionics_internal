import 'package:flutter/material.dart';

class SequenceDragDropScreen extends StatefulWidget {
  const SequenceDragDropScreen({super.key});

  @override
  State<SequenceDragDropScreen> createState() => _SequenceDragDropScreenState();
}

class _SequenceDragDropScreenState extends State<SequenceDragDropScreen> {
  List<String> events = [
    'Crew notes heavy weather ahead',
    'Aircraft enters thunderstorm',
    'Strong turbulence shakes the aircraft',
    'Pilots adjust altitude',
    'Lightning is observed nearby',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: const Text('Sequence the Events'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Put these events in sequence\nas the Electra encountered the storm',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ReorderableListView.builder(
                itemCount: events.length,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final item = events.removeAt(oldIndex);
                    events.insert(newIndex, item);
                  });
                },
                itemBuilder: (context, index) {
                  return Card(
                    key: ValueKey(events[index]),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.green.shade300),
                    ),
                    color: Colors.green.shade50,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      title: Text(
                        events[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: const Icon(Icons.drag_handle, color: Colors.green),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
