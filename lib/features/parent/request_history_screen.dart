import 'package:flutter/material.dart';

class RequestHistoryScreen extends StatefulWidget {
  const RequestHistoryScreen({Key? key}) : super(key: key);
  @override
  _RequestHistoryScreenState createState() => _RequestHistoryScreenState();
}

class _RequestHistoryScreenState extends State<RequestHistoryScreen> {
  List<Map<String, String>> history = [
    {'child': 'Child1', 'device': 'Living Room Light', 'timestamp': '10:15 AM', 'status': 'approved'},
    {'child': 'Child2', 'device': 'AC', 'timestamp': '09:45 AM', 'status': 'rejected'},
  ];
  String filter = '';

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredHistory = history.where((entry) {
      return filter.isEmpty ||
          entry['child']!.contains(filter) ||
          entry['device']!.contains(filter) ||
          entry['status']!.contains(filter);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Request History')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration:
                  const InputDecoration(labelText: 'Filter', border: OutlineInputBorder()),
              onChanged: (value) {
                setState(() {
                  filter = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredHistory.length,
                itemBuilder: (context, index) {
                  var entry = filteredHistory[index];
                  return ListTile(
                    title: Text('${entry['child']} - ${entry['device']}'),
                    subtitle: Text('Time: ${entry['timestamp']}'),
                    trailing: Chip(
                      label: Text(entry['status']!),
                      backgroundColor: entry['status'] == 'approved' ? Colors.green : Colors.red,
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
