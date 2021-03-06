import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jalali_table_calendar/jalali_table_calendar.dart';
import 'package:persian_date/persian_date.dart' as pDate;

class CustomCalender extends StatefulWidget {
  const CustomCalender({Key? key}) : super(key: key);

  @override
  _CustomCalenderState createState() => _CustomCalenderState();
}

class _CustomCalenderState extends State<CustomCalender> {

  pDate.PersianDate persianDate = pDate.PersianDate(format: "yyyy/mm/dd  \n DD  , d  MM  ");
  String _datetime = '';
  String _format = 'yyyy-mm-dd';
  String _value = '';
  String _valuePiker = '';
  DateTime selectedDate = DateTime.now();

  Future _selectDate() async {
    String picked = await jalaliCalendarPicker(
        context: context,
        convertToGregorian: false,
        showTimePicker: true,
        hore24Format: true);
    if (picked != null) setState(() => _value = picked);
  }

  DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();
    print(
        "Parse TO Format ${persianDate.gregorianToJalali("2019-02-20T00:19:54.000Z", "yyyy-m-d hh:nn")}");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          jalaliCalendar(
              context: context,
              // add the events for each day
              events: {
                today: ['sample event', 66546],
                today.add(Duration(days: 1)): [6, 5, 465, 1, 66546],
                today.add(Duration(days: 2)): [6, 5, 465, 66546],
              },
              //make marker for every day that have some events
              marker: (date,events){
                return Positioned(
                  top: -4,
                  left: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                        // color: Theme.of(context).textSelectionColor,
                        shape: BoxShape.circle
                    ),
                    padding: const EdgeInsets.all(6.0),
                    child: Text(events.length.toString()),
                  ),
                );
              },
              onDaySelected: (date) {
                print(date);
              }
          ),

        ],
      ),
    );
  }

  void _showDatePicker() async {
    await showDialog(
        context: context,
        builder: (context) => DateRangePickerDialog(
          firstDate: DateTime.now().subtract(const Duration(days: 3650)),
          lastDate: DateTime.now(),
        ));
    const bool showTitleActions = false;
    DatePicker.showDatePicker(context,
        minYear: 1300,
        maxYear: 1450,
        confirm: const Text(
          '??????????',
          style: TextStyle(color: Colors.red),
        ),
        cancel: const Text(
          '??????',
          style: TextStyle(color: Colors.cyan),
        ),
        dateFormat: _format, onChanged: (year, month, day) {
          if (!showTitleActions) {
            _changeDatetime(year, month, day);
          }
        }, onConfirm: (year, month, day) {
          _changeDatetime(year, month, day);
          _valuePiker =
          " ?????????? ???????????? : $_datetime  \n ?????? : $year \n  ?????? :   $month \n  ?????? :  $day";
        });
  }

  void _changeDatetime(int year, int month, int day) {
    setState(() {
      _datetime = '$year-$month-$day';
    });
  }

}
