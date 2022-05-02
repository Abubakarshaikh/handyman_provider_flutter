import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:handyman_provider_flutter/components/AppWidgets.dart';
import 'package:handyman_provider_flutter/components/AssignBookingComponent.dart';
import 'package:handyman_provider_flutter/components/BasicInfoComponent.dart';
import 'package:handyman_provider_flutter/components/BookingHistoryComponent.dart';
import 'package:handyman_provider_flutter/models/BookingDetailResponse.dart';
import 'package:handyman_provider_flutter/models/UserData.dart';
import 'package:handyman_provider_flutter/networks/RestApis.dart';
import 'package:handyman_provider_flutter/utils/Colors.dart';
import 'package:handyman_provider_flutter/utils/Common.dart';
import 'package:handyman_provider_flutter/utils/Constant.dart';
import 'package:handyman_provider_flutter/utils/ModelKeys.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:handyman_provider_flutter/extensions/ContextExt.dart';
import '../main.dart';

class BookingDetailScreen extends StatefulWidget {
  final int? bookingId;

  BookingDetailScreen({this.bookingId});

  @override
  BookingDetailScreenState createState() => BookingDetailScreenState();
}

class BookingDetailScreenState extends State<BookingDetailScreen> {
  BookingDetailResponse bookingDetailResponse = BookingDetailResponse();
  BookingDetail _bookingDetail = BookingDetail();
  UserData _customer = UserData();
  List<UserData> handymanData = [];
  ProviderData providerData = ProviderData();
  List<BookingActivity> bookingActivity = [];

  String? positiveBtnTxt = '';
  String? negativeBtnTxt = '';

  String? startDateTime = '';
  String? timeInterval = '0';
  String? endDateTime = '';
  String? paymentStatus = '';

  bool afterInitVisible = false;
  bool visibleBottom = false;
  bool isAssigned = false;

