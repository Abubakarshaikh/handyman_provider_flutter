import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/models/BookingDetailResponse.dart';
import 'package:handyman_provider_flutter/utils/Colors.dart';
import 'package:handyman_provider_flutter/utils/Common.dart';
import 'package:handyman_provider_flutter/utils/Dashed_Rect.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:handyman_provider_flutter/extensions/ContextExt.dart';

class BookingHistoryComponent extends StatefulWidget {
  List<BookingActivity>? data;

  BookingHistoryComponent({this.data});

  @override
  BookingHistoryComponentState createState() => BookingHistoryComponentState();
}

class BookingHistoryComponentState extends State<BookingHistoryComponent> {
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
    return Container(
      decoration: boxDecorationWithRoundedCorners(borderRadius: radius(defaultRadius), backgroundColor: context.cardColor),
      padding: EdgeInsets.symmetric(horizontal: 8),
      margin: EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            8.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(context.translate.bookingHistory, style: boldTextStyle(size: 18)),
                IconButton(onPressed: () => finish(context), icon: Icon(Icons.close)),
              ],
            ),
            Divider(),
            4.height,
            widget.data!.length != 0
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.data!.length,
                    itemBuilder: (_, i) {
                      BookingActivity data = widget.data![i];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(height: 10, width: 10, decoration: BoxDecoration(color: primaryColor, borderRadius: radius(16))),
                              SizedBox(height: 50, child: DashedRect(gap: 1, color: primaryColor)).visible(i != widget.data!.length - 1),
                            ],
                          ),
                          8.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextIcon(
                                expandedText: true,
                                edgeInsets: EdgeInsets.only(right: 4, left: 4, bottom: 4),
                                text: data.activityType.validate().replaceAll('_', ' ').capitalizeFirstLetter(),
                                suffix: Text(formateDate(data.datetime.toString().validate()), style: secondaryTextStyle()),
                              ),
                              Text(
                                data.activityMessage.validate().replaceAll('_', ' ').capitalizeFirstLetter(),
                                style: secondaryTextStyle(),
                              ),
                            ],
                          ).paddingOnly(bottom: 8).expand()
                        ],
                      );
                    },
                  )
                : Text(context.translate.noDataFound),
            8.height,
          ],
        ),
      ),
    );
  }
}
