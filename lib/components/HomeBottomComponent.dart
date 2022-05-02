import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:handyman_provider_flutter/components/ServiceComponent.dart';
import 'package:handyman_provider_flutter/models/DashboardResponse.dart';
import 'package:handyman_provider_flutter/extensions/ContextExt.dart';
import 'package:handyman_provider_flutter/screens/CategoryListScreen.dart';
import 'package:handyman_provider_flutter/screens/HandymanListScreen.dart';
import 'package:handyman_provider_flutter/screens/ServiceDetailScreen.dart';
import 'package:handyman_provider_flutter/screens/ServiceListScreen.dart';
import 'package:handyman_provider_flutter/utils/Colors.dart';
import 'package:handyman_provider_flutter/utils/Common.dart';
import 'package:handyman_provider_flutter/utils/Constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'AppWidgets.dart';

class HomeBottomComponent extends StatefulWidget {
  final List<Category>? categoryData;
  final List<Service>? serviceData;
  final List<Handyman>? handymanData;
  final Function? onUpdate;

  HomeBottomComponent({this.categoryData, this.serviceData, this.handymanData, this.onUpdate});

  @override
  HomeBottomComponentState createState() => HomeBottomComponentState();
}

class HomeBottomComponentState extends State<HomeBottomComponent> {
  List<Category>? categoryList = [];
  List<Service>? serviceList = [];
  List<Handyman>? handymanList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    categoryList = widget.categoryData;
    serviceList = widget.serviceData;
    handymanList = widget.handymanData;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.translate.category, style: boldTextStyle(size: 18)),
            Text(context.translate.viewAll, style: secondaryTextStyle()).onTap(() {
              CategoryListScreen().launch(context);
            }),
          ],
        ).paddingSymmetric(horizontal: 16, vertical: 8).visible(categoryList!.isNotEmpty),
        HorizontalList(
            itemCount: categoryList!.length,
            spacing: 16,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemBuilder: (_, i) {
              return Column(
                children: [
                  Container(
                    width: 110,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(),
                        blurRadius: 0.5, backgroundColor: appStore.isDarkMode ? context.cardColor : secondaryPrimaryColor, offset: Offset(1, 2.5)),
                    child: Column(
                      children: [
                        Image.network(categoryList![i].categoryImage != '' ? categoryList![i].categoryImage.validate() : '', height: 55, width: 55, color: primaryColor, fit: BoxFit.cover)
                            .paddingAll(4.0),
                        8.height,
                        Text(categoryList![i].name.validate(), style: boldTextStyle(size: 12), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ).onTap(() async {
                    bool? res = await ServiceListScreen(categoryId: categoryList![i].id!, categoryName: categoryList![i].name!).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                    if (res ?? true) {
                      appStore.setLoading(true);
                      widget.onUpdate?.call();
                      setState(() {});
                    }
                  }),
                ],
              );
            }).visible(categoryList!.isNotEmpty),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.translate.lblService, style: boldTextStyle(size: 18)),
            if (serviceList!.length > 4)
              Text(context.translate.viewAll, style: secondaryTextStyle()).onTap(() {
                ServiceListScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
              }),
          ],
        ).paddingSymmetric(horizontal: 16, vertical: 8).visible(serviceList!.isNotEmpty),
        HorizontalList(
            itemCount: serviceList!.length,
            spacing: 16,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemBuilder: (_, i) {
              return Container(
                // margin: EdgeInsets.all(8),
                width: context.width() * 0.8,
                decoration: boxDecorationRoundedWithShadow(12, backgroundColor: context.cardColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      overflow: Overflow.visible,
                      children: [
                        serviceList![i].attchments!.isNotEmpty
                            ? cachedImage(serviceList![i].attchments!.first != '' ? serviceList![i].attchments!.first.validate() : '', height: 180, width: context.width() * 0.8, fit: BoxFit.cover)
                                .cornerRadiusWithClipRRectOnly(topRight: 12, topLeft: 12)
                            : cachedImage('', height: 150, width: context.width(), fit: BoxFit.cover).cornerRadiusWithClipRRect(12),
                        Positioned(
                          bottom: -10,
                          left: 8,
                          right: 8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                constraints: BoxConstraints(maxWidth: context.width() * 0.55),
                                decoration: boxDecorationWithShadow(backgroundColor: primaryColor, borderRadius: radius(4)),
                                child: Text(serviceList![i].name.validate(), style: boldTextStyle(color: white, size: 14), maxLines: 1).paddingSymmetric(horizontal: 8, vertical: 4),
                              ),
                              8.width,
                            ],
                          ),
                        ),
                        Positioned(
                          top: 20,
                          right: 0,
                          child: serviceList![i].price != null
                              ? Container(
                                  decoration: boxDecorationWithRoundedCorners(
                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), topLeft: Radius.circular(12)), backgroundColor: context.cardColor),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(serviceList![i].priceFormat!.toString().validate(), style: boldTextStyle(color: primaryColor, size: 16)).paddingSymmetric(horizontal: 10, vertical: 4),
                                      serviceList![i].discount != null
                                          ? Text(serviceList![i].discount!.toString().validate() + '% off', style: boldTextStyle(size: 14)).paddingOnly(left: 10, right: 10, bottom: 4)
                                          : SizedBox(),
                                    ],
                                  ),
                                )
                              : SizedBox(),
                        )
                      ],
                    ),
                    16.height.visible(serviceList![i].description.validate().isNotEmpty),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(serviceList![i].description.validate().capitalizeFirstLetter(), style: secondaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis)
                            .paddingOnly(left: 8, right: 8, bottom: 8)
                            .expand(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: boxDecorationDefault(color: getRateColor(serviceList![i].totalRating!)),
                          child: Row(
                            children: [
                              Icon(Icons.star_border, size: 14, color: white),
                              4.width,
                              Text(serviceList![i].totalRating!.toString(), style: primaryTextStyle(color: white)),
                            ],
                          ),
                        ).paddingOnly(right: 8).visible(serviceList![i].totalRating! != 0),
                      ],
                    ),
                  ],
                ),
              ).onTap(() async {
                bool? res = await ServiceDetailScreen(serviceId: serviceList![i].id.validate()).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                if (res ?? true) appStore.setLoading(false);
                widget.onUpdate?.call();
                setState(() {});
              });
            }).visible(serviceList!.isNotEmpty),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.translate.handyman, style: boldTextStyle()),
            if (handymanList!.length > 4)
              Text(context.translate.viewAll, style: secondaryTextStyle()).onTap(() {
                HandymanListScreen().launch(context);
              }),
          ],
        ).paddingOnly(left: 16, right: 16, top: 8, bottom: 8).visible(handymanList!.isNotEmpty),
        HorizontalList(
            itemCount: handymanList!.length,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            spacing: 8,
            itemBuilder: (_, i) {
              return Container(
                width: 130,
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.only(right: 8),
                decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), backgroundColor: context.cardColor, blurRadius: 0.5, offset: Offset(1, 1)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        decoration: boxDecorationWithRoundedCorners(borderRadius: radius(50), backgroundColor: appStore.isDarkMode ? context.cardColor : secondaryPrimaryColor),
                        child: cachedImage(handymanList![i].profileImage!.isNotEmpty ? handymanList![i].profileImage.validate() : '', width: 75, height: 75, fit: BoxFit.cover)
                            .cornerRadiusWithClipRRect(40)),
                    8.height,
                    Text(handymanList![i].displayName.validate(), style: boldTextStyle(size: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                    8.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if(handymanList![i].contactNumber!=null)
                        Icon(Icons.call_outlined, color: context.iconColor, size: 18).onTap(() {
                          launchUrl(TEL + handymanList![i].contactNumber.validate());
                        }).visible(handymanList![i].contactNumber!.isNotEmpty),
                        if(handymanList![i].email!=null)
                        Icon(Icons.email_outlined, color: context.iconColor, size: 18).onTap(() {
                          launchUrl('mailto:' + handymanList![i].email.validate());
                        }).visible(handymanList![i].email!.isNotEmpty),
                        if(handymanList![i].address!=null)
                        Icon(Icons.location_on_outlined, color: context.iconColor, size: 18).onTap(() {
                          launchMap(handymanList![i].address.validate());
                        }).visible(handymanList![i].address.validate().isNotEmpty),
                      ],
                    ),
                  ],
                ),
              );
            }).visible(handymanList!.isNotEmpty),
        16.height,
      ],
    );
  }
}
