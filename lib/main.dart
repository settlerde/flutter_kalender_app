import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'calender_page.dart';
import 'event_page.dart';
import 'responsive_layout.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: CalendarApp()),
  );
}

class CalendarApp extends StatefulWidget {
  const CalendarApp({super.key});

  @override
  State<CalendarApp> createState() => _CalendarAppState();
}

class _CalendarAppState extends State<CalendarApp> {
  int _currentIndex = 0;
  DateTime _selectedMonth = DateTime.now();
  List<String> _historicalEvents = ["Wähle ein Datum im Kalender aus"];
  bool _isLoading = false;

  Future<void> _fetchEvent(int month, int day) async {
    setState(() {
      _isLoading = true;
      if (MediaQuery.of(context).size.width <= 800) _currentIndex = 2;
    });

    try {
      final url = Uri.parse(
        'https://de.wikipedia.org/api/rest_v1/feed/onthisday/events/$month/$day',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List allEvents = data['events'] ?? [];
        setState(() {
          _historicalEvents = allEvents
              .take(5)
              .map((e) => e['text'].toString())
              .toList();
        });
      }
    } catch (e) {
      setState(() => _historicalEvents = ["Fehler beim Laden."]);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final String heuteStr = "${now.day}.${now.month}.${now.year}";

    Widget homePage = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.today, size: 80, color: Colors.blueAccent),
          const Text("Heute ist der:", style: TextStyle(fontSize: 18)),
          Text(
            heuteStr,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );

    Widget calWidget = CalendarWidget(
      displayDate: _selectedMonth,
      onDayTap: (day) => _fetchEvent(_selectedMonth.month, day),
    );

    Widget histWidget = HistoricalWidget(
      events: _historicalEvents,
      isLoading: _isLoading,
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(
                Icons.chevron_left,
                size: 30,
                color: Colors.blueAccent,
              ),
              onPressed: () => setState(
                () => _selectedMonth = DateTime(
                  _selectedMonth.year,
                  _selectedMonth.month - 1,
                ),
              ),
            ),
            const Text(
              "Zeitmaschine",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(
                Icons.chevron_right,
                size: 30,
                color: Colors.blueAccent,
              ),
              onPressed: () => setState(
                () => _selectedMonth = DateTime(
                  _selectedMonth.year,
                  _selectedMonth.month + 1,
                ),
              ),
            ),
          ],
        ),
        actions: [],
      ),
      body: ResponsiveLayout(
        mobileBody: IndexedStack(
          index: _currentIndex,
          children: [homePage, calWidget, histWidget],
        ),
        desktopBody: Row(
          children: [
            Expanded(
              flex: 2,
              child: Center(child: SizedBox(width: 700, child: calWidget)),
            ),
            const VerticalDivider(width: 1),
            Expanded(flex: 1, child: histWidget),
          ],
        ),
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width > 800
          ? null
          : BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month),
                  label: 'Kalender',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history_edu),
                  label: 'Historie',
                ),
              ],
            ),
    );
  }
}
