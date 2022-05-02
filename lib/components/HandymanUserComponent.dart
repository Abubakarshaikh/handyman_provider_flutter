import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:handyman_provider_flutter/models/UserListResponse.dart';
import 'package:handyman_provider_flutter/networks/RestApis.dart';
import 'package:handyman_provider_flutter/utils/Colors.dart';
import 'package:handyman_provider_flutter/utils/Common.dart';
import 'package:handyman_provider_flutter/utils/Constant.dart';
import 'package:handyman_provider_flutter/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'AppWidgets.dart';
import 'RegisterUserFormComponent.dart';

class HandymanUserComponent extends StatefulWidget {
  final UserListData userData;
  final Function? onUpdate;

  HandymanUserComponent(this.userData, {this.onUpdate});

  @override
  HandymanUserComponentState createState() => HandymanUserComponentState();
}

class HandymanUserComponentState extends State<HandymanUserComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  // updateHandymanStatus
  Future<void> changeStatus(int? id, int status) async {
    appStore.setLoading(true);
    Map request = {CommonKeys.id: id, UserKeys.status: status};
    await updateHandymanStatus(request).then((value) {
      appStore.setLoading(false);
      toast(value.message.toString(), print: true);
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
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(16),
      decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor, blurRadius: 1, offset: Offset(1, 1)),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cachedImage(widget.userData.profileImage.validate(), width: 50, height: 50, fit: BoxFit.cover).cornerRadiusWithClipRRect(25),
              8.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(widget.userData.displayName.validate(), style: boldTextStyle(), overflow: TextOverflow.ellipsis, maxLines: 1).expand(),
                      8.width,
                      Icon(Icons.edit, color: context.iconColor, size: 18).onTap(() {
                        RegisterUserFormComponent(user_type: UserTypeHandyman, data: widget.userData, isUpdate: true).launch(context);
                        // finish(context);
                      })
                    ],
                  ),
                  4.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.mail_outline, size: 18, color: context.iconColor).onTap(() {
                        launchUrl('mailto:' + widget.userData.email.validate());
                      }),
                      4.width,
                      Text(widget.userData.email.validate(), style: secondaryTextStyle()).expand(),
                    ],
                  ),
                  8.height,
                  Row(
                    children: [
                      Icon(Icons.call_outlined, size: 18, color: context.iconColor).onTap(() {
                        launchUrl(TEL + widget.userData.contactNumber.validate());
                      }),
                      4.width,
                      Text(widget.userData.contactNumber.validate(), style: secondaryTextStyle()),
                    ],
                  ),
                  8.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on_outlined, size: 18, color: context.iconColor).onTap(() {
                        launchMap(widget.userData.address.validate());
                      }),
                      4.width,
                      Text(widget.userData.address.validate(), style: secondaryTextStyle(size: 12), maxLines: 2).expand(),
                      8.width,
                    ],
                  ).paddingRight(30).visible(widget.userData.address.validate().isNotEmpty),
                ],
              ).expand(),
            ],
          ),
          SizedBox(
            height: 12,
            width: 24,
            child: Switch(
              activeColor: primaryColor,
              inactiveThumbColor: Colors.grey.shade300,
              inactiveTrackColor: Colors.grey,
              value: widget.userData.status.validate() == 1 ? true : false,
              onChanged: (bool? value) {
                appStore.setLoading(true);
                setState(() {
                  if (widget.userData.status.validate() == 1) {
                    widget.userData.status = 0;
                    changeStatus(widget.userData.id, 0);
                  } else {
                    widget.userData.status = 1;
                    changeStatus(widget.userData.id, 1);
                  }
                });
              },
            ),
          ).paddingAll(8),
        ],
      ),
    );
  }
}
