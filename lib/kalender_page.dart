import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class KalenderPage extends StatefulWidget {
  const KalenderPage({super.key});

  @override
  State<KalenderPage> createState() => _KalenderPageState();
}

class _KalenderPageState extends State<KalenderPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // 1. Data Agenda User (Bisa diolah: Tambah/Hapus)
  final Map<DateTime, List<Map<String, String>>> _userEvents = {
    DateTime.utc(2026, 1, 27): [
      {"title": "Bimbingan RPL", "desc": "Konsultasi Project Islamic App", "type": "School"},
    ],
  };

  // 2. REVISI DATA: Hari Besar Islam 2026 (Akurat)
  final Map<DateTime, List<Map<String, String>>> _islamicEvents = {
    DateTime.utc(2026, 2, 14): [{"title": "Isra Mi'raj", "desc": "27 Rajab 1447 H", "type": "Islamic"}],
    DateTime.utc(2026, 2, 18): [{"title": "Awal Ramadhan 1447 H", "desc": "Marhaban ya Ramadhan", "type": "Islamic"}],
    DateTime.utc(2026, 3, 6): [{"title": "Nuzulul Qur'an", "desc": "17 Ramadhan 1447 H", "type": "Islamic"}],
    DateTime.utc(2026, 3, 20): [{"title": "Idul Fitri 1447 H", "desc": "1 Syawal 1447 H", "type": "Islamic"}],
    DateTime.utc(2026, 5, 27): [{"title": "Hari Arafah", "desc": "9 Dzulhijjah 1447 H", "type": "Islamic"}],
    DateTime.utc(2026, 5, 28): [{"title": "Idul Adha 1447 H", "desc": "10 Dzulhijjah 1447 H", "type": "Islamic"}],
    DateTime.utc(2026, 6, 16): [{"title": "Tahun Baru Hijriyah 1448 H", "desc": "1 Muharram 1448 H", "type": "Islamic"}],
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  List<Map<String, String>> _getEventsForDay(DateTime day) {
    DateTime date = DateTime.utc(day.year, day.month, day.day);
    return [
      ...(_userEvents[date] ?? []),
      ...(_islamicEvents[date] ?? []),
    ];
  }

  // Fungsi Tambah Agenda
  void _showAddEventDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Tambah Agenda Baru"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(hintText: "Judul Agenda (Contoh: PKL)")),
            TextField(controller: descController, decoration: const InputDecoration(hintText: "Keterangan")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D4D4D)),
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final date = DateTime.utc(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
                setState(() {
                  if (_userEvents[date] != null) {
                    _userEvents[date]!.add({"title": titleController.text, "desc": descController.text, "type": "Personal"});
                  } else {
                    _userEvents[date] = [{"title": titleController.text, "desc": descController.text, "type": "Personal"}];
                  }
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Simpan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Fungsi Hapus Agenda
  void _deleteEvent(int index) {
    final date = DateTime.utc(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
    setState(() {
      _userEvents[date]!.removeAt(index);
      if (_userEvents[date]!.isEmpty) _userEvents.remove(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F4),
      appBar: AppBar(
        title: const Text("Kalender & Kegiatan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0D4D4D),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildCalendarCard(),
          const SizedBox(height: 10),
          _buildEventHeader(),
          Expanded(child: _buildEventList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        backgroundColor: const Color(0xFF0D4D4D),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        eventLoader: _getEventsForDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onFormatChanged: (format) => setState(() => _calendarFormat = format),
        onPageChanged: (focusedDay) => _focusedDay = focusedDay,
        calendarStyle: const CalendarStyle(
          markerDecoration: BoxDecoration(color: Colors.teal, shape: BoxShape.circle),
          todayDecoration: BoxDecoration(color: Colors.orangeAccent, shape: BoxShape.circle),
          selectedDecoration: BoxDecoration(color: Color(0xFF0D4D4D), shape: BoxShape.circle),
        ),
        headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
      ),
    );
  }

  Widget _buildEventHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('EEEE, d MMMM').format(_selectedDay!),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0D4D4D)),
          ),
          Text("${_getEventsForDay(_selectedDay!).length} Event", style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    final allEvents = _getEventsForDay(_selectedDay!);

    if (allEvents.isEmpty) {
      return const Center(child: Text("Kosong bro, santai dulu.", style: TextStyle(color: Colors.grey)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: allEvents.length,
      itemBuilder: (context, index) {
        final event = allEvents[index];
        final isIslamic = event['type'] == 'Islamic';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: isIslamic ? const Color(0xFFE8F5E9) : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: isIslamic ? Colors.green.shade200 : Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Icon(isIslamic ? Icons.mosque : Icons.event_note, color: isIslamic ? Colors.green : Colors.blue),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(event['desc']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              if (!isIslamic)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () => _deleteEvent(index),
                ),
            ],
          ),
        );
      },
    );
  }
}