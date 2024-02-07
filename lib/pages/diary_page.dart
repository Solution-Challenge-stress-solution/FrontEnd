import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:strecording/widgets/recording_widget.dart';
import 'package:strecording/widgets/calendar_widget.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  bool isDarkened = false;
  DateTime _currentDate = DateTime.now();

  void setCurrentDate(DateTime selectedDate) {
    _currentDate = selectedDate;
  }

  DateTime getCurrentDate() {
    return _currentDate;
  }

  void toggleDarken() {
    setState(() {
      isDarkened = !isDarkened;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildDiaryHeader(),
                const SizedBox(height: 16),
                buildDateDisplay(),
                const SizedBox(height: 160),
                buildDiaryTextField(),
                const SizedBox(height: 16),
              ],
            ),
          ),
          if (isDarkened)
            Positioned.fill(
              child: GestureDetector(
                onTap: toggleDarken,
                child: Container(
                  color: Colors.black.withOpacity(0.25),
                ),
              ),
            ),
          Positioned(
              left: 16,
              right: 16,
              bottom: 10,
              height: 80,
              child: RecordingWidget(toggleDarken: toggleDarken)),
        ],
      ),
    );
  }

  Widget buildDiaryHeader() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Diary',
            style: TextStyle(
              fontFamily: 'Dongle',
              fontSize: 60,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.95,
                  child: CalendarWidget(
                      setCurrentDate: setCurrentDate,
                      getCurrentDate: getCurrentDate,
                      modalContext: context),
                );
              },
            ).then((_) {
              setState(() {});
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {
            // Handle more action
          },
        ),
      ],
    );
  }

  Widget buildDateDisplay() {
    return Expanded(
      child: Center(
        child: Text(DateFormat('yyyy.MM.dd').format(getCurrentDate()),
            style: const TextStyle(
                fontFamily: 'Dongle',
                fontSize: 36,
                fontWeight: FontWeight.normal)),
      ),
    );
  }

  Widget buildDiaryTextField() {
    return Expanded(
      flex: 5,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 241, 213),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const TextField(
          maxLines: null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
      ),
    );
  }
}
