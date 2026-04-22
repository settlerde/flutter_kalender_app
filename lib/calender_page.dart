import 'package:flutter/material.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime displayDate;
  final Function(int) onDayTap;

  const CalendarWidget({
    super.key,
    required this.displayDate,
    required this.onDayTap,
  });

  String _getMonthName(int month) {
    const names = [
      "Januar",
      "Februar",
      "März",
      "April",
      "Mai",
      "Juni",
      "Juli",
      "August",
      "September",
      "Oktober",
      "November",
      "Dezember",
    ];
    return names[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final int daysInMonth = DateTime(
      displayDate.year,
      displayDate.month + 1,
      0,
    ).day;
    final int firstWeekday = DateTime(
      displayDate.year,
      displayDate.month,
      1,
    ).weekday;
    final DateTime now = DateTime.now();
    final List<String> weekDays = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"];

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Wähle einen Tag",
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "${_getMonthName(displayDate.month)} ${displayDate.year}",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
        ),
        Row(
          children: weekDays
              .map(
                (d) => Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: (d == "Sa" || d == "So")
                            ? Colors.red
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const Divider(),
        Expanded(
          child: GridView.count(
            crossAxisCount: 7,
            children: [
              for (int i = 1; i < firstWeekday; i++) const SizedBox(),
              for (int day = 1; day <= daysInMonth; day++)
                Builder(
                  builder: (context) {
                    final DateTime date = DateTime(
                      displayDate.year,
                      displayDate.month,
                      day,
                    );
                    final bool isWeekend = date.weekday > 5;
                    final bool isToday =
                        day == now.day &&
                        displayDate.month == now.month &&
                        displayDate.year == now.year;
                    return InkWell(
                      onTap: () => onDayTap(day),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          color: isToday
                              ? Colors.blueAccent
                              : (isWeekend
                                    ? Colors.red.withOpacity(0.05)
                                    : Colors.transparent),
                        ),
                        child: Center(
                          child: Text(
                            "$day",
                            style: TextStyle(
                              color: isToday
                                  ? Colors.white
                                  : (isWeekend ? Colors.red : Colors.black),
                              fontWeight: isToday
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}
