import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  final DateTime displayDate;
  const CalendarPage({super.key, required this.displayDate});

  @override
  Widget build(BuildContext context) {
    int daysInMonth = DateTime(displayDate.year, displayDate.month + 1, 0).day;
    int firstWeekday = DateTime(displayDate.year, displayDate.month, 1).weekday;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "${displayDate.year} - ${displayDate.month}",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),

        Expanded(
          child: GridView.count(
            crossAxisCount: 7,
            children: [
              for (int i = 1; i < firstWeekday; i++) const SizedBox(),
              for (int day = 1; day <= daysInMonth; day++)
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Center(child: Text("$day")),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
