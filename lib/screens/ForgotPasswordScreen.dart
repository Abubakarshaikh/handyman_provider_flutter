import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/AppWidgets.dart';
import 'package:handyman_provider_flutter/networks/RestApis.dart';
import 'package:handyman_provider_flutter/utils/Colors.dart';
import 'package:handyman_provider_flutter/utils/Common.dart';
import 'package:handyman_provider_flutter/utils/Constant.dart';
import 'package:handyman_provider_flutter/utils/ModelKeys.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:handyman_provider_flutter/extensions/ContextExt.dart';

import '../main.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailCont = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  Future<void> forgotPwd() async {
    if (formKey.currentState!.validate()) {
      Map req = {UserKeys.email: emailCont.text.validate()};
      forgotPassword(req).then((value) {
        appStore.setLoading(false);
        toast(value.message.toString());
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString(), print: true);
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.primaryColor,
      body: Stack(
        children: [
          SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.translate.forgotPassword,
                    style: boldTextStyle(size: 28, color: white),
                  ).paddingOnly(left: 16),
                  16.height,
                  Container(
                    margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    padding: EdgeInsets.all(16),
                    alignment: Alignment.bottomCenter,
                    decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), blurRadius: 0, backgroundColor: context.cardColor),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.translate.forgotPasswordTitleTxt, style: primaryTextStyle(color: primaryColor).copyWith(height: 1.5)),
                          24.height,
                          AppTextField(
                            textFieldType: TextFieldType.EMAIL,
                            controller: emailCont,
                            decoration: inputDecoration(context, hint: context.translate.hintEmail),
                            onFieldSubmitted: (s) {
                              if (emailCont.text != demoUser) {
                                appStore.setLoading(true);
                                forgotPwd();
                              } else {
                                toast(context.translate.lblUnAuthorized);
                                finish(context);
                              }
                            },
                          ),
                          24.height,
                          AppButton(
                            text: context.translate.resetPassword,
                            height: 40,
                            color: primaryColor,
                            textStyle: primaryTextStyle(color: white),
                            width: context.width() - context.navigationBarHeight,
                            onTap: () {
                              if (emailCont.text != demoUser) {
                                appStore.setLoading(true);
                                forgotPwd();
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
                ],
              )).center(),
          Observer(
            builder: (_) => LoaderWidget().center().visible(appStore.isLoading),
          ),
          IconButton(onPressed: () => finish(context), icon: Icon(Icons.arrow_back, size: 28, color: white)).paddingTop(32),
        ],
      ),
    );
  }
}
