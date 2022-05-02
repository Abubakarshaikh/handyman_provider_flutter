import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:handyman_provider_flutter/components/AppWidgets.dart';
import 'package:handyman_provider_flutter/components/HomeBottomComponent.dart';
import 'package:handyman_provider_flutter/components/HomeTopComponent.dart';
import 'package:handyman_provider_flutter/models/DashboardData.dart';
import 'package:handyman_provider_flutter/models/DashboardResponse.dart';
import 'package:handyman_provider_flutter/models/NotificationListResponse.dart';
import 'package:handyman_provider_flutter/models/RevenueChartData.dart';
import 'package:handyman_provider_flutter/networks/RestApis.dart';
import 'package:handyman_provider_flutter/screens/NotificationScreen.dart';
import 'package:handyman_provider_flutter/utils/Common.dart';
import 'package:handyman_provider_flutter/utils/Constant.dart';
import 'package:handyman_provider_flutter/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:handyman_provider_flutter/extensions/ContextExt.dart';

import '../main.dart';

class HomeFragment extends StatefulWidget {
  @override
  HomeFragmentState createState() => HomeFragmentState();
}

class HomeFragmentState extends State<HomeFragment> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController searchCont = TextEditingController();
  DashboardResponse? dashboardResponse;

  List<Category>? categoryList = [];
  List<Service>? serviceList = [];
  List<Handyman>? handymanList = [];
  List<DashboardData> dashboardData = [];
  List<Configurations>? configList = [];

  NotificationListResponse? notificationListResponse;
  int unReadCount = 0;

  bool afterInitVisible = false;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      appStore.setLoading(true);
      init();
    });
  }

  Future<void> init() async {
    await getProviderDashboard();
    await getNotificationCount();
  }

  Future<void> getProviderDashboard() async {
    await providerDashboard().then((res) async {
      dashboardResponse = res;
      categoryList = res.category;
      serviceList = res.service;
      handymanList = res.handyman;
      configList = res.configurations;

      configList!.forEach((element) async {
        if (element.key!.contains(CURRENCY_COUNTRY_ID)) {
          await setValue(CURRENCY_COUNTRY_SYMBOL, element.country!.symbol.validate());
          await setValue(CURRENCY_COUNTRY_CODE, element.country!.currencyCode.validate());
        } else {
          await setValue(element.key!, element.value.validate());
        }
      });

      dashboardData = [
        DashboardData(context.translate.lblTotalBooking, dashboardResponse!.totalBooking.toString(), AntDesign.book),
        DashboardData(context.translate.lblTotalService, serviceList!.length.toString(), AntDesign.heart),
        DashboardData(context.translate.lblTotalHandyman, handymanList!.length.toString(), MaterialCommunityIcons.account),
        DashboardData(context.translate.lblTotalRevenue, dashboardResponse!.totalRevenue.validate().toStringAsFixed(2), Fontisto.dollar)
      ];
      afterInitVisible = true;
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
    });
  }

  Future<void> getNotificationCount() async {
    Map request = {NotificationKey.type: ""};
    await getNotification(request).then((value) {
      notificationListResponse = value;
      unReadCount = notificationListResponse!.allUnreadCount!;
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        context.translate.home,
        textColor: white,
        showBack: false,
        color: context.primaryColor,
        elevation: 0,
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                  icon: Icon(MaterialCommunityIcons.bell, size: 24),
                  tooltip: context.translate.notification,
                  onPressed: () async {
                    bool? res = await NotificationScreen().launch(context);
                    if (res ?? false) init();
                  }),
              if (unReadCount != 0)
                Container(
                  margin: EdgeInsets.only(top: 12, right: 8),
                  padding: EdgeInsets.all(4),
                  decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: Colors.red),
                  child: Text(unReadCount.toString(), style: secondaryTextStyle(size: 10, color: white)),
                ),
            ],
          ),
        ],
      ),
      body: Observer(
        builder: (_) => Stack(
          alignment: Alignment.topLeft,
          children: [
            RefreshIndicator(
              onRefresh: () async {
                init();
                await 2.seconds.delay;
                //
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeTopComponent(data: dashboardData, chartData: chartData).visible(afterInitVisible),
                    HomeBottomComponent(
                      categoryData: categoryList,
                      serviceData: serviceList,
                      handymanData: handymanList,
                      onUpdate: () {
                        appStore.setLoading(true);
                        init();
                        setState(() {});
                      },
                    ).visible(afterInitVisible),
                  ],
                ),
              ),
            ),
            LoaderWidget().center().visible(appStore.isLoading && !afterInitVisible),
          ],
        ),
      ),
    );
  }
}
