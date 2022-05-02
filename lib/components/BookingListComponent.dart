import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/BookingListResponse.dart';
import 'package:handyman_provider_flutter/networks/RestApis.dart';
import 'package:handyman_provider_flutter/screens/BookingDetailScreen.dart';
import 'package:handyman_provider_flutter/utils/Colors.dart';
import 'package:handyman_provider_flutter/utils/Common.dart';
import 'package:handyman_provider_flutter/utils/Constant.dart';
import 'package:handyman_provider_flutter/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:handyman_provider_flutter/extensions/ContextExt.dart';

import 'AppWidgets.dart';
import 'AssignBookingComponent.dart';

class BookingListComponent extends StatefulWidget {
  final String? status;

  BookingListComponent({this.status});

  @override
  BookingListComponentState createState() => BookingListComponentState();
}

class BookingListComponentState extends State<BookingListComponent> {
  ScrollController scrollController = ScrollController();

  List<Data> bookingDataList = [];
  List<Handyman>? handymanData = [];

  String status = '';
  int totalPage = 0;
  int currentPage = 1;
  int totalItems = 0;

  bool afterInit = false;
  bool hasError = false;
  bool hasData = false;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      appStore.setLoading(true);
      init();
    });
    scrollController.addListener(() {
      if (currentPage <= totalPage) {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          currentPage++;
          init();
        }
      } else {
        appStore.setLoading(false);
      }
    });
  }

  Future<void> init() async {
    await getBooking();
  }

  Future<void> getBooking() async {
    appStore.setLoading(true);
    await getBookingList(currentPage, status: widget.status.validate()).then((value) {
      appStore.setLoading(false);
      hasError = false;
      totalItems = value.pagination!.totalItems!.validate();

      if (currentPage == 1) {
        bookingDataList.clear();
      }
      if (totalItems >= 1) {
        bookingDataList.addAll(value.data!.validate());
        totalPage = value.pagination!.totalPages!.validate();
        currentPage = value.pagination!.currentPage!.validate();
      }
      afterInit = true;
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      hasError = true;
      setState(() {});
    });
  }

  Future<void> updateBooking(int bookingId, String updatedStatus, int index) async {
    appStore.setLoading(true);
    var request = {
      CommonKeys.id: bookingId,
      BookingUpdateKeys.status: updatedStatus,
    };
    await bookingUpdate(request).then((res) async {
      bookingDataList.removeAt(index);
      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
    });
  }

  Future<void> confirmationRequestDialog(BuildContext context, int index, String status) async {
    showConfirmDialogCustom(
      context,
      positiveText: context.translate.lblYes,
      negativeText: context.translate.lblNo,
      primaryColor: status == BookingStatusKeys.rejected ? Colors.redAccent : primaryColor,
      onAccept: (context) async {
        appStore.setLoading(true);
        updateBooking(bookingDataList[index].id.validate(), status, index);
      },
      title: context.translate.confirmationRequestTxt,
    );
  }

  Future<void> assignBookingDialog(BuildContext context, int index, int? bookingId, int? address_id) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AssignBookingComponent(
          bookingId: bookingId,
          serviceAddressId: address_id,
          onUpdate: () {
            setState(() {});
            getBooking();
          },
        );
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        currentPage = 1;
        init();
        await 2.seconds.delay;
      },
      child: Stack(
        children: [
          ListView.builder(
            controller: scrollController,
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: bookingDataList.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, bookingDataList[index].status == BookingStatusKeys.pending ? 8 : 16),
                    margin: EdgeInsets.only(top: 8, bottom: 8),
                    width: context.width(),
                    decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), backgroundColor: context.cardColor, blurRadius: 0, shadowColor: appShadowColor),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            cachedImage(
                              bookingDataList[index].service_attchments!.isNotEmpty ? bookingDataList[index].service_attchments!.first.validate() : '',
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ).cornerRadiusWithClipRRect(defaultRadius),
                            8.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(bookingDataList[index].service_name.validate(), style: boldTextStyle(), overflow: TextOverflow.ellipsis),
                                8.height,
                                Row(
                                  children: [
                                    PriceWidget(price: bookingDataList[index].price, size: 14),
                                    if (bookingDataList[index].discount != null) Text(' - ', style: boldTextStyle()),
                                    if (bookingDataList[index].discount != null) Text('${bookingDataList[index].discount}%', style: boldTextStyle(size: 14)),
                                    if (bookingDataList[index].discount != null) Text(' 0ff', style: boldTextStyle(size: 14)),
                                    bookingDataList[index].type.toString().validate() != "fixed" ? Text(' /hr ', style: secondaryTextStyle()) : Text("", style: secondaryTextStyle()),
                                  ],
                                ),
                              ],
                            ).expand(),
                            8.width,
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                              decoration: boxDecorationWithRoundedCorners(borderRadius: radius(defaultRadius), backgroundColor: primaryColor),
                              child: Text('#' + bookingDataList[index].id.toString().validate(), style: boldTextStyle(color: white)),
                            )
                          ],
                        ),
                        16.height,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(MaterialCommunityIcons.account, size: 16),
                            8.width,
                            Text(
                              bookingDataList[index].customer_name.validate(),
                              style: secondaryTextStyle(),
                            ),
                          ],
                        ),
                        8.height,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Ionicons.calendar, size: 16),
                            8.width,
                            Text(
                              formateDate(bookingDataList[index].date!.validate()),
                              style: secondaryTextStyle(),
                            ),
                          ],
                        ),
                        8.height,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(MaterialCommunityIcons.map_marker, size: 16),
                            8.width,
                            Text(
                              bookingDataList[index].address != null ? bookingDataList[index].address.validate() : context.translate.notAvailable,
                              style: secondaryTextStyle(),
                            ).flexible(),
                          ],
                        ),
                        8.height,
                        Divider(thickness: 1).visible(bookingDataList[index].status == BookingStatusKeys.pending),
                        Row(
                          children: [
                            confirmationButton(context, context.translate.accept, Icons.check).onTap(() {
                              confirmationRequestDialog(context, index, BookingStatusKeys.accept);
                            }),
                            16.width,
                            confirmationButton(context, context.translate.decline, Icons.close).onTap(() {
                              confirmationRequestDialog(context, index, BookingStatusKeys.rejected);
                            }),
                          ],
                        ).visible(bookingDataList[index].status == BookingStatusKeys.pending),
                        // Text(context.translate.lblAssigned, style: boldTextStyle()).center().visible(bookingDataList[index].handyman!.isNotEmpty && bookingDataList[index].status == BookingStatusKeys.accept),
                        statusButton(context.width(), context.translate.lblAssignHandyman, primaryColor, Colors.white, onTap: () {
                          assignBookingDialog(context, index, bookingDataList[index].id, bookingDataList[index].booking_address_id);
                        }).visible(bookingDataList[index].handyman!.isEmpty && bookingDataList[index].status == BookingStatusKeys.accept),
                      ],
                    ),
                  ).onTap(() async {
                    var res = await BookingDetailScreen(bookingId: bookingDataList[index].id).launch(context);
                    if (res is Map) {
                      if (res['update'] ?? false) {
                        appStore.setLoading(true);
                        bookingDataList.clear();
                        currentPage = 1;
                        init();
                        setState(() {});
                      }
                      LiveStream().emit(streamTab, res['index'] ?? -1);
                    }
                  }),
                ],
              );
            },
          ).visible(afterInit && bookingDataList.isNotEmpty),
          noDataFound().center().visible(afterInit && bookingDataList.isEmpty && !appStore.isLoading && !hasError),
          Text(errorSomethingWentWrong, style: secondaryTextStyle()).center().visible(hasError),
          LoaderWidget().visible(appStore.isLoading && !afterInit),
        ],
      ),
    );
  }
}
