import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:flutter/material.dart';

class SelectTimeProvider extends ChangeNotifier {
  TimeOfDay _selectedTime = TimeOfDay.now();
  TimeOfDay? _selectedTillTime = TimeOfDay.now();
  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;
  TimeOfDay? get selectedTillTime => _selectedTillTime;
  DateTime? _openTime;
  bool isSelected = false;
  var date = DateTime.now();

  void reset() {
    _selectedTime = TimeOfDay.now();
  }

  Future<Null> pickDate(context) async {
    showDatePicker(
        context: context,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        initialDate: new DateTime.now().add(Duration(days: 1)),
        firstDate: DateTime.now().add(Duration(days: 1)),
        lastDate: DateTime.now().add(Duration(days: 31)),
        builder: (BuildContext context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                      primary: kMainColor,
                      onPrimary: Colors.white,
                      onSurface: kMainColor)),
              child: child!);
        }).then((value) {
      print('date.....$value');
      _selectedDate = value!;
      notifyListeners();
    });
  }

  Future<Null> pickTime(context) async {
    await showTimePicker(
        initialTime: TimeOfDay.now(),
        context: context,
        builder: (BuildContext context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                      primary: kMainColor,
                      onPrimary: Colors.white,
                      onSurface: kMainColor)),
              child: child!);
        }).then((value) {
      if (value == null) {
        reset();
      } else
        _selectedTime = value;

      print(_selectedTime);
      notifyListeners();
    });
  }

  // Future<Null> pickTillTime(context) async {
  //   await showTimePicker(
  //       initialTime: TimeOfDay.now(),
  //       context: context,
  //       builder: (BuildContext context, child) {
  //         return Theme(
  //             data: Theme.of(context).copyWith(
  //                 colorScheme: ColorScheme.light(
  //                     primary: kMainColor,
  //                     onPrimary: Colors.white,
  //                     onSurface: kMainColor)),
  //             child: child!);
  //       }).then((value) {
  //     if (value == null) {
  //       _selectedTillTime = TimeOfDay.now();
  //     } else
  //       _selectedTillTime = value;

  //     print(_selectedTillTime);
  //     notifyListeners();
  //   });
  // }

  Future<Null> pickTillTime(
    context,
    openTime,
  ) async {
    await showTimePicker(
        initialTime: TimeOfDay.now(),
        context: context,
        builder: (BuildContext context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                      primary: kMainColor,
                      onPrimary: Colors.white,
                      onSurface: kMainColor)),
              child: child!);
        }).then((value) {
      if (isSelected == true) {
        _openTime = DateTime(date.year, date.month, date.day,
            _selectedTime.hour, selectedTime!.minute);
      } else {
        _openTime = DateTime.parse('1974-03-20 ${openTime}:00.000');
      }

      var tempTime = DateTime.parse(date.year.toString() +
          "-" +
          date.month.toString().padLeft(2, '0') +
          "-" +
          date.day.toString().padLeft(2, '0') +
          " " +
          value!.hour.toString().padLeft(2, '0') +
          ":" +
          value.minute.toString().padLeft(2, '0'));
      if (tempTime.isBefore(DateTime.parse(date.year.toString() +
              "-" +
              date.month.toString().padLeft(2, '0') +
              "-" +
              date.day.toString().padLeft(2, '0') +
              " " +
              _openTime!.hour.toString().padLeft(2, '0') +
              ":" +
              _openTime!.minute.toString().padLeft(2, '0'))) ||
          tempTime.isAtSameMomentAs(DateTime.parse(date.year.toString() +
              "-" +
              date.month.toString().padLeft(2, '0') +
              "-" +
              date.day.toString().padLeft(2, '0') +
              " " +
              _openTime!.hour.toString().padLeft(2, '0') +
              ":" +
              _openTime!.minute.toString().padLeft(2, '0'))) ||
          tempTime
                  .difference(DateTime.parse(date.year.toString() +
                      "-" +
                      date.month.toString().padLeft(2, '0') +
                      "-" +
                      date.day.toString().padLeft(2, '0') +
                      " " +
                      _openTime!.hour.toString().padLeft(2, '0') +
                      ":" +
                      _openTime!.minute.toString().padLeft(2, '0')))
                  .inHours <
              1) {
        errorDialog(context,
            "Please select a time greater than 1hours from the Shop Opening Time");
        _selectedTillTime =
            TimeOfDay.fromDateTime(_openTime!.add(Duration(hours: 1)));
      } else {
        _selectedTillTime = value;
        print(_selectedTillTime);
      }
      notifyListeners();
    });
  }
}
