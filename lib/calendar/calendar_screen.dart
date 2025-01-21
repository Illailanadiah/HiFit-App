import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hifit/helper/database_helper.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<String>> _events = {};
  List<String> _selectedEvents = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final db = DatabaseHelper.instance;

    // Fetch medications
    final medications = await db.fetchMedications();
    for (var med in medications) {
      final timeParts = med['time'].split(':');
      final int hour = int.parse(timeParts[0]);
      final int minute = int.parse(timeParts[1]);
      final medicationDate = DateTime(
        _focusedDay.year,
        _focusedDay.month,
        _focusedDay.day,
        hour,
        minute,
      );

      _events[medicationDate] = _events[medicationDate] ?? [];
      _events[medicationDate]!.add(
          'Take ${med['name']} (${med['dosage']}mg) at ${med['time']}');
    }

    // Fetch mood logs
    final moodLogs = await db.fetchMoodLogs();
    for (var log in moodLogs) {
      final DateTime logDate = DateTime.parse(log['timestamp']);
      _events[logDate] = _events[logDate] ?? [];
      _events[logDate]!.add(
          'Mood: ${log['mood']}, Energy: ${log['energyLevel']}');
    }

    setState(() {});
  }

  List<String> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HiFit Calendar'),
        backgroundColor: const Color(0xFF21565C), // Deep Blue
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2100),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedEvents = _getEventsForDay(selectedDay);
              });
            },
            eventLoader: _getEventsForDay,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.purpleAccent,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Events:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF21565C),
            ),
          ),
          Expanded(
            child: _selectedEvents.isEmpty
                ? const Center(
                    child: Text(
                      'No events for this day.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFB5B0B3), // Silver
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _selectedEvents.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          title: Text(
                            _selectedEvents[index],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF091819), // Black
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