  //live stream
  bool? clicked = false;
  int tabIndex = -1;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      appStore.setLoading(true);
      init();
    });
  }

  Future<void> init() async {
    await loadBookingDetail();
  }

  void _showInterstitialAdNow() {
    if (showMobileAds) {
      int ad_count = getIntAsync(INITIAL_AD_COUNT);
      if (ad_count == SHOW_INITIAL_AD_NUMBER) {
        showInterstitialAd(context);
        setValue(INITIAL_AD_COUNT, -1);
      } else {
        setValue(INITIAL_AD_COUNT, getIntAsync(INITIAL_AD_COUNT) + 1);
      }
    }
  }

  Future<void> loadBookingDetail() async {
    Map request = {CommonKeys.bookingId: widget.bookingId.toString()};
    await bookingDetail(request).then((value) {
      bookingDetailResponse = value;
      _bookingDetail = value.bookingDetail!;
      _customer = value.customer!;
      providerData = value.providerData!;
      handymanData = value.handymanData!;
      bookingActivity = value.bookingActivity!;
      if (handymanData.isNotEmpty) {
        isAssigned = true;
      }
      setBottom();
      afterInitVisible = true;
      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
    });
  }

  //set bottom
  void setBottom() {
    setState(() {
      if (_bookingDetail.status == BookingStatusKeys.pending) {
        positiveBtnTxt = context.translate.accept;
        negativeBtnTxt = context.translate.decline;
        visibleBottom = true;
      } else if (_bookingDetail.status == BookingStatusKeys.accept) {
        positiveBtnTxt = context.translate.lblAssignHandyman;
        visibleBottom = true;
      } else {
        visibleBottom = false;
      }
    });
  }

  Future<void> updateBooking(int? bookingId, String updateReason, String updatedStatus) async {
    DateTime now = DateTime.now();
    if (updatedStatus == BookingStatusKeys.rejected) {
      startDateTime = _bookingDetail.startAt.validate().isNotEmpty ? _bookingDetail.startAt.validate() : _bookingDetail.date.validate();
      endDateTime = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
      timeInterval = _bookingDetail.durationDiff.toString();
      paymentStatus = _bookingDetail.paymentStatus.validate();
      //
    }
    var request = {
      CommonKeys.id: bookingId,
      BookingUpdateKeys.startAt: startDateTime,
      BookingUpdateKeys.endAt: endDateTime,
      BookingUpdateKeys.durationDiff: timeInterval,
      BookingUpdateKeys.reason: updateReason,
      BookingUpdateKeys.status: updatedStatus,
      BookingUpdateKeys.paymentStatus: paymentStatus
    };
    await bookingUpdate(request).then((res) async {
      await loadBookingDetail();
    }).catchError((e) {
      toast(e.toString(), print: true);
      appStore.setLoading(false);
    });
  }

  //confirmation Alert
  Future<void> confirmationRequestDialog(BuildContext context, String status) async {
    showConfirmDialogCustom(
      context,
      primaryColor: primaryColor,
      positiveText: context.translate.lblYes,
      negativeText: context.translate.lblNo,
      onAccept: (context) async {
        if (status == BookingStatusKeys.pending) {
          appStore.setLoading(true);
          updateBooking(_bookingDetail.id, '', BookingStatusKeys.accept);
        } else if (status == BookingStatusKeys.rejected) {
          updateBooking(_bookingDetail.id, '', BookingStatusKeys.rejected);
        }
      },
      title: context.translate.confirmationRequestTxt,
    );
  }

  Future<void> assignBookingDialog(BuildContext context, int? bookingId, int? address_id) async {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return AssignBookingComponent(
              bookingId: bookingId,
              serviceAddressId: address_id,
              onUpdate: () {
                isAssigned = true;
                loadBookingDetail();
                setState(() {});
              });
        });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          if (showMobileAds) {
            _showInterstitialAdNow();
          }
          if (_bookingDetail.status == BookingStatusKeys.accept) {
            pop({'update': true, 'index': 1});
            //
          } else {
            pop();
          }
          return Future.value(false);
        },
        child: RefreshIndicator(
          onRefresh: () async {
            init();
            await 2.seconds.delay;
            //
          },
          child: Scaffold(
            backgroundColor: context.cardColor,
            appBar: afterInitVisible
                ? AppBar(
                    backgroundColor: context.primaryColor,
                    automaticallyImplyLeading: false,
                    title: SettingItemWidget(
                      padding: EdgeInsets.all(0),
                      title: _bookingDetail.serviceName.validate(),
                      subTitle: _bookingDetail.statusLabel.validate(),
                      leading: Icon(Icons.arrow_back, size: 28, color: white).onTap(() {
                        if (showMobileAds) {
                          _showInterstitialAdNow();
                        }
                        if (_bookingDetail.status == BookingStatusKeys.accept) {
                          pop({'update': true, 'index': 1});
                          //
                        } else {
                          pop();
                        }
                      }),
                      trailing: Icon(Icons.info, size: 28).onTap(() {
                        showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            enableDrag: true,
                            builder: (_) {
                              return BookingHistoryComponent(data: bookingActivity);
                            });
                      }),
                      titleTextStyle: boldTextStyle(size: 20, color: Colors.white),
                      subTitleTextStyle: secondaryTextStyle(color: white),
                    ),
                  )
                : null,
            body: Observer(
              builder: (_) => Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      width: context.height(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          16.height,
                          Text(context.translate.serviceDetail, style: boldTextStyle()),
                          8.height,
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), blurRadius: 0, backgroundColor: context.cardColor, shadowColor: appShadowColor),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(context.translate.lblBooking + ' #' + _bookingDetail.id.toString().validate(), style: secondaryTextStyle(size: 12)),
                                TextIcon(
                                  expandedText: true,
                                  edgeInsets: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                                  prefix: Row(
                                    children: [
                                      PriceWidget(price: _bookingDetail.price, size: 14, color: Colors.blue),
                                      // Text('.00', style: boldTextStyle(color: Colors.blue, size: 14)),
                                      if (_bookingDetail.discount != null) Text(' - ', style: boldTextStyle(color: Colors.red)),
                                      if (_bookingDetail.discount != null) PriceWidget(price: _bookingDetail.discount, size: 14, color: Colors.red),
                                      if (_bookingDetail.discount != null) Text(' off', style: boldTextStyle(size: 14, color: Colors.red)),
                                      _bookingDetail.type.toString().validate() != "fixed" ? Text(' / ' + _bookingDetail.type.toString().validate(), style: secondaryTextStyle()) : Text("", style: secondaryTextStyle()),
                                    ],
                                  ),
                                ),
                                TextIcon(
                                  expandedText: true,
                                  edgeInsets: EdgeInsets.all(0),
                                  prefix: Icon(Ionicons.calendar, color: context.iconColor, size: 18),
                                  text: _bookingDetail.date.validate().isNotEmpty ? formateDate(_bookingDetail.date.validate()) : '',
                                  textStyle: secondaryTextStyle(),
                                  suffix: Text(
                                    _bookingDetail.statusLabel.validate(),
                                    style: boldTextStyle(
                                      color: _bookingDetail.status == BookingStatusKeys.cancelled || _bookingDetail.status == BookingStatusKeys.failed || _bookingDetail.status == BookingStatusKeys.rejected
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  ),
                                ),
                                if (_bookingDetail.durationDiff != null && !identical(_bookingDetail.durationDiff, "0") && _bookingDetail.type == HOURLY)
                                  Row(
                                    children: [
                                      Icon(CupertinoIcons.clock, color: context.iconColor, size: 18),
                                      4.width,
                                      Text(context.translate.totalWorking, style: secondaryTextStyle()).expand(),
                                      Text(durationToString(_bookingDetail.durationDiff.toInt()), style: boldTextStyle(size: 14)),
                                    ],
                                  ).paddingSymmetric(vertical: 4),
                                if (_bookingDetail.quantity != null && _bookingDetail.type == FIXED)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(CupertinoIcons.cart, color: context.iconColor, size: 18),
                                      4.width,
                                      Text(context.translate.quantity, style: secondaryTextStyle()).expand(),
                                      Text(
                                        _bookingDetail.durationDiff != null ? 'x ' + _bookingDetail.quantity!.toString() : context.translate.notAvailable,
                                        style: boldTextStyle(size: 14),
                                      ),
                                    ],
                                  ).paddingSymmetric(vertical: 4),
                                Divider(),
                                if (_bookingDetail.paymentId != null)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(context.translate.lblPaymentID, style: secondaryTextStyle()),
                                      Text(
                                        "#" + _bookingDetail.paymentId.toString(),
                                        style: boldTextStyle(size: 14),
                                      ),
                                    ],
                                  ).paddingSymmetric(vertical: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(context.translate.paymentStatus, style: secondaryTextStyle()),
                                    Text(
                                      _bookingDetail.paymentStatus != null ? _bookingDetail.paymentStatus.toString() : context.translate.pending,
                                      style: boldTextStyle(size: 14),
                                    ),
                                  ],
                                ).paddingSymmetric(vertical: 4),
                                if (_bookingDetail.paymentMethod.validate().isNotEmpty)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(context.translate.paymentMethod, style: secondaryTextStyle()),
                                      Text(
                                        _bookingDetail.paymentMethod != null ? _bookingDetail.paymentMethod.toString() : context.translate.notAvailable,
                                        style: boldTextStyle(size: 14),
                                      ),
                                    ],
                                  ).paddingSymmetric(vertical: 4),
                                if (_bookingDetail.status == BookingStatusKeys.cancelled || _bookingDetail.status == BookingStatusKeys.failed) Divider(),
                                if (_bookingDetail.status == BookingStatusKeys.cancelled || _bookingDetail.status == BookingStatusKeys.failed)
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(context.translate.lblReason + ' : ', style: boldTextStyle()),
                                      Text(_bookingDetail.reason.validate(), style: secondaryTextStyle(), textAlign: TextAlign.justify).expand(),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          Text(context.translate.customer, style: boldTextStyle()).paddingTop(16),
                          BasicInfoComponent(0, customerData: _customer),
                          if (handymanData.isNotEmpty) Text(context.translate.handyman, style: boldTextStyle()).paddingTop(16),
                          if (handymanData.isNotEmpty)
                            Column(
                              children: handymanData.map((e) {
                                return BasicInfoComponent(1, handymanData: e);
                              }).toList(),
                            ),
                          16.height,
                        ],
                      ),
                    ),
                  ).visible(!appStore.isLoading),
                  LoaderWidget().center().visible(appStore.isLoading),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              height: 74,
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.center,
              decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), backgroundColor: context.cardColor, shadowColor: appShadowColor),
              child: _bookingDetail.status == BookingStatusKeys.pending
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        statusButton(
                          context.width() / 2.5,
                          positiveBtnTxt.validate(),
                          primaryColor,
                          Colors.white,
                          onTap: (() {
                            if (_bookingDetail.status == BookingStatusKeys.pending) confirmationRequestDialog(context, BookingStatusKeys.pending);
                          }),
                        ),
                        8.width,
                        statusButton(
                          context.width() / 2.5,
                          negativeBtnTxt.validate(),
                          context.cardColor,
                          primaryColor,
                          onTap: (() {
                            confirmationRequestDialog(context, BookingStatusKeys.rejected);
                          }),
                        ),
                      ],
                    )
                  : _bookingDetail.status == BookingStatusKeys.accept
                      ? isAssigned
                          ? Text(context.translate.lblAssigned, style: boldTextStyle()).center()
                          : statusButton(context.width(), context.translate.lblAssignHandyman, Colors.green.shade600, Colors.white, onTap: () {
                              appStore.setLoading(true);
                              assignBookingDialog(context, _bookingDetail.id, _bookingDetail.booking_address_id);
                            })
                      : SizedBox(),
            ).visible(afterInitVisible && visibleBottom),
          ),
        ),
      ),
    );
  }
}
