import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:handyman_provider_flutter/Fragments/BookingFragment.dart';
import 'package:handyman_provider_flutter/Fragments/ChatFragment.dart';
import 'package:handyman_provider_flutter/Fragments/PaymentFragment.dart';
import 'package:handyman_provider_flutter/Fragments/HomeFragment.dart';
import 'package:handyman_provider_flutter/Fragments/ProfileFragment.dart';
import 'package:handyman_provider_flutter/utils/Colors.dart';
import 'package:handyman_provider_flutter/utils/Constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class DashboardScreen extends StatefulWidget {
  final int? index;

  DashboardScreen({this.index});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  List<Widget> fragmentList = [
    HomeFragment(),
    BookingFragment(),
    PaymentFragment(),
    ChatFragment(),
    ProfileFragment(),
  ];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    afterBuildCreated(() async {
      await Future.delayed(Duration(milliseconds: 400));

      if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem) {
        appStore.setDarkMode(context.platformBrightness() == Brightness.dark);
      }

      window.onPlatformBrightnessChanged = () async {
        if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem) {
          appStore.setDarkMode(context.platformBrightness() == Brightness.light);
        }
      };
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: fragmentList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(AntDesign.home, color: Colors.grey.shade400),
            label: '',
            activeIcon: Column(
              children: [
                Icon(AntDesign.home, color: primaryColor),
                6.height,
                Container(width: 25, height: 4, color: primaryColor).cornerRadiusWithClipRRect(8),
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(AntDesign.book, color: Colors.grey.shade400),
            label: '',
            activeIcon: Column(
              children: [
                Icon(AntDesign.book, color: primaryColor),
                6.height,
                Container(width: 25, height: 4, color: primaryColor).cornerRadiusWithClipRRect(8),
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(AntDesign.creditcard, color: Colors.grey.shade400),
            label: '',
            activeIcon: Column(
              children: [
                Icon(AntDesign.creditcard, color: primaryColor),
                6.height,
                Container(width: 25, height: 4, color: primaryColor).cornerRadiusWithClipRRect(8),
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.ios_chatbox_outline, color: Colors.grey.shade400),
            label: '',
            activeIcon: Column(
              children: [
                Icon(Ionicons.ios_chatbox_outline, color: primaryColor),
                6.height,
                Container(width: 25, height: 4, color: primaryColor).cornerRadiusWithClipRRect(8),
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Feather.user, color: Colors.grey.shade400),
            label: '',
            activeIcon: Column(
              children: [
                Icon(Feather.user, color: primaryColor),
                6.height,
                Container(width: 25, height: 4, color: primaryColor).cornerRadiusWithClipRRect(8),
              ],
            ),
          ),
        ],
        onTap: (index) {
          currentIndex = index;
          setState(() {});
        },
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
