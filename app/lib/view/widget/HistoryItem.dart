// ignore_for_file: file_names, must_be_immutable, use_build_context_synchronously, empty_catches

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HistoryItem extends StatelessWidget {

  BuildContext? parentContext;

  int id = 0;
  String time = "";
  int typeA = 0;
  int typeB = 0;

  HistoryItem({Key? key, this.id = 0, this.time = "", this.typeA = 0, this.typeB = 0, this.parentContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.only(left: 2.w, top: 1.h, right: 2.w, bottom: 1.h),
      width: 100.w,
      height: 7.h,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(2.w)
      ),
      child: Row(
        children: [
          SizedBox(
            width: 72.w,
            child: Row(
              children: [
                SizedBox(width: 5.w),
                Container(
                  alignment: Alignment.centerLeft,
                  width: 25.w,
                  height: 5.h,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      time,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 42.w,
                  height: 5.h,
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
        ],
      )
    );
  }
}