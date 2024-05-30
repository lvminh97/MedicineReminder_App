// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:medicine_reminder/routes.dart';
import 'package:sizer/sizer.dart';

enum DrawerSelection {home, schedule, time, history}

class MyDrawer extends StatelessWidget{

  DrawerSelection _drawerSelection = DrawerSelection.home;

  MyDrawer(DrawerSelection selection, {Key? key}) : super(key: key){
    _drawerSelection = selection;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero
      ),
      child: ListView(
        padding: const EdgeInsets.only(top: 0),
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blueAccent
            ),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "Medicine Reminder",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp
                ),
              ),
            )
          ),
          ListTile(
            selected: _drawerSelection == DrawerSelection.home,
            selectedColor: Colors.blueAccent,
            title: const Text("Home"),
            leading: Icon(Icons.home, size: 20.sp),
            onTap: () {
              if(_drawerSelection != DrawerSelection.home){
                Navigator.pushNamedAndRemoveUntil(context, RoutesName.home, (route) => false);
              }
              else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            selected: _drawerSelection == DrawerSelection.schedule,
            selectedColor: Colors.blueAccent,
            title: const Text("Schedule list"),
            leading: Icon(Icons.list, size: 20.sp),
            onTap: () {
              if(_drawerSelection != DrawerSelection.schedule){
                Navigator.pushNamedAndRemoveUntil(context, RoutesName.schedule, (route) => false);
              }
              else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            selected: _drawerSelection == DrawerSelection.time,
            selectedColor: Colors.blueAccent,
            title: const Text("Time setting"),
            leading: Icon(Icons.timer, size: 20.sp),
            onTap: () {
              if(_drawerSelection != DrawerSelection.time){
                Navigator.pushNamedAndRemoveUntil(context, RoutesName.time, (route) => false);
              }
              else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            selected: _drawerSelection == DrawerSelection.history,
            selectedColor: Colors.blueAccent,
            title: const Text("History"),
            leading: Icon(Icons.history, size: 20.sp),
            onTap: () {
              if(_drawerSelection != DrawerSelection.history){
                Navigator.pushNamedAndRemoveUntil(context, RoutesName.history, (route) => false);
              }
              else {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}