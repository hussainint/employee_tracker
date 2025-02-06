import 'package:employee_tracker/src/presentation/layout/resonsive_body.dart';
import 'package:employee_tracker/src/utils/format_date.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../layout/responsive.dart';
import '../../utils/datetime_helper.dart';

enum DateSelection { today, nextMonday, nextTuesday, afterOneWeek, nodate, none }

class CustomDatepicker extends StatefulWidget {
  final bool joiningDate;

  final DateTime? selectedDateTime;
  final Function(DateTime?) onDateSelected;
  const CustomDatepicker(
      {super.key, required this.joiningDate, this.selectedDateTime, required this.onDateSelected});
  @override
  _CustomDatepickerState createState() => _CustomDatepickerState();
}

class _CustomDatepickerState extends State<CustomDatepicker> {
  DateTime? _selectedDate;
  @override
  void initState() {
    super.initState();
    if (widget.joiningDate) {
      _selectedDate = widget.selectedDateTime ?? DateTime.now();
    }
  }

  DateSelection _selectedButton = DateSelection.none;
  void _showCalendarDialog(BuildContext context) {
    DateTime? tempSelectedDate = _selectedDate;

    showDialog(
      context: context,
      builder: (context) {
        return Container(
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              return Dialog(
                backgroundColor: Colors.white,
                insetPadding: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  width: !Responsive.isMobile(context) ? 480 : null,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      (widget.joiningDate)
                          ? GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 5,
                              children: [
                                _buildButton("Today", _selectedButton == DateSelection.today, () {
                                  setDialogState(() {
                                    tempSelectedDate = DateTime.now();
                                    _selectedButton = DateSelection.today;
                                  });
                                }),
                                _buildButton(
                                    "Next Monday", _selectedButton == DateSelection.nextMonday, () {
                                  setDialogState(() {
                                    tempSelectedDate = _getNextWeekday(DateTime.monday);
                                    _selectedButton = DateSelection.nextMonday;
                                  });
                                }),
                                _buildButton(
                                    "Next Tuesday", _selectedButton == DateSelection.nextTuesday,
                                    () {
                                  setDialogState(() {
                                    tempSelectedDate = _getNextWeekday(DateTime.tuesday);
                                    _selectedButton = DateSelection.nextTuesday;
                                  });
                                }),
                                _buildButton(
                                    "After 1 Week", _selectedButton == DateSelection.afterOneWeek,
                                    () {
                                  setDialogState(() {
                                    tempSelectedDate = DateTime.now().add(Duration(days: 7));
                                    _selectedButton = DateSelection.afterOneWeek;
                                  });
                                }),
                              ],
                            )
                          : GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 5,
                              children: [
                                _buildButton("No Date", _selectedButton == DateSelection.nodate,
                                    () {
                                  setDialogState(() {
                                    tempSelectedDate = null;
                                    _selectedButton = DateSelection.nodate;
                                  });
                                }),
                                _buildButton("Today", _selectedButton == DateSelection.today, () {
                                  setDialogState(() {
                                    tempSelectedDate = DateTime.now();
                                    _selectedButton = DateSelection.today;
                                  });
                                }),
                              ],
                            ),
                      SizedBox(height: 15),

                      // Calendar
                      TableCalendar(
                        focusedDay: tempSelectedDate ?? DateTime.now(),
                        firstDay: widget.joiningDate ? DateTime(2024) : DateTime.now(),
                        lastDay: DateTime(2026),
                        calendarStyle: CalendarStyle(
                          todayTextStyle: TextStyle(
                            color: Colors.blue, // Text color for today's date
                          ),
                          outsideTextStyle: TextStyle(color: Colors.transparent),
                          todayDecoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xff1DA1F2), width: 1),
                          ),
                          selectedDecoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                        weekNumbersVisible: false,
                        headerStyle: HeaderStyle(
                          titleTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          titleCentered: true,
                          formatButtonVisible: false,
                          leftChevronIcon: Icon(Icons.arrow_left_rounded,
                              size: 40,
                              color: widget.joiningDate ? Color(0xff949C9E) : Colors.grey[300]),
                          rightChevronIcon:
                              Icon(Icons.arrow_right_rounded, size: 40, color: Color(0xff949C9E)),
                        ),
                        selectedDayPredicate: (day) => isSameDay(tempSelectedDate, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          setDialogState(() => tempSelectedDate = selectedDay);
                        },
                      ),
                      SizedBox(height: 10),

                      // Selected Date & Action Buttons
                      Divider(height: 3, color: Colors.grey.shade300),
                      SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.date_range_outlined, color: Colors.blue),
                              SizedBox(width: 5),
                              tempSelectedDate == null
                                  ? Text('No date')
                                  : Text(
                                      '${tempSelectedDate!.day} ${_monthName(tempSelectedDate!.month)} ${tempSelectedDate!.year}',
                                    ),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffEDF8FF),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  setState(() => _selectedDate = tempSelectedDate);
                                  widget.onDateSelected(tempSelectedDate);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Finds the date for the next given weekday (Monday, Tuesday, etc.)
  DateTime _getNextWeekday(int weekday) {
    DateTime now = DateTime.now();
    int daysUntilNext = (weekday - now.weekday + 7) % 7;
    return now.add(Duration(days: daysUntilNext == 0 ? 7 : daysUntilNext));
  }

  /// Helper method to create buttons
  Widget _buildButton(String text, bool isActive, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? Colors.blue : Color(0xffEDF8FF),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.blue,
            ),
          ),
        ),
      ),
    );
  }

  /// Convert month number to name
  String _monthName(int month) {
    return [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ][month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCalendarDialog(context),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined, color: Colors.blue),
            SizedBox(width: 8),
            _selectedDate == null
                ? Text(
                    'No date',
                    style: TextStyle(color: Colors.grey),
                  )
                : isSameDay(DateTime.now(), _selectedDate!)
                    ? Text('Today')
                    : Text(
                        formatDate(_selectedDate!),
                        style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                      ),
          ],
        ),
      ),
    );
  }
}
