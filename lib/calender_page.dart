import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'event_page.dart';

class CalendarPage extends StatefulWidget {
  final DateTime displayDate;
  const CalendarPage({super.key, required this.displayDate});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  String _eventText = "Klick auf dem Tag, um die Fakten zu erfahren.";
  bool _isLoading = false;

  Future<void> _fetchEvent(int month, int day) async {
    setState(() => _isLoading = true);

    try {
      final url = Uri.parse(
        'https://de.wikipedia.org/api/rest_v1/feed/onthisday/events/${month}/${day}',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          _eventText = response.body;
        });
      }
    } catch (e) {
      setState(
        () => _eventText =
            "Downloadfehler: Überprüfen Sie Ihre Internetverbindung.",
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth = DateTime(
      widget.displayDate.year,
      widget.displayDate.month + 1,
      0,
    ).day;
    int firstWeekday = DateTime(
      widget.displayDate.year,
      widget.displayDate.month,
      1,
    ).weekday;

    return Column(
      children: [
        SizedBox(
          height: 300,
          child: GridView.count(
            crossAxisCount: 7,
            children: [
              for (int i = 1; i < firstWeekday; i++) const SizedBox(),
              for (int day = 1; day <= daysInMonth; day++)
                InkWell(
                  onTap: () => _fetchEvent(widget.displayDate.month, day),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Center(child: Text("$day")),
                  ),
                ),
            ],
          ),
        ),

        const Divider(),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  "Historisches Ereignis dieses Tages:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                if (_isLoading) const CircularProgressIndicator(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      _eventText,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
