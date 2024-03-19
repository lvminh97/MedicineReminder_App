// ignore_for_file: file_names

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medicine_reminder/routes.dart';
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

  List<ScheduleItem> scheduleList = [];
  ValueNotifier<int> scheduleSizeNtf = ValueNotifier(0);
  late DatabaseReference scheduleSizeRef, scheduleDataRef; 

  @override
  void initState() {
    super.initState();
    
    scheduleDataRef = FirebaseDatabase.instance.ref("medicine/schedule/data");
    scheduleDataRef.onValue.listen((event) async {
      scheduleList = [];
      var schData = (await scheduleDataRef.get()).value as Map;
      for(String key in schData.keys) {
        var schRef = FirebaseDatabase.instance.ref("medicine/schedule/data/$key");
        var schMap = (await schRef.get()).value as Map;
        var schedule = ScheduleItem(
          id: key,
          time: schMap["time"],
          typeA: schMap["type_a"],
          typeB: schMap["type_b"]
        );
        scheduleList.add(schedule);
        scheduleList.sort((a, b) => a.time.compareTo(b.time));
      }
      scheduleSizeNtf.value = scheduleList.length;
    });
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
            height: 80.h,
            alignment: Alignment.center,
            child: ValueListenableBuilder(
              valueListenable: scheduleSizeNtf,
              builder: (context, value, child) => ListView.builder(
                itemCount: scheduleSizeNtf.value,
                itemBuilder: (context, index) => scheduleList[index],
              ),
            )
          ),
        ),
        drawer: MyDrawer(DrawerSelection.schedule),
        floatingActionButton: SizedBox(
          width: 14.w,
          height: 14.w,
          child: TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, RoutesName.addSchedule, (route) => false);
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

}