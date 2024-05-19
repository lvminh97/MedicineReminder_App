// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:medicine_reminder/view/widget/MyDrawer.dart';
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
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Home",
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
            width: 100.w,
            height: 100.h,
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(height: 20.h),
                SizedBox(
                  height: 15.h,
                  child: const Image(
                    image: AssetImage("assets/icon.png"),
                  ),
                ),
                SizedBox(height: 3.h),
                SizedBox(
                  height: 10.h,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      "Automatic Pill Dispenser \nwith Alarm",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                ValueListenableBuilder(
                  valueListenable: currentTime,
                  builder: (context, value, child) => Text(
                    "Current time is: ${currentTime.value}",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        drawer: MyDrawer(DrawerSelection.home),
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
        currentTime.value = DateFormat("HH:mm:ss").format(now);
        await Future.delayed(const Duration(seconds: 1));
        return true;
      }
    });
  }

}