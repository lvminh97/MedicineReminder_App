// ignore_for_file: file_names, must_be_immutable, use_build_context_synchronously, empty_catches

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medicine_reminder/routes.dart';
import 'package:sizer/sizer.dart';

class ScheduleItem extends StatelessWidget {

  BuildContext? parentContext;

  int id = 0;
  String time = "";
  int typeA = 0;
  int typeB = 0;

  ScheduleItem({Key? key, this.id = 0, this.time = "", this.typeA = 0, this.typeB = 0, this.parentContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.only(left: 2.w, top: 1.h, right: 2.w, bottom: 1.h),
      width: 100.w,
      height: 12.h,
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(2.w)
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60.w,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 0.5.h),
                  alignment: Alignment.centerLeft,
                  width: 55.w,
                  height: 5.h,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      time,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 55.w,
                  height: 3.5.h,
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      "Type A: ${typeA.toString()}     Type B: ${typeB.toString()}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white
                      ),
                    ),
                  ),
                )
              ]
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 0.5.w, bottom: 1.h),
            width: 12.w,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, RoutesName.editSchedule, (route) => false, arguments: {
                  "schedule": this
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orangeAccent),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                padding: MaterialStateProperty.all(EdgeInsets.only(top: 1.5.h, bottom: 1.5.h)),
                alignment: Alignment.center
              ),
              child: Icon(Icons.edit, color: Colors.white, size: 3.h,)
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 0.5.w, bottom: 1.h),
            width: 12.w,
            child: TextButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: Text(
                      "Do you want to delete this schedule?",
                      style: TextStyle(
                        fontSize: 16.sp
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(parentContext!);
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey
                          ),
                        )
                      ),
                      TextButton(
                        onPressed: () async {
                          List<ScheduleItem> scheduleList = [];
                          var scheduleDataRef = FirebaseDatabase.instance.ref("medicine/schedule/data");
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
                          var schRef = FirebaseDatabase.instance.ref("medicine/schedule/data/$id");
                          await schRef.remove();
                          // arrange the array                          
                          scheduleList.removeAt(id);
                          await FirebaseDatabase.instance.ref("medicine/schedule/data").set({});
                          for(int i = 0; i < scheduleList.length; i++) {
                            await FirebaseDatabase.instance.ref("medicine/schedule/data/$i").set({
                              "time": scheduleList[i].time,
                              "type_a": scheduleList[i].typeA,
                              "type_b": scheduleList[i].typeB
                            });
                          }  
                          var sizeRef = FirebaseDatabase.instance.ref("medicine/schedule/size");
                          int size = (await sizeRef.get()).value as int;
                          await sizeRef.set(size - 1);
                          var cmdRef = FirebaseDatabase.instance.ref("medicine/command/cmd");
                          await cmdRef.set("delete");

                          Navigator.pop(parentContext!);
                          Fluttertoast.showToast(msg: "Delete the schedule successful");
                        },
                        child: const Text(
                          "Delete",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.lightBlueAccent
                          ),
                        )
                      )
                    ],
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                padding: MaterialStateProperty.all(EdgeInsets.only(top: 1.5.h, bottom: 1.5.h)),
                alignment: Alignment.center
              ),
              child: Icon(Icons.delete, color: Colors.white, size: 3.h)
            ),
          )
        ],
      )
    );
  }
}