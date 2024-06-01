// ignore_for_file: file_names, use_build_context_synchronously

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medicine_reminder/view/widget/HistoryItem.dart';
import 'package:medicine_reminder/view/widget/MyDrawer.dart';
import 'package:sizer/sizer.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<StatefulWidget> createState() {
    return HistoryState();
  }

}

class HistoryState extends State<StatefulWidget> {

  List<HistoryItem> historyList = [];
  ValueNotifier<int> historySizeNtf = ValueNotifier(0);
  late DatabaseReference historySizeRef, historyDataRef;
  late DatabaseReference cmdRef;

  @override
  void initState() {
    super.initState();
    historyListener();
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
            "History",
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
                valueListenable: historySizeNtf,
                builder: (context, value, child) => ListView.builder(
                  itemCount: historySizeNtf.value,
                  itemBuilder: (context, index) => historyList[index],
                ),
              )
          ),
        ),
        drawer: MyDrawer(DrawerSelection.schedule),
        floatingActionButton: SizedBox(
          width: 14.w,
          height: 14.w,
          child: TextButton(
            onPressed: () async {
              await FirebaseDatabase.instance.ref("medicine/history/data").set({});
              await FirebaseDatabase.instance.ref("medicine/history/size").set(0);
            },
            style: TextButton.styleFrom(
                backgroundColor: Colors.red
            ),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void historyListener() async {
    historyDataRef = FirebaseDatabase.instance.ref("medicine/history/data");
    historyDataRef.onValue.listen((event) async {
      historyList = [];
      var hisData = ((await historyDataRef.get()).value ?? []) as List;
      for(int i = 0; i < hisData.length; i++) {
        var history = HistoryItem(
          id: i,
          time: hisData[i]["time"],
          typeA: hisData[i]["type_a"],
          typeB: hisData[i]["type_b"],
          parentContext: context,
        );
        historyList.add(history);
      }
      historySizeNtf.value = historyList.length;
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