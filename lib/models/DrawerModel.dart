import 'package:flutter/material.dart';

class DrawerModel {
  String? title;
  IconData? icon;
  Widget? ontap;
  bool? selected;

  DrawerModel({this.title, this.icon, this.ontap,this.selected});
}
