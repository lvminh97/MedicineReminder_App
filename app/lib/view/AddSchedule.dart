// ignore_for_file: file_names, use_build_context_synchronously

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medicine_reminder/routes.dart';
import 'package:medicine_reminder/view/widget/MyDrawer.dart';
import 'package:sizer/sizer.dart';

class AddSchedule extends StatefulWidget {
  const AddSchedule({super.key});

  @override
  State<StatefulWidget> createState() {
    return AddScheduleState();
  }

}

class AddScheduleState extends State<StatefulWidget> {

  ValueNotifier<double> typeANtf = ValueNotifier(0), typeBNtf = ValueNotifier(0);
  ValueNotifier<String> timeNtf = ValueNotifier("00:00");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Navigator.pushNamedAndRemoveUntil(context, RoutesName.schedule, (route) => false);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Add new schedule",
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
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  width: 100.w,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 65.w,
                        child: ValueListenableBuilder(
                          valueListenable: timeNtf,
                          builder: (context, value, child) => Text(
                            "Time:         ${timeNtf.value}",
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
                              initialTime: TimeOfDay.fromDateTime(DateTime.parse("2024-01-01 ${timeNtf.value}")),
                              initialEntryMode: TimePickerEntryMode.input
                            )
                            .then((time) {
                              String s = "${time!.hour.toString().padLeft(2, "0")}:${time.minute.toString().padLeft(2, "0")}";
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
                    ]
                  ),
                ),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  width: 100.w,
                  child: ValueListenableBuilder(
                    valueListenable: typeANtf,
                    builder: (context, value, child) => Text(
                      "Type A:      ${typeANtf.value.floor()}",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.black
                      ),
                    ),
                  )
                ),
                SizedBox(height: 2.h),
                ValueListenableBuilder(
                  valueListenable: typeANtf,
                  builder: (context, value, child) => Slider(
                    onChanged: (value) {
                      typeANtf.value = value;
                    },
                    value: typeANtf.value,
                    min: 0,
                    max: 9.1, 
                  ),
                ),
                SizedBox(height: 5.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  width: 100.w,
                  child: ValueListenableBuilder(
                    valueListenable: typeBNtf,
                    builder: (context, value, child) => Text(
                      "Type B:      ${typeBNtf.value.floor()}",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.black
                      ),
                    ),
                  )
                ),
                SizedBox(height: 2.h),
                ValueListenableBuilder(
                  valueListenable: typeBNtf,
                  builder: (context, value, child) => Slider(
                    onChanged: (value) {
                      typeBNtf.value = value;
                    },
                    value: typeBNtf.value,
                    min: 0,
                    max: 9.1, 
                  ),
                ),
                SizedBox(height: 6.h),
                SizedBox(
                  width: 80.w,
                  child: TextButton(
                    onPressed: () async {
                      var sizeRef = FirebaseDatabase.instance.ref("medicine/schedule/size");
                      int size = (await sizeRef.get()).value as int;
                      var schRef = FirebaseDatabase.instance.ref("medicine/schedule/data/$size");
                      await schRef.set({
                        "time": timeNtf.value,
                        "type_a": typeANtf.value.floor(),
                        "type_b": typeBNtf.value.floor()
                      });
                      await sizeRef.set(size + 1);
                      var cmdRef = FirebaseDatabase.instance.ref("medicine/command/cmd");
                      await cmdRef.set("add");                    
                      Fluttertoast.showToast(msg: "Add new schedule successful");
                      Navigator.pushNamedAndRemoveUntil(context, RoutesName.schedule, (route) => false);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 1.5.h)
                    ),
                    child: Text(
                      "Add",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        drawer: MyDrawer(DrawerSelection.schedule),
      ),
    );
  }

}