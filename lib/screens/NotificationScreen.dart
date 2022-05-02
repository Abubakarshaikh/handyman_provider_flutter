import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:handyman_provider_flutter/components/AppWidgets.dart';
import 'package:handyman_provider_flutter/models/NotificationListResponse.dart';
import 'package:handyman_provider_flutter/networks/RestApis.dart';
import 'package:handyman_provider_flutter/utils/Colors.dart';
import 'package:handyman_provider_flutter/utils/Common.dart';
import 'package:handyman_provider_flutter/utils/Constant.dart';
import 'package:handyman_provider_flutter/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:handyman_provider_flutter/extensions/ContextExt.dart';

import '../main.dart';
import 'BookingDetailScreen.dart';

class NotificationScreen extends StatefulWidget {
  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  List<NotificationData> notificationsDataList = [];
  int? unreadNotification;
  bool? showBottomSheet = false;
  ScrollController scrollController = ScrollController();
  int currentPage = 1;
  bool isLastPage = false;
  bool afterInitVisible = false;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      appStore.setLoading(true);
      init();
      scrollController.addListener(() {
        scrollHandler();
      });
    });
  }

  scrollHandler() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !appStore.isLoading) {
      currentPage++;
      init();
    }
  }

  Future<void> init() async {
    getNotificationList();
  }

  Future<void> getNotificationList({String? type = ''}) async {
    Map request = {NotificationKey.type: type, NotificationKey.page: currentPage};
    appStore.setLoading(true);
    await getNotification(request).then((res) async {
      if (!mounted) return;
      setState(() {
        appStore.setLoading(false);
        isLastPage = false;
        if (currentPage == 1) {
          notificationsDataList.clear();
        }
        notificationsDataList.addAll(res.notificationData!);
        unreadNotification = res.allUnreadCount;
      });
      afterInitVisible = true;
      setState(() {});
    }).catchError((e) {
      if (!mounted) return;
      isLastPage = true;
      toast(e.toString(), print: true);
      appStore.setLoading(false);
    });
  }

  Future<void> readNotification({String? id}) async {
    Map request = {CommonKeys.bookingId: id};
    appStore.setLoading(true);
    await bookingDetail(request).then((value) {
      appStore.setLoading(false);
      notificationsDataList.clear();
      getNotificationList();
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
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  static String getTime(String inputString, String time) {
    List<String> wordList = inputString.split(" ");
    if (wordList.isNotEmpty) {
      return wordList[0] + ' ' + time;
    } else {
      return ' ';
    }
  }

  Widget markAllAsReadDialog(bool isMarkRead) {
    return AppButton(
      color: primaryColor,
      text: context.translate.markAsRead,
      textStyle: secondaryTextStyle(color: white, size: 16),
      onTap: () {
        getNotificationList(type: MarkAsRead);
        setState(() {});
        finish(context);
      },
    ).paddingSymmetric(vertical: 8, horizontal: 16);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.cardColor,
        appBar: AppBar(
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          backgroundColor: context.primaryColor,
          title: Row(
            children: [
              16.width,
              Icon(Icons.arrow_back, color: Colors.white, size: 28).onTap(() {
                finish(context, true);
              }),
              8.width,
              Text(context.translate.notification, style: boldTextStyle(size: 18, color: white)),
              8.width,
              if (unreadNotification != 0 && unreadNotification != null)
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: Colors.white),
                  child: Text(unreadNotification.toString(), style: boldTextStyle(color: primaryColor)),
                ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (_) {
                    bool isMarkRead = false;
                    return markAllAsReadDialog(isMarkRead);
                  },
                );
              },
              icon: Icon(AntDesign.setting),
            ),
          ],
        ),
        body: Observer(
          builder: (_) => Stack(
            children: [
              ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.only(right: 16, left: 16, top: 8, /*bottom:showMobileAds==true? 64:*/ bottom: 16),
                itemCount: notificationsDataList.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: context.width(),
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: boxDecorationWithShadow(
                      borderRadius: radius(defaultRadius),
                      blurRadius: 0,
                      backgroundColor: notificationsDataList[index].readAt != null ? context.cardColor : primaryColor.withOpacity(0.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('#${notificationsDataList[index].data!.id.validate()}', style: boldTextStyle()).paddingBottom(8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.access_time_outlined, size: 14, color: Colors.grey),
                                4.width,
                                Text(
                                  notificationsDataList[index].createdAt!.contains('hours')
                                      ? getTime(notificationsDataList[index].createdAt!, 'hr')
                                      : getTime(notificationsDataList[index].createdAt!, 'day'),
                                  style: secondaryTextStyle(),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(notificationsDataList[index].data!.message!, style: secondaryTextStyle()),
                      ],
                    ),
                  ).onTap(
                    () {
                      readNotification(id: notificationsDataList[index].data!.id.toString());
                      appStore.setLoading(false);
                      BookingDetailScreen(bookingId: notificationsDataList[index].data!.id).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                    },
                  );
                },
              ),
              noDataFound().center().visible(notificationsDataList.isEmpty && !appStore.isLoading && afterInitVisible),
              LoaderWidget().center().visible(appStore.isLoading && !afterInitVisible),
              if (showMobileAds && myBanner != null)
                Positioned(
                  child: Container(
                    child: AdWidget(ad: myBanner!),
                    color: context.cardColor,
                    width: context.width(),
                    height: myBanner!.size.height.toDouble(),
                  ),
                  bottom: 0,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
