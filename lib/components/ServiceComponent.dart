import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:handyman_provider_flutter/components/AppWidgets.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/ServiceModel.dart';
import 'package:handyman_provider_flutter/screens/ServiceDetailScreen.dart';
import 'package:handyman_provider_flutter/utils/Colors.dart';
import 'package:handyman_provider_flutter/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceComponent extends StatefulWidget {
  final Service? serviceData;
  final Function? onUpdate;

  ServiceComponent({required this.serviceData, this.onUpdate});

  @override
  ServiceComponentState createState() => ServiceComponentState();
}

class ServiceComponentState extends State<ServiceComponent> {
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
      margin: EdgeInsets.all(8),
      width: context.width(),
      decoration: boxDecorationRoundedWithShadow(12, backgroundColor: context.cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            overflow: Overflow.visible,
            children: [
              widget.serviceData!.attchments!.isNotEmpty
                  ? cachedImage(widget.serviceData!.attchments!.first != '' ? widget.serviceData!.attchments!.first.validate() : '', height: 200, width: context.width(), fit: BoxFit.cover)
                      .cornerRadiusWithClipRRectOnly(topRight: 12, topLeft: 12)
                  : cachedImage('', height: 200, width: context.width(), fit: BoxFit.cover).cornerRadiusWithClipRRect(12),
              Positioned(
                bottom: -10,
                child: Container(
                  //width: 100,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  constraints: BoxConstraints(maxWidth: context.width() * 0.85),
                  decoration: boxDecorationWithShadow(backgroundColor: primaryColor, borderRadius: radius(4)),
                  child: Text(
                    widget.serviceData!.name.validate(),
                    style: boldTextStyle(color: white, size: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ).paddingSymmetric(horizontal: 8, vertical: 4),
                ),
              ),
              Positioned(
                top: 20,
                right: 0,
                child: widget.serviceData!.price != null
                    ? Container(
                        decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), topLeft: Radius.circular(12)), backgroundColor: context.cardColor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.serviceData!.price_format!.toString().validate(), style: boldTextStyle(color: primaryColor, size: 16)).paddingSymmetric(horizontal: 10, vertical: 4),
                            if (widget.serviceData!.discount != null)
                              Text(widget.serviceData!.discount!.toString().validate() + '% off', style: boldTextStyle(size: 14)).paddingOnly(left: 10, right: 10, bottom: 4).visible(widget.serviceData!.discount != 0 ),
                          ],
                        ),
                      )
                    : SizedBox(),
              )
            ],
          ),
          16.height.visible(widget.serviceData!.description.validate().isNotEmpty),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.serviceData!.description.validate().capitalizeFirstLetter(), style: secondaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis).paddingOnly(left: 8, right: 8, bottom: 8).expand(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: boxDecorationDefault(color: getRateColor(widget.serviceData!.total_rating!)),
                child: Row(
                  children: [
                    Icon(Icons.star_border, size: 14, color: white),
                    4.width,
                    Text(widget.serviceData!.total_rating!.toString(), style: primaryTextStyle(color: white)),
                  ],
                ),
              ).paddingOnly(right: 8).visible(widget.serviceData!.total_rating! != 0),
            ],
          ),
        ],
      ),
    ).onTap(() async {
      bool? res = await ServiceDetailScreen(serviceId: widget.serviceData!.id.validate()).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
      if (res ?? true) {
        appStore.setLoading(false);
        widget.onUpdate?.call();
        setState(() {});
      }
    });
  }
}
