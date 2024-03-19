// ignore_for_file: file_names

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medicine_reminder/view/widget/MyDrawer.dart';
import 'package:sizer/sizer.dart';

class Time extends StatefulWidget {
  const Time({super.key});

  @override
  State<StatefulWidget> createState() {
    return TimeState();
  }

}

class TimeState extends State<StatefulWidget> {

  ValueNotifier<String> timeNtf = ValueNotifier("00:00:00");
  ValueNotifier<String> dateNtf = ValueNotifier("01/01/2024");

  @override
  void initState() {
    super.initState();

    // var cmdRef = FirebaseDatabase.instance.ref("medicine/command/cmd");
    // cmdRef.onValue.listen((event) {
    //   // String cmd = event.snapshot.value.toString();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Time setting",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white54
          ),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            width: 90.w,
            height: 100.h,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 2.w),
                      width: 65.w,
                      child: ValueListenableBuilder(
                        valueListenable: timeNtf,
                        builder: (context, value, child) => Text(
                          "Time:      ${timeNtf.value}",
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.black
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.w,
                      height: 15.w,
                      child: TextButton(
                        onPressed: () {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                            initialEntryMode: TimePickerEntryMode.input
                          )
                          .then((time) {
                            String s = "${time!.hour.toString().padLeft(2, "0")}:${time.minute.toString().padLeft(2, "0")}:00";
                            timeNtf.value = s;
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(1.w)
                        ),
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Icon(
                            Icons.alarm,
                            size: 30.sp,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 2.w),
                      width: 65.w,
                      child: ValueListenableBuilder(
                        valueListenable: dateNtf,
                        builder: (context, value, child) => Text(
                          "Date:      ${dateNtf.value}",
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.black
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.w,
                      height: 15.w,
                      child: TextButton(
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            firstDate: DateTime.parse("1990-01-01"),
                            lastDate: DateTime.parse("2030-12-31"),
                            initialDate: DateTime.now(),
                            initialEntryMode: DatePickerEntryMode.calendar
                          )
                          .then((date) {
                            String s = "${date!.day.toString().padLeft(2, "0")}/${date.month.toString().padLeft(2, "0")}/${date.year.toString().padLeft(4, "0")}";
                            dateNtf.value = s;
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(1.w)
                        ),
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Icon(
                            Icons.calendar_month,
                            size: 30.sp,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  width: 60.w,
                  child: TextButton(
                    onPressed: () {
                      var cmdRef = FirebaseDatabase.instance.ref("medicine/command/cmd");
                      cmdRef.ref.set("set_rtc");
                      var cmdValueRef = FirebaseDatabase.instance.ref("medicine/command/value");
                      String timeValue = "${timeNtf.value} ${dateNtf.value}";
                      cmdValueRef.set(timeValue);
                      Fluttertoast.showToast(msg: "Set time successfull");
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      backgroundColor: Colors.lightBlueAccent
                    ),
                    child: Text(
                      "Set",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white
                      ),
                    ),
                  ),
                )
              ],
            )
          ),
        ),
        drawer: MyDrawer(DrawerSelection.time),
      ),
    );
  }

}