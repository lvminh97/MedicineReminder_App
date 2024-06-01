// ignore_for_file: file_names

import 'package:firebase_database/firebase_database.dart';
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
  ValueNotifier<int> deviceStatusNtf = ValueNotifier(0);
  int deviceStatus = 0;

  late DatabaseReference deviceStatusRef;
  late DatabaseReference cmdRef;
  int waitingTimer = 0;

  @override
  void initState() {
    super.initState();
    needUpdateTime = true;
    deviceStatusListener();
    comingListener();
    updateTime();
    getDeviceStatus();
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
                SizedBox(height: 10.h),
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
                SizedBox(height: 5.h),
                Row(
                  children: [
                    SizedBox(width: 8.w),
                    SizedBox(
                      width: 40.w,
                      child: Text(
                        "Device status: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                        )
                      )
                    ),
                    SizedBox(
                      width: 32.w,
                      child: ValueListenableBuilder(
                        valueListenable: currentTime,
                        builder: (context, value, child) => Text(
                          deviceStatusNtf.value == 2 ? "Syncing..." : deviceStatusNtf.value == 1 ? "Online" : "Offline",
                          style: TextStyle(
                            color: deviceStatusNtf.value == 2 ? Colors.grey : deviceStatusNtf.value == 1 ? Colors.greenAccent : Colors.red,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12.w,
                      height: 12.w,
                      child: TextButton(
                        onPressed: () async {
                          getDeviceStatus();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green
                        ),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Icon(
                            Icons.refresh,
                            size: 40.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w)
                  ],
                )
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

  void deviceStatusListener() async {
    deviceStatusRef = FirebaseDatabase.instance.ref("medicine/status");
    deviceStatusRef.onValue.listen((event) async {
      deviceStatus = (event.snapshot.value ?? 0) as int;
      if(waitingTimer == 0) {
        deviceStatusNtf.value = deviceStatus;
      }
      else if(deviceStatus == 1) {
        waitingTimer = 1;
      }
    });

    Future.doWhile(() async {
      if(waitingTimer > 0) {
        waitingTimer--;
        if(waitingTimer == 0) {
          deviceStatusNtf.value = deviceStatus;
          await FirebaseDatabase.instance.ref("medicine/command/cmd").set(" ");
        }
      }
      await Future.delayed(const Duration(seconds: 1));
      return true;
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

  void getDeviceStatus() async {
    DatabaseReference cmdRef = FirebaseDatabase.instance.ref("medicine/command/cmd");
    await cmdRef.set("device_status");
    await deviceStatusRef.set(0);
    waitingTimer = 10;
    deviceStatusNtf.value = 2;
  }

}