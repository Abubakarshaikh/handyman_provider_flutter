import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/AppWidgets.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/screens/LoginScreen.dart';
import 'package:handyman_provider_flutter/utils/Colors.dart';
import 'package:handyman_provider_flutter/utils/Images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:handyman_provider_flutter/extensions/ContextExt.dart';

import 'DashboardScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    //setStatusBarColor(Colors.black12, statusBarIconBrightness: Brightness.dark);
    init();
  }

  Future<void> init() async {
    await 2.seconds.delay;
    if (!appStore.isLoggedIn) {
      LoginScreen().launch(context, isNewTask: true);
      return;
    } else {
      DashboardScreen().launch(context, isNewTask: true);
    }
    bannerAds(context);
    createInterstitialAd();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), blurRadius: 0, backgroundColor: context.cardColor),
              child: Image.asset(splashLogo, height: 90, width: 90, color: primaryColor).center().paddingAll(8),
            ),
            16.height,
            Text(context.translate.appName, style: primaryTextStyle(size: 22)),
          ],
        ),
      ),
    );
  }
}
