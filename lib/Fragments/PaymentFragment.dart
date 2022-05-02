import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:handyman_provider_flutter/components/AppWidgets.dart';
import 'package:handyman_provider_flutter/models/PaymentListReasponse.dart';
import 'package:handyman_provider_flutter/networks/RestApis.dart';
import 'package:handyman_provider_flutter/screens/BookingDetailScreen.dart';
import 'package:handyman_provider_flutter/store/AppStore.dart';
import 'package:handyman_provider_flutter/utils/Colors.dart';
import 'package:handyman_provider_flutter/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:handyman_provider_flutter/extensions/ContextExt.dart';

class PaymentFragment extends StatefulWidget {
  @override
  PaymentFragmentState createState() => PaymentFragmentState();
}

class PaymentFragmentState extends State<PaymentFragment> {
  AppStore appStore = AppStore();
  ScrollController scrollController = ScrollController();

  List<Data> paymentDataList = [];

  int totalPage = 0;
  int currentPage = 1;
  int totalItems = 0;

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
     getPayment();
  }

  Future<void> getPayment() async {
    appStore.setLoading(true);

    await getPaymentList(currentPage).then((value) {
      appStore.setLoading(false);
      hasError = false;
      totalItems = value.pagination!.totalItems!;

      if (currentPage == 1) {
        paymentDataList.clear();
      }
      if (totalItems >= 1) {
        paymentDataList.addAll(value.data!);
        totalPage = value.pagination!.totalPages!;
        currentPage = value.pagination!.currentPage!;
      }
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      hasError = true;
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cardColor,
      appBar: appBarWidget(context.translate.lblPayment, textColor: white, elevation: 0.0, color: context.primaryColor, showBack: false),
      body: Observer(
        builder: (_) {
          return Stack(
            children: [
              ListView.builder(
                controller: scrollController,
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                itemCount: paymentDataList.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(left: 12, bottom: 12),
                    margin: EdgeInsets.only(top: 8, bottom: 8),
                    width: context.width(),
                    decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), blurRadius: 0, backgroundColor: context.cardColor, shadowColor: appShadowColor),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            32.height,
                            Text(context.translate.lblBookingID + ': #' + paymentDataList[index].bookingId.toString().validate(), style: secondaryTextStyle()),
                            8.height,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(MaterialCommunityIcons.account, color: context.iconColor, size: 18),
                                4.width,
                                Text(
                                  paymentDataList[index].customerName.validate(),
                                  style: boldTextStyle(),
                                ),
                              ],
                            ),
                            4.height,
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(context.translate.lblPaymentID, style: secondaryTextStyle()),
                                Text(
                                  "#" + paymentDataList[index].id.toString(),
                                  style: boldTextStyle(size: 14)
                                ),
                              ],
                            ).paddingSymmetric(vertical: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(context.translate.paymentStatus, style: secondaryTextStyle()),
                                Text(
                                  paymentDataList[index].paymentStatus.validate(),
                                  style: boldTextStyle(size: 14)
                                ),
                              ],
                            ).paddingSymmetric(vertical: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(context.translate.paymentMethod, style: secondaryTextStyle()),
                                Text(
                                  paymentDataList[index].paymentMethod.validate().isNotEmpty ? paymentDataList[index].paymentMethod.validate() : context.translate.notAvailable,
                                  style: boldTextStyle(size: 14),
                                ),
                              ],
                            ).paddingSymmetric(vertical: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(context.translate.lblAmount, style: secondaryTextStyle()),
                                PriceWidget(price: paymentDataList[index].totalAmount, color: primaryColor),
                              ],
                            ).paddingSymmetric(vertical: 4),
                            // 8.height,
                          ],
                        ).paddingRight(12),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                            decoration:
                                boxDecorationWithRoundedCorners(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(defaultRadius), topRight: Radius.circular(defaultRadius)), backgroundColor: primaryColor),
                            child: Text('#' + paymentDataList[index].id.toString().validate(), style: boldTextStyle(color: white)),
                          ),
                        )
                      ],
                    ),
                  ).onTap(() async {
                    BookingDetailScreen(bookingId: paymentDataList[index].bookingId).launch(context);
                  });
                },
              ),
              noDataFound().center().visible(paymentDataList.isEmpty && !appStore.isLoading && !hasError),
              Text(errorSomethingWentWrong, style: secondaryTextStyle()).center().visible(hasError),
              LoaderWidget().center().visible(appStore.isLoading),
            ],
          );
        },
      ),
    );
  }
}
