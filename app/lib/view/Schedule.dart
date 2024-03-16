// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:medicine_reminder/view/widget/MyDrawer.dart';
import 'package:medicine_reminder/view/widget/ScheduleItem.dart';
import 'package:sizer/sizer.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<StatefulWidget> createState() {
    return ScheduleState();
  }

}

class ScheduleState extends State<StatefulWidget> {

  List<ScheduleItem> schedules = [];

  @override
  void initState() {
    super.initState();
    schedules = [
      ScheduleItem(
        time: "07:30",
        typeA: 4,
        typeB: 3,
      ),
      ScheduleItem(
        time: "09:45",
        typeA: 3,
        typeB: 1,
      ),
      ScheduleItem(
        time: "11:20",
        typeA: 2,
        typeB: 5,
      ),
      ScheduleItem(
        time: "17:00",
        typeA: 6,
        typeB: 2,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Schedule list",
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
            margin: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 10.h),
            width: 90.w,
            height: 100.h,
            alignment: Alignment.center,
            child: ListView.builder(
              itemCount: schedules.length,
              itemBuilder: (context, index) => schedules[index],
            )
          ),
        ),
        drawer: MyDrawer(DrawerSelection.schedule),
      ),
    );
  }

}