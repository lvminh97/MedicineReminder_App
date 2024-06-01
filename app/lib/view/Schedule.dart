// ignore_for_file: file_names, use_build_context_synchronously

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
  late DatabaseReference cmdRef;

  @override
  void initState() {
    super.initState();
    scheduleListener();
    comingListener();
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

  void scheduleListener() async {
    scheduleDataRef = FirebaseDatabase.instance.ref("medicine/schedule/data");
    scheduleDataRef.onValue.listen((event) async {
      scheduleList = [];
      var schData = ((await scheduleDataRef.get()).value ?? []) as List;
      for(int i = 0; i < schData.length; i++) {
        var schedule = ScheduleItem(
          id: i,
          time: schData[i]["time"],
          typeA: schData[i]["type_a"],
          typeB: schData[i]["type_b"],
          parentContext: context,
        );
        scheduleList.add(schedule);
      }
      scheduleSizeNtf.value = scheduleList.length;
    });
  }

  void comingListener() async {
    cmdRef = FirebaseDatabase.instance.ref("medicine/command/cmd");
    cmdRef.onValue.listen((event) async {
      String cmd = event.snapshot.value as String;
      if(cmd == "coming") {
        await cmdRef.set(" ");
        String cmdValue = (await FirebaseDatabase.instance.ref("medicine/command/value").get()).value as String;
        String time = cmdValue.substring(0, 5);
        int type = int.parse(cmdValue.substring(6));
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Notice"),
            titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: Colors.black
            ),
            content: Text(
              "It's time for medicine\nTime: $time\nType A: ${type & 0x0F}  Type B: ${(type >> 4) & 0x0F}",
              style: TextStyle(
                  fontSize: 13.sp
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: Colors.blueAccent
                    ),
                  )
              ),
            ],
          ),
        );
      }
    });
  }

}