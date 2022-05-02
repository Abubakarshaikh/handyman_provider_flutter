import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoding/geocoding.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/ServiceAddressesResponse.dart';
import 'package:handyman_provider_flutter/networks/RestApis.dart';
import 'package:handyman_provider_flutter/utils/Colors.dart';
import 'package:handyman_provider_flutter/utils/Common.dart';
import 'package:handyman_provider_flutter/utils/Constant.dart';
import 'package:handyman_provider_flutter/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:handyman_provider_flutter/extensions/ContextExt.dart';

class ServiceAddressesComponent extends StatefulWidget {
  final Data data;
  final Function? onUpdate;

  ServiceAddressesComponent(this.data, {this.onUpdate});

  @override
  ServiceAddressesComponentState createState() => ServiceAddressesComponentState();
}

class ServiceAddressesComponentState extends State<ServiceAddressesComponent> {
  double? destinationLatitude;
  double? destinationLongitude;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  Future<void> updateAddressStatus(int status, String? address, String? lat, String? long, int updateType) async {
    appStore.setLoading(true);
    Map request = {
      AddAddressKey.id: widget.data.id,
      AddAddressKey.providerId: appStore.userId,
      AddAddressKey.latitude: lat,
      AddAddressKey.longitude: long,
      AddAddressKey.status: status,
      AddAddressKey.address: address,
    };
    await addAddresses(request).then((value) {
      if (updateType == 1) {
        widget.data.address = address;
        finish(context);
        setState(() {});
      }
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  Future<void> deleteAddress(int? id) async {
    appStore.setLoading(true);
    await removeAddress(id).then((value) {
      appStore.setLoading(false);
      widget.onUpdate?.call();
      setState(() {});
    });
  }

  Future<void> editAddress(int? id) async {
    appStore.setLoading(true);
    await removeAddress(id).then((value) {
      appStore.setLoading(false);
      widget.onUpdate?.call();
      setState(() {});
    });
  }

  void editDialog(String? address) {
    TextEditingController textFieldAddress = TextEditingController(text: address);
    showInDialog(context, title: Text(context.translate.editAddress, style: boldTextStyle(), textAlign: TextAlign.justify), barrierColor: Colors.black45, builder: (context) {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              onChanged: (value) {},
              controller: textFieldAddress,
              textFieldType: TextFieldType.ADDRESS,
              decoration: inputDecoration(context),
              minLines: 4,
              maxLines: 10,
            ),
            16.height,
            AppButton(
              color: primaryColor,
              height: 40,
              text: context.translate.lblUpdate,
              textStyle: boldTextStyle(color: Colors.white),
              width: context.width() - context.navigationBarHeight,
              shapeBorder: RoundedRectangleBorder(
                borderRadius: radius(defaultAppButtonRadius),
                side: BorderSide(color: viewLineColor),
              ),
              onTap: () async {
                appStore.setLoading(true);
                try {
                  List<Location> destinationPlacemark = await locationFromAddress(textFieldAddress.text);
                  destinationLatitude = destinationPlacemark[0].latitude;
                  destinationLongitude = destinationPlacemark[0].longitude;

                  if (getStringAsync(USER_EMAIL) != demoUser) {
                    updateAddressStatus(widget.data.status.validate().toInt(), textFieldAddress.text, destinationLatitude.toString(), destinationLongitude.toString(), 1);
                  } else {
                    toast(context.translate.lblUnAuthorized);
                  }
                } catch (e) {
                  log(e);
                }
              },
            )
          ],
        ),
      );
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: boxDecorationWithShadow(borderRadius: radius(defaultRadius), backgroundColor: context.cardColor, blurRadius: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.data.address.validate(), style: boldTextStyle(), overflow: TextOverflow.ellipsis, maxLines: 4).expand(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 24,
                width: 16,
                child: Switch(
                  activeColor: primaryColor,
                  inactiveThumbColor: Colors.grey.shade300,
                  inactiveTrackColor: Colors.grey,
                  value: widget.data.status == 1 ? true : false,
                  onChanged: (bool? value) {
                    if (getStringAsync(USER_EMAIL) != demoUser) {
                      setState(() {
                        if (widget.data.status == 1) {
                          widget.data.status = 0.toString();
                          updateAddressStatus(0, widget.data.address, widget.data.latitude, widget.data.longitude, 0);
                        } else {
                          widget.data.status = 1.toString();
                          updateAddressStatus(1, widget.data.address, widget.data.latitude, widget.data.longitude, 0);
                        }
                      });
                    } else {
                      toast(context.translate.lblUnAuthorized);
                    }
                  },
                ),
              ),
              24.width,
              SizedBox(
                height: 24,
                width: 16,
                child: PopupMenuButton(
                  color: context.cardColor,
                  onSelected: (value) {
                    if (getStringAsync(USER_EMAIL) != demoUser) {
                      if (value == 1) {
                        editDialog(widget.data.address);
                      } else if (value == 2) {
                        deleteAddress(widget.data.id);
                      }
                    } else {
                      toast(context.translate.lblUnAuthorized);
                      finish(context);
                    }
                  },
                  padding: EdgeInsets.zero,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text(context.translate.lblEdit, style: secondaryTextStyle()),
                      value: 1,
                    ),
                    PopupMenuItem(
                      child: Text(context.translate.lblDelete, style: secondaryTextStyle()),
                      value: 2,
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
