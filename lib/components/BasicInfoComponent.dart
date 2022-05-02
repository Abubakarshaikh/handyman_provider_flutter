import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/models/BookingDetailResponse.dart';
import 'package:handyman_provider_flutter/models/UserData.dart';
import 'package:handyman_provider_flutter/screens/ChatScreen.dart';
import 'package:handyman_provider_flutter/utils/Colors.dart';
import 'package:handyman_provider_flutter/utils/Common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:handyman_provider_flutter/utils/Constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/rendering.dart';
import 'package:handyman_provider_flutter/extensions/ContextExt.dart';

import 'AppWidgets.dart';

class BasicInfoComponent extends StatefulWidget {
  final UserData? handymanData;
  final UserData? customerData;
  final int flag;

  BasicInfoComponent(this.flag, {this.customerData, this.handymanData});

  @override
  BasicInfoComponentState createState() => BasicInfoComponentState();
}

class BasicInfoComponentState extends State<BasicInfoComponent> {
  Customer customer = Customer();
  ProviderData provider = ProviderData();
  UserData userData = UserData();

  late String googleUrl;
  late String address;
  late String name;
  late String contactNumber;
  late String profileUrl;
  late int profileId;

  int? flag;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (widget.flag == 0) {
      profileId = widget.customerData!.id.validate();
      name = widget.customerData!.displayName.validate();
      profileUrl = widget.customerData!.profileImage.validate();
      contactNumber = widget.customerData!.contactNumber.validate();
      address = widget.customerData!.address.validate();
      userData = widget.customerData!;
    } else {
      profileId = widget.handymanData!.id.validate();
      name = widget.handymanData!.displayName.validate();
      profileUrl = widget.handymanData!.profileImage.validate();
      contactNumber = widget.handymanData!.contactNumber.validate();
      address = widget.handymanData!.address.validate();
      userData = widget.handymanData!;
    }
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.height,
        Container(
          padding: EdgeInsets.all(12),
          decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), blurRadius: 0, backgroundColor: context.cardColor, shadowColor: appShadowColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  cachedImage(profileUrl.validate(), width: 65, height: 65, fit: BoxFit.cover).cornerRadiusWithClipRRect(8),
                  8.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(MaterialCommunityIcons.account, size: 16),
                          4.width,
                          Text(name.validate(), style: boldTextStyle()).expand(),
                        ],
                      ),
                      4.height,
                      if (contactNumber.validate().isNotEmpty)
                        Row(
                          children: [
                            Icon(Icons.call, size: 16, color: context.iconColor),
                            4.width,
                            Text(contactNumber.validate(), style: secondaryTextStyle()),
                          ],
                        ),
                      4.height,
                      if (address.validate().isNotEmpty)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.location_on_outlined, size: 16, color: context.iconColor),
                            4.width,
                            Text(
                              address.validate().isNotEmpty ? address.validate() : '',
                              style: secondaryTextStyle(),
                            ).expand(),
                          ],
                        ),
                    ],
                  ).expand()
                ],
              ),
              8.height,
              Divider(),
              8.height,
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (contactNumber.validate().isNotEmpty)
                      Row(
                        children: [Icon(Icons.call, size: 18, color: context.iconColor), 4.width, Text(context.translate.lblCall, style: boldTextStyle(size: 14))],
                      ).onTap(() {
                        launchUrl(TEL + contactNumber.validate());
                        // makingPhoneCall(contactNumber.validate());
                      }),
                    if (address.validate().isNotEmpty) VerticalDivider(thickness: 1.5),
                    if (address.validate().isNotEmpty)
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 18, color: context.iconColor),
                          4.width,
                          Text(context.translate.lblLocation, style: boldTextStyle(size: 14)),
                        ],
                      ).onTap(() {
                        launchMap(address);
                      }),
                    if (userData.uid.validate().isNotEmpty) VerticalDivider(thickness: 1.5),
                    if (userData.uid.validate().isNotEmpty)
                      Row(
                        children: [
                          Icon(Icons.chat, size: 18, color: context.iconColor),
                          4.width,
                          Text(context.translate.lblChat, style: boldTextStyle(size: 14)),
                        ],
                      ).onTap(
                        () {
                          ChatScreen(userData: userData).launch(context);
                        },
                      ),
                  ],
                ),
              ),
              8.height,
            ],
          ),
        ),
      ],
    );
  }
}
