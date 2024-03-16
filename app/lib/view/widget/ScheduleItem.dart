// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ScheduleItem extends StatelessWidget {

  String _time = "";
  int _typeA = 0;
  int _typeB = 0;

  ScheduleItem({Key? key, String time = "", int typeA = 0, int typeB = 0}) : super(key: key) {
    _time = time;
    _typeA = typeA;
    _typeB = typeB;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.only(left: 2.w, top: 1.h, right: 2.w, bottom: 1.h),
      width: 100.w,
      height: 10.h,
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
                  width: 55.w,
                  child: Text(
                    _time,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                      color: Colors.white
                    ),
                  ),
                ),
                SizedBox(
                  width: 55.w,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Type A: ${_typeA.toString()}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white
                          ),
                        )
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Type B: ${_typeB.toString()}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white
                          ),
                        )
                      )
                    ],
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