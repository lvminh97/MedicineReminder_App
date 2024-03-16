import 'package:flutter/material.dart';
import 'package:medicine_reminder/view/AddSchedule.dart';
import 'package:medicine_reminder/view/Home.dart';
import 'package:medicine_reminder/view/Schedule.dart';
import 'package:medicine_reminder/view/Splash.dart';
import 'package:medicine_reminder/view/Time.dart';

class MyRoutes {
  static final Map<String, Widget Function(BuildContext)> _routes = {
    RoutesName.splash: (context) => const Splash(),
    RoutesName.home: (context) => const Home(),
    RoutesName.schedule: (context) => const Schedule(),
    RoutesName.time: (context) => const Time(),
    RoutesName.addSchedule: (context) => const AddSchedule()
  };
  static const String _init = RoutesName.splash;

  static Map<String, Widget Function(BuildContext)> getRoutes(){
    return _routes;
  }

  static String getInit(){
    return _init;
  }
}

class RoutesName {
  static const String splash = "/splash";
  static const String home = "/home";
  static const String schedule = "/schedule";
  static const String time = "/time";
  static const String addSchedule = "/add_schedule";
}