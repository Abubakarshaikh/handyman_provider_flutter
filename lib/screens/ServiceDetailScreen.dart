import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/AppWidgets.dart';
import 'package:handyman_provider_flutter/models/ServiceDetailResponse.dart';
import 'package:handyman_provider_flutter/networks/RestApis.dart';
import 'package:handyman_provider_flutter/utils/Colors.dart';
import 'package:handyman_provider_flutter/utils/Constant.dart';
import 'package:handyman_provider_flutter/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:handyman_provider_flutter/extensions/ContextExt.dart';

import '../main.dart';
import 'AddServiceScreen.dart';
import 'ZoomImageScreen.dart';

class ServiceDetailScreen extends StatefulWidget {
  final int? serviceId;

  ServiceDetailScreen({this.serviceId});

  @override
  ServiceDetailScreenState createState() => ServiceDetailScreenState();
}

class ServiceDetailScreenState extends State<ServiceDetailScreen> {
  TextEditingController reviewCont = TextEditingController();

  ServiceDetailResponse serviceDetailData = ServiceDetailResponse();
  ServiceDetail serviceDetail = ServiceDetail();

  PageController _pageController = PageController(initialPage: 0);
  int selectIndex = 0;
  List<String> galleryImages = [];
  List<String> addressList = [];

  int _itemCount = 1;
  bool isExpanded = false;
  double ratings = 0.0;
  num discountPrice = 0;
  num totalAmount = 0;

  @override
  void initState() {
    super.initState();
    setStatusBarColor(Colors.transparent);
    afterBuildCreated(() {
      init();
    });
  }

  Future<void> init() async {
    appStore.isLoading = true;

    Map req = {
      CommonKeys.serviceId: widget.serviceId,
    };
    getServiceDetail(req).then((value) {
      appStore.isLoading = false;
      serviceDetailData = value;
      serviceDetailData.service_detail!.service_address_mapping!.map((e) {
        addressList.add(e.provider_address_mapping!.address.validate());
      }).toList();
      galleryImages.addAll(serviceDetailData.service_detail!.attchments.validate());

      setState(() {});
    }).catchError((e) {
      appStore.isLoading = false;
      toast(e.toString(), print: true);
    });
  }

  void totalPayment() async {
    if (serviceDetailData.service_detail!.discount != null) {
      totalAmount = (serviceDetailData.service_detail!.price!.validate() * _itemCount) -
          (((serviceDetailData.service_detail!.price! * _itemCount) * (serviceDetailData.service_detail!.discount.validate())) / 100);
      discountPrice = serviceDetailData.service_detail!.price.validate() * _itemCount - totalAmount;
    } else {
      totalAmount = (serviceDetailData.service_detail!.price! * _itemCount);
    }

    setState(() {});
  }

  removeService() {
    deleteService(serviceDetailData.service_detail!.id.validate()).then((value) {
      appStore.setLoading(true);
      finish(context, true);
    }).catchError((e) {
      appStore.isLoading = false;
      toast(e.toString(), print: true);
    });
  }

  @override
  void dispose() {
    super.dispose();
    setStatusBarColor(Colors.transparent);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget durationWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.translate.hintDuration, style: boldTextStyle()),
        16.height,
        Container(
          padding: EdgeInsets.all(16),
          decoration: boxDecorationDefault(color: context.cardColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.translate.lblTime, style: primaryTextStyle()),
              8.height,
              Text('${serviceDetailData.service_detail!.duration.validate()} hr', style: boldTextStyle(color: primaryColor)),
            ],
          ),
        ),
        16.height,
      ],
    ).visible(serviceDetailData.service_detail!.duration != null);
  }

  Widget serviceAddressWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.translate.lblAvailableAddress, style: boldTextStyle()),
          ],
        ),
        8.height,
        Wrap(
          children: addressList.map((e) {
            return Container(
              margin: EdgeInsets.only(left: 8, top: 8, bottom: 8),
              padding: EdgeInsets.all(8),
              decoration: boxDecorationWithRoundedCorners(borderRadius: radius(8), backgroundColor: context.cardColor, border: Border.all(width: 1, color: textSecondaryColor.withOpacity(0.3))),
              child: Text(e.validate(), style: secondaryTextStyle(size: 16)),
            );
          }).toList(),
        ),
        16.height,
      ],
    ).paddingSymmetric(horizontal: 16);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: serviceDetailData.service_detail != null
              ? NestedScrollView(
                  headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        elevation: 0,
                        automaticallyImplyLeading: false,
                        leading: Container(
                                margin: EdgeInsets.all(8),
                                decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.scaffoldBackgroundColor),
                                child: Icon(Icons.arrow_back_rounded, color: innerBoxIsScrolled ? white : context.iconColor))
                            .onTap(() {
                          finish(context);
                        }),
                        expandedHeight: 400,
                        pinned: true,
                        floating: true,
                        actions: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 8),
                                padding: EdgeInsets.all(8),
                                decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.scaffoldBackgroundColor),
                                child: Icon(Icons.edit, color: context.iconColor, size: 18),
                              ).onTap(() {
                                AddServiceScreen(data: serviceDetailData.service_detail).launch(context);
                              }),
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.scaffoldBackgroundColor),
                                child: Icon(Icons.delete, color: context.iconColor, size: 18),
                              ).onTap(() {
                                confirmationDialog(context);
                              }),
                            ],
                          ).paddingOnly(top: 16, right: 12),
                        ],
                        title: Text(innerBoxIsScrolled ? serviceDetailData.service_detail!.name.validate() : ""),
                        backgroundColor: innerBoxIsScrolled ? context.primaryColor : Colors.transparent,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Stack(
                            children: [
                              PageView(
                                children: galleryImages.map((i) {
                                  return i.isNotEmpty
                                      ? cachedImage(i.toString(), fit: BoxFit.cover, width: double.infinity, height: 500).onTap(() {
                                          ZoomImageScreen(galleryImages: galleryImages).launch(context);
                                        })
                                      : placeHolderWidget(fit: BoxFit.cover, width: double.infinity, height: 500);
                                }).toList(),
                                controller: _pageController,
                                onPageChanged: (index) {
                                  selectIndex = index;
                                  setState(() {});
                                },
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: DotIndicator(
                                  pageController: _pageController,
                                  pages: galleryImages,
                                  indicatorColor: primaryColor,
                                  unselectedIndicatorColor: grey.withOpacity(0.9),
                                  currentBoxShape: BoxShape.rectangle,
                                  boxShape: BoxShape.rectangle,
                                  borderRadius: radius(2),
                                  currentBorderRadius: radius(3),
                                  currentDotSize: 18,
                                  currentDotWidth: 6,
                                  dotSize: 6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ];
                  },
                  body: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 60),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    20.height,
                                    Text(serviceDetailData.service_detail!.name.validate(), style: boldTextStyle(size: 20)).paddingOnly(bottom: 4, right: 20),
                                    Row(
                                      children: [
                                        PriceWidget(price: serviceDetailData.service_detail!.price.validate() * _itemCount, size: 18,color: primaryColor,),
                                        4.width.visible(serviceDetailData.service_detail!.discount != null),
                                        Text('(${serviceDetailData.service_detail!.discount}% Off)', style: secondaryTextStyle(size: 14, color: redColor))
                                            .visible(serviceDetailData.service_detail!.discount != null),
                                        4.width,
                                        if (serviceDetailData.service_detail!.type != 'fixed') Text('/' + "hr", style: secondaryTextStyle(size: 12)).paddingTop(4),
                                      ],
                                    ),
                                  ],
                                ).expand(),
                              ],
                            ).paddingSymmetric(horizontal: 16),
                            16.height,
                            Text(context.translate.lblService, style: boldTextStyle()).paddingOnly(left: 16, right: 16).visible(galleryImages.isNotEmpty),
                            Container(
                              margin: EdgeInsets.all(16),
                              padding: EdgeInsets.all(8),
                              width: context.width(),
                              decoration: boxDecorationDefault(color: context.cardColor),
                              child: Text(serviceDetailData.service_detail!.description.validate(), style: secondaryTextStyle(), textAlign: TextAlign.justify),
                            ).visible(serviceDetailData.service_detail!.description.validate().isNotEmpty),
                            durationWidget().paddingOnly(left: 16, right: 16),
                            serviceAddressWidget().visible(addressList.isNotEmpty),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox(),
        ),
        Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
      ],
    ); /*Scaffold(
      body: Observer(
        builder: (_) => Stack(
          children: [
            if (serviceDetailData.service_detail != null)
              Stack(
                children: [
                  Container(
                    height: context.height() * 0.55,
                    child: cachedImage(
                      serviceDetailData.service_detail!.attchments!.isNotEmpty ? serviceDetailData.service_detail!.attchments!.first.validate() : '',
                      height: context.height() * 0.55,
                      width: context.width(),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SingleChildScrollView(
                    padding: EdgeInsets.only(top: context.height() * 0.5, bottom: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: context.width(),
                          decoration: BoxDecoration(borderRadius: radiusOnly(topLeft: 30, topRight: 30), color: appStore.isDarkMode ? scaffoldSecondaryDark : Colors.white),
                          padding: EdgeInsets.only(top: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(serviceDetailData.service_detail!.name.validate(), style: boldTextStyle(size: 18)).paddingOnly(left: 4, bottom: 4),
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(right: 8.0, top: 4.0),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                PriceWidget(price: serviceDetailData.service_detail!.price.validate() * _itemCount, color: primaryColor, size: 18),
                                                4.width.visible(serviceDetailData.service_detail!.discount != null || serviceDetailData.service_detail!.discount != 0),
                                                if (serviceDetailData.service_detail!.discount != null)
                                                  Text('(${serviceDetailData.service_detail!.discount}% OFF)', style: secondaryTextStyle(color: redColor))
                                                      .visible(serviceDetailData.service_detail!.discount != 0)
                                                      .paddingTop(2),
                                                4.width,
                                                if (serviceDetailData.service_detail!.type != 'fixed') Text('/' + "hr", style: secondaryTextStyle(size: 12)).paddingTop(4),
                                              ],
                                            ),
                                          ),
                                          if (serviceDetailData.service_detail!.total_review!.toDouble() != 0)
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                RatingBarWidget(
                                                  disable: true,
                                                  rating: serviceDetailData.service_detail!.total_review!.toDouble(),
                                                  size: 16,
                                                  onRatingChanged: (v) {
                                                    //
                                                  },
                                                ),
                                                4.width,
                                                if (serviceDetailData.service_detail!.total_review!.toDouble() != 0)
                                                  Text('(${serviceDetailData.service_detail!.total_review!} Reviews)', style: secondaryTextStyle()),
                                              ],
                                            ).expand(),
                                        ],
                                      ),
                                    ],
                                  ).expand(),
                                ],
                              ).paddingOnly(left: 16, right: 16, bottom: 16),
                              Text(
                                context.translate.lblService + ' ' + context.translate.lblGallery,
                                style: boldTextStyle(),
                              ).paddingOnly(left: 16, right: 16).visible(galleryImages.isNotEmpty),
                              Container(
                                margin: EdgeInsets.all(16),
                                padding: EdgeInsets.all(8),
                                decoration: boxDecorationDefault(color: context.cardColor),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GalleryImagesComponent(galleryImages).paddingOnly(top: 8, bottom: 8).visible(galleryImages.isNotEmpty),
                                    Text(serviceDetailData.service_detail!.description.validate(), style: secondaryTextStyle(), textAlign: TextAlign.justify),
                                  ],
                                ),
                              ).visible(serviceDetailData.service_detail!.description.validate().isNotEmpty),
                              durationWidget().paddingOnly(left: 16, right: 16),
                              serviceAddressWidget().visible(addressList.isNotEmpty),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 16,
                    right: 16,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.scaffoldBackgroundColor),
                          child: Icon(Icons.arrow_back, color: context.iconColor, size: 18),
                        ).onTap(() {
                          finish(context);
                        }),
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.scaffoldBackgroundColor),
                              child: Icon(Icons.edit, color: context.iconColor, size: 18),
                            ).onTap(() {
                              AddServiceScreen(data: serviceDetailData.service_detail).launch(context);
                            }),
                            8.height,
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.scaffoldBackgroundColor),
                              child: Icon(Icons.delete, color: context.iconColor, size: 18),
                            ).onTap(() {
                              confirmationDialog(context);
                            }),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            LoaderWidget().center().visible(appStore.isLoading),
          ],
        ),
      ),
    );*/
  }

  //confirmation Alert
  Future<void> confirmationDialog(BuildContext context) async {
    showConfirmDialogCustom(
      context,
      primaryColor: primaryColor,
      positiveText: context.translate.lblYes,
      negativeText: context.translate.lblNo,
      onAccept: (context) async {
        if (getStringAsync(USER_EMAIL) != demoUser) {
          appStore.setLoading(true);
          removeService();
        } else {
          toast(context.translate.lblUnAuthorized);
        }
      },
      title: context.translate.confirmationRequestTxt,
    );
  }
}
