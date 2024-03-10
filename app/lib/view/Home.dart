// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }

}

class HomeState extends State<StatefulWidget> {

  bool needUpdateTime = false;
  ValueNotifier<String> currentTime = ValueNotifier<String>("");

  @override
  void initState() {
    super.initState();
    needUpdateTime = true;
    updateTime();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white54
          ),
          child: Container(
            width: 100.w,
            height: 100.h,
            alignment: Alignment.center,
            child: ValueListenableBuilder(
              valueListenable: currentTime,
              builder: (context, value, child) => Text(
                "Current time is: ${currentTime.value}",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        )
      ),
    );
  }

  void updateTime() {
    Future.doWhile(() async {
      if(!needUpdateTime) {
        return false;
      } 
      else {
        DateTime now = DateTime.now();
        currentTime.value = DateFormat("kk:mm:ss").format(now);
        await Future.delayed(const Duration(seconds: 1));
        return true;
      }
    });
  }

}