// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

enum DrawerSelection {home, schedule, time}

class MyDrawer extends StatelessWidget{

  DrawerSelection _drawerSelection = DrawerSelection.home;

  MyDrawer(DrawerSelection selection, {Key? key}) : super(key: key){
    _drawerSelection = selection;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            selected: _drawerSelection == DrawerSelection.home,
            title: const Text("Home"),
            leading: const Icon(Icons.home, size: 25),
            onTap: () {
              if(_drawerSelection != DrawerSelection.home){
                
              }
            },
          ),
          ListTile(
            selected: _drawerSelection == DrawerSelection.schedule,
            title: const Text("Schedule"),
            leading: const Icon(Icons.workspaces, size: 25),
            onTap: () {
              if(_drawerSelection != DrawerSelection.schedule){

              }
            },
          ),
          ListTile(
            selected: _drawerSelection == DrawerSelection.time,
            title: const Text("Time"),
            leading: const Icon(Icons.settings, size: 25),
            onTap: () {
              if(_drawerSelection != DrawerSelection.time){
                
              }
            },
          ),
        ],
      ),
    );
  }
}