import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:handyman_provider_flutter/components/AppWidgets.dart';
import 'package:handyman_provider_flutter/models/UserListResponse.dart';
import 'package:handyman_provider_flutter/networks/RestApis.dart';
import 'package:handyman_provider_flutter/utils/Colors.dart';
import 'package:handyman_provider_flutter/utils/Common.dart';
import 'package:handyman_provider_flutter/utils/Constant.dart';
import 'package:handyman_provider_flutter/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:handyman_provider_flutter/extensions/ContextExt.dart';
import 'package:handyman_provider_flutter/models/ServiceAddressesResponse.dart';

import '../main.dart';

class RegisterUserFormComponent extends StatefulWidget {
  final String? user_type;
  final UserListData? data;
  final bool isUpdate;

  RegisterUserFormComponent({this.user_type, this.data, this.isUpdate = false});

  @override
  RegisterUserFormComponentState createState() => RegisterUserFormComponentState();
}

class RegisterUserFormComponentState extends State<RegisterUserFormComponent> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController userNameCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController cPasswordCont = TextEditingController();

  FocusNode fNameFocus = FocusNode();
  FocusNode lNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode cPasswordFocus = FocusNode();

  List<Data> serviceAddressList = [];
  Data? selectedServiceAddress;

  int serviceAddressId = 0;
  int defaultAddress = 0;

  bool afterInit = false;

  @override
  void initState() {
    super.initState();
    init();
    afterBuildCreated(() {
      appStore.setLoading(true);
    });
  }

  Future<void> init() async {
    getAddressList();
    if (widget.data != null) {
      fNameCont.text = widget.data!.firstName.validate();
      lNameCont.text = widget.data!.lastName.validate();
      emailCont.text = widget.data!.email.validate();
      userNameCont.text = widget.data!.username.validate();
      mobileCont.text = widget.data!.contactNumber.validate();
      serviceAddressId = widget.data!.serviceAddressId.validate();
    }
  }

  Future<void> getAddressList() async {
    getAddresses(providerId: appStore.userId).then((value) {
      serviceAddressList.addAll(value.data!);
      value.data!.forEach((e) {
        if (e.id == serviceAddressId) {
          selectedServiceAddress = e;
        }
      });
      afterInit = true;
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      String? type = widget.user_type;
      var request = {
        if (widget.isUpdate) CommonKeys.id: widget.data!.id,
        UserKeys.firstName: fNameCont.text,
        UserKeys.lastName: lNameCont.text,
        UserKeys.userName: userNameCont.text,
        UserKeys.userType: type,
        UserKeys.providerId: appStore.userId,
        UserKeys.status: UserStatusCode,
        UserKeys.contactNumber: mobileCont.text,
        UserKeys.serviceAddressId: serviceAddressId,
        UserKeys.email: emailCont.text,
        if (!widget.isUpdate) UserKeys.password: passwordCont.text
      };
      appStore.setLoading(true);
      if (widget.isUpdate) {
        await updateProfile(request).then((res) async {
          finish(context, true);
        }).catchError((e) {
          toast(e.toString());
        });
      } else {
        await registerUser(request).then((res) async {
          finish(context, true);
        }).catchError((e) {
          toast(e.toString());
        });
      }
      appStore.setLoading(false);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.cardColor,
        appBar: appBarWidget(
          context.translate.lblAddHandyman,
          textColor: white,
          color: context.primaryColor,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      textFieldType: TextFieldType.NAME,
                      controller: fNameCont,
                      focus: fNameFocus,
                      nextFocus: lNameFocus,
                      decoration: inputDecoration(context, hint: context.translate.hintName),
                      suffix: Icon(AntDesign.user, color: context.iconColor),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.NAME,
                      controller: lNameCont,
                      focus: lNameFocus,
                      nextFocus: userNameFocus,
                      decoration: inputDecoration(context, hint: context.translate.hintLastName),
                      suffix: Icon(AntDesign.user, color: context.iconColor),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.USERNAME,
                      controller: userNameCont,
                      focus: userNameFocus,
                      nextFocus: emailFocus,
                      decoration: inputDecoration(context, hint: context.translate.hintUserName),
                      suffix: Icon(AntDesign.user, color: context.iconColor),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.EMAIL,
                      controller: emailCont,
                      focus: emailFocus,
                      nextFocus: mobileFocus,
                      decoration: inputDecoration(context, hint: context.translate.hintEmail),
                      suffix: Icon(Fontisto.email, color: context.iconColor),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.PHONE,
                      controller: mobileCont,
                      focus: mobileFocus,
                      nextFocus: passwordFocus,
                      decoration: inputDecoration(context, hint: context.translate.hintContact),
                      suffix: Icon(Ionicons.call_outline, color: context.iconColor),
                    ),
                    16.height,
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: viewLineColor, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButtonFormField<Data>(
                        decoration: InputDecoration.collapsed(hintText: null),
                        hint: Text(context.translate.selectAddress, style: secondaryTextStyle()),
                        isExpanded: true,
                        dropdownColor: context.cardColor,
                        value: selectedServiceAddress != null ? selectedServiceAddress : null,
                        items: serviceAddressList.map((data) {
                          return DropdownMenuItem<Data>(
                            value: data,
                            child: Text(
                              data.address.validate(),
                              style: primaryTextStyle(),
                            ),
                          );
                        }).toList(),
                        onChanged: (Data? value) async {
                          selectedServiceAddress = value;
                          serviceAddressId = selectedServiceAddress!.id.validate();
                          setState(() {});
                        },
                      ),
                    ).visible(serviceAddressList.isNotEmpty),
                    16.height.visible(!widget.isUpdate),
                    AppTextField(
                      textFieldType: TextFieldType.PASSWORD,
                      controller: passwordCont,
                      focus: passwordFocus,
                      decoration: inputDecoration(context, hint: context.translate.hintPass),
                      onFieldSubmitted: (s) {
                        if (getStringAsync(USER_EMAIL) != demoUser) {
                          register();
                        } else {
                          toast(context.translate.lblUnAuthorized);
                          finish(context);
                        }
                      },
                    ).visible(!widget.isUpdate),
                    24.height,
                    AppButton(
                      text: context.translate.btnSave,
                      height: 40,
                      color: primaryColor,
                      textStyle: primaryTextStyle(color: white),
                      width: context.width() - context.navigationBarHeight,
                      onTap: () {
                        if (getStringAsync(USER_EMAIL) != demoUser) {
                          register();
                        } else {
                          toast(context.translate.lblUnAuthorized);
                          finish(context);
                        }
                      },
                    ),
                    16.height,
                  ],
                ),
              ),
            ),
            Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
