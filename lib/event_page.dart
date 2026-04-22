import 'package:flutter/material.dart';

class HistoricalWidget extends StatelessWidget {
  final List<String> events;
  final bool isLoading;

  const HistoricalWidget({
    super.key,
    required this.events,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Top 5 Ereignisse",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                leading: CircleAvatar(child: Text("${index + 1}")),
                title: Text(
                  events[index],
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
