import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:handyman_provider_flutter/components/AppWidgets.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/UserListResponse.dart';
import 'package:handyman_provider_flutter/networks/RestApis.dart';
import 'package:handyman_provider_flutter/utils/Colors.dart';
import 'package:handyman_provider_flutter/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:handyman_provider_flutter/extensions/ContextExt.dart';

class AssignBookingComponent extends StatefulWidget {
  final int? bookingId;
  final Function? onUpdate;
  final int? serviceAddressId;

  AssignBookingComponent({this.bookingId, this.onUpdate, this.serviceAddressId});

  @override
  AssignBookingComponentState createState() => AssignBookingComponentState();
}

class AssignBookingComponentState extends State<AssignBookingComponent> {
  List<UserListData> userData = [];
  List<UserListData> handymanData = [];
  List<UserListData> filteredData = [];
  List<int> assignedHandyman = [];

  bool afterInit = false;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      appStore.setLoading(true);
      init();
    });
  }

  Future<void> init() async {
    getHandymanList();
  }

  Future<void> getHandymanList() async {
    appStore.setLoading(true);
    await getHandyman(isPagination: false, providerId: appStore.userId.validate().toInt()).then((res) {
      if (!mounted) return;
      handymanData.addAll(res.data!);
      if (handymanData.isNotEmpty) {
        for (int i = 0; i < handymanData.length; i++) {
          if (handymanData[i].status == 1) {
            if (handymanData[i].serviceAddressId == widget.serviceAddressId) {
              userData.add(handymanData[i]);
              setState(() {});
            }
          }
        }
      }
      appStore.setLoading(false);
      afterInit = true;
      setState(() {});
    }).catchError((e) {
      if (!mounted) return;
      toast(e.toString(), print: true);
      appStore.setLoading(false);
    });
  }

  Future<void> assignHandyman() async {
    var request = {
      CommonKeys.id: widget.bookingId,
      CommonKeys.handymanId: assignedHandyman,
    };
    await assignBooking(request).then((res) async {
      appStore.setLoading(false);
      widget.onUpdate?.call();
      finish(context);
    }).catchError((e) {
      appStore.setLoading(false);
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
    if (widget.serviceAddressId != null) {
      filteredData = userData;
    } else {
      filteredData = handymanData;
    }
    return Container(
      decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)), backgroundColor: context.cardColor),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                16.height,
                Text(context.translate.lblAssignHandyman, style: boldTextStyle()).visible(afterInit),
                8.height,
                Divider(),
                ListView.builder(
                  itemCount: filteredData.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 80),
                  itemBuilder: (_, index) {
                    return SizedBox(
                      height: 40,
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        title: Text(
                          filteredData[index].displayName.validate(),
                          style: secondaryTextStyle(color: context.iconColor),
                        ),
                        autofocus: false,
                        activeColor: primaryColor,
                        checkColor: context.cardColor,
                        value: assignedHandyman.contains(filteredData[index].id),
                        onChanged: (bool? value) {
                          setState(() {
                            if (assignedHandyman.contains(filteredData[index].id)) {
                              assignedHandyman.remove(filteredData[index].id);
                              value = assignedHandyman.contains(filteredData[index].id);
                            } else {
                              assignedHandyman.add(filteredData[index].id.validate());
                              value = assignedHandyman.contains(filteredData[index].id);
                            }
                          });
                        },
                      ),
                    );
                  },
                ).visible(afterInit && filteredData.isNotEmpty),
                Text(context.translate.noDataFound, style: boldTextStyle(), textAlign: TextAlign.center).paddingAll(16).visible(afterInit && filteredData.isEmpty),
              ],
            ),
          ),
          AppButton(
            onTap: () {
              if (assignedHandyman.isNotEmpty) {
                appStore.setLoading(true);
                assignHandyman();
              } else {
                toast(context.translate.lblSelectHandyman);
              }
            },
            color: primaryColor,
            width: context.width(),
            text: context.translate.lblAssign,
          ).paddingOnly(right: 16, left: 16, bottom: 16).visible(afterInit && filteredData.isNotEmpty),
          LoaderWidget().visible(appStore.isLoading && !afterInit),
        ],
      ),
    );
  }
}
