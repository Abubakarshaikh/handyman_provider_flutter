import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:handyman_provider_flutter/components/AppWidgets.dart';
import 'package:handyman_provider_flutter/networks/RestApis.dart';
import 'package:handyman_provider_flutter/screens/LoginScreen.dart';
import 'package:handyman_provider_flutter/utils/Colors.dart';
import 'package:handyman_provider_flutter/utils/Common.dart';
import 'package:handyman_provider_flutter/utils/Constant.dart';
import 'package:handyman_provider_flutter/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:handyman_provider_flutter/extensions/ContextExt.dart';
import '../main.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController oldPasswordCont = TextEditingController();
  TextEditingController newPasswordCont = TextEditingController();
  TextEditingController reenterPasswordCont = TextEditingController();

  FocusNode oldPasswordFocus = FocusNode();
  FocusNode newPasswordFocus = FocusNode();
  FocusNode reenterPasswordFocus = FocusNode();

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

  Future<void> changePassword() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      var request = {
        UserKeys.oldPassword: oldPasswordCont.text,
        UserKeys.newPassword: newPasswordCont.text,
      };
      appStore.setLoading(true);

      await changeUserPassword(request).then((res) async {
        toast(res.message);
        LoginScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
      }).catchError((e) {
        toast(e.toString(), print: true);
      });
      appStore.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context.translate.changePassword, textColor: white, color: context.primaryColor, elevation: 0.0),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Container(
              height: context.height(),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.PASSWORD,
                      controller: oldPasswordCont,
                      focus: oldPasswordFocus,
                      nextFocus: newPasswordFocus,
                      decoration: inputDecoration(context, hint: context.translate.hintOldPasswordTxt),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.PASSWORD,
                      controller: newPasswordCont,
                      focus: newPasswordFocus,
                      nextFocus: reenterPasswordFocus,
                      decoration: inputDecoration(context, hint: context.translate.hintNewPasswordTxt),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.PASSWORD,
                      controller: reenterPasswordCont,
                      focus: reenterPasswordFocus,
                      validator: (v) {
                        if (newPasswordCont.text != v) {
                          return context.translate.passwordNotMatch;
                        } else if (reenterPasswordCont.text.isEmpty) {
                          return errorThisFieldRequired;
                        }
                      },
                      onFieldSubmitted: (s) {
                        if (getStringAsync(USER_EMAIL) != demoUser) {
                          changePassword();
                        } else {
                          toast(context.translate.lblUnAuthorized);
                          finish(context);
                        }
                      },
                      decoration: inputDecoration(context, hint: context.translate.hintReenterPasswordTxt),
                    ),
                    24.height,
                    AppButton(
                      text: context.translate.confirm,
                      height: 40,
                      color: primaryColor,
                      textStyle: primaryTextStyle(color: white),
                      width: context.width() - context.navigationBarHeight,
                      onTap: () {
                        if (getStringAsync(USER_EMAIL) != demoUser) {
                          changePassword();
                        } else {
                          toast(context.translate.lblUnAuthorized);
                          finish(context);
                        }
                      },
                    ),
                    24.height,
                  ],
                ),
              ),
            ),
          ),
          Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
          if (showMobileAds && myBanner != null)
            Positioned(
              child: Container(
                child: AdWidget(ad: myBanner!),
                color: context.cardColor,
                width: context.width(),
                height: myBanner!.size.height.toDouble(),
              ),
              bottom: 0,
            )
        ],
      ),
    );
  }
}
