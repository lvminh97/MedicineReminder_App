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

  List<TextEditingController> timeEditControllers = [];

  @override
  void initState() {
    super.initState();
    for(int i = 0; i < 6; i++) {
      timeEditControllers.add(TextEditingController());
    }

    // FirebaseAuth.instance.signInWithEmailAndPassword(email: "medicine@mail.com", password: "12345678");
    var cmdRef = FirebaseDatabase.instance.ref("medicine/command/cmd");
    cmdRef.onValue.listen((event) {
      String cmd = event.snapshot.value.toString();
      print("Receive command: $cmd");
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
                      width: 20.w,
                      child: Text(
                        "Time",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black
                        ),
                      ),
                    ),
                    Container(
                      width: 20.w,
                      height: 6.h,
                      alignment: Alignment.center,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        controller: timeEditControllers[0],
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3.h),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 5.0,
                              color: Colors.grey
                            )
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 2.0,
                              color: Colors.grey
                            )
                          ),
                          counterStyle: const TextStyle(height: double.minPositive),
                          counterText: "",
                          hintText: "00"
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                          color: Colors.black
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: 3.w,
                      alignment: Alignment.center,
                      child: Text(
                        ":",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                          color: Colors.black
                        ),
                      ),
                    ),
                    Container(
                      width: 20.w,
                      height: 6.h,
                      alignment: Alignment.center,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        controller: timeEditControllers[1],
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3.h),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 5.0,
                              color: Colors.grey
                            )
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 2.0,
                              color: Colors.grey
                            )
                          ),
                          counterStyle: const TextStyle(height: double.minPositive),
                          counterText: "",
                          hintText: "00"
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                          color: Colors.black
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: 3.w,
                      alignment: Alignment.center,
                      child: Text(
                        ":",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                          color: Colors.black
                        ),
                      ),
                    ),
                    Container(
                      width: 20.w,
                      height: 6.h,
                      alignment: Alignment.center,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        controller: timeEditControllers[2],
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3.h),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 5.0,
                              color: Colors.grey
                            )
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 2.0,
                              color: Colors.grey
                            )
                          ),
                          counterStyle: const TextStyle(height: double.minPositive),
                          counterText: "",
                          hintText: "00"
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                          color: Colors.black
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 2.w),
                      width: 20.w,
                      child: Text(
                        "Date",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black
                        ),
                      ),
                    ),
                    Container(
                      width: 20.w,
                      height: 6.h,
                      alignment: Alignment.center,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        controller: timeEditControllers[3],
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3.h),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 5.0,
                              color: Colors.grey
                            )
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 2.0,
                              color: Colors.grey
                            )
                          ),
                          counterStyle: const TextStyle(height: double.minPositive),
                          counterText: "",
                          hintText: "00"
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                          color: Colors.black
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: 3.w,
                      alignment: Alignment.center,
                      child: Text(
                        "/",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                          color: Colors.black
                        ),
                      ),
                    ),
                    Container(
                      width: 20.w,
                      height: 6.h,
                      alignment: Alignment.center,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        controller: timeEditControllers[4],
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3.h),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 5.0,
                              color: Colors.grey
                            )
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 2.0,
                              color: Colors.grey
                            )
                          ),
                          counterStyle: const TextStyle(height: double.minPositive),
                          counterText: "",
                          hintText: "00"
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                          color: Colors.black
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: 3.w,
                      alignment: Alignment.center,
                      child: Text(
                        "/",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                          color: Colors.black
                        ),
                      ),
                    ),
                    Container(
                      width: 20.w,
                      height: 6.h,
                      alignment: Alignment.center,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        controller: timeEditControllers[5],
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3.h),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 5.0,
                              color: Colors.grey
                            )
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 2.0,
                              color: Colors.grey
                            )
                          ),
                          counterStyle: const TextStyle(height: double.minPositive),
                          counterText: "",
                          hintText: "0000"
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                          color: Colors.black
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 5.h),
                SizedBox(
                  width: 60.w,
                  child: TextButton(
                    onPressed: () {
                      var cmdRef = FirebaseDatabase.instance.ref("medicine/command/cmd");
                      cmdRef.ref.set("set_rtc");
                      var cmdValueRef = FirebaseDatabase.instance.ref("medicine/command/value");
                      String timeValue = "${timeEditControllers[0].text}:${timeEditControllers[1].text}:${timeEditControllers[2].text}";
                      timeValue += " ${timeEditControllers[3].text}/${timeEditControllers[4].text}/${timeEditControllers[5].text}";
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
                        fontSize: 14.sp,
                        color: Colors.black
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