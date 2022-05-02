import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:handyman_provider_flutter/chatServices/AuthSertvices.dart';
import 'package:handyman_provider_flutter/components/AppWidgets.dart';
import 'package:handyman_provider_flutter/utils/Colors.dart';
import 'package:handyman_provider_flutter/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:handyman_provider_flutter/extensions/ContextExt.dart';

import '../main.dart';

class SignUpScreen extends StatefulWidget {
  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AuthServices authService = AuthServices();
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

  @override
  void initState() {
    super.initState();
    init();
    afterBuildCreated(() {});
  }

  Future<void> init() async {
    //
  }

  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      hideKeyboard(context);
      appStore.setLoading(true);

      authService
          .signUpWithEmailPassword(context,
              lName: lNameCont.text, userName: userNameCont.text, name: fNameCont.text.trim(), email: emailCont.text.trim(), password: passwordCont.text.trim(), mobileNumber: mobileCont.text.trim())
          .then((value) async {
        //
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
        alignment: Alignment.topLeft,
        children: [
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.fromLTRB(16, 80, 16, 32),
              padding: EdgeInsets.all(16),
              decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), blurRadius: 0, backgroundColor: context.cardColor),
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.translate.lblCreateAccount, style: boldTextStyle(size: 20, color: primaryColor).copyWith(height: 1.5)).center(),
                    24.height,
                    AppTextField(
                      textFieldType: TextFieldType.NAME,
                      controller: fNameCont,
                      focus: fNameFocus,
                      nextFocus: lNameFocus,
                      errorThisFieldRequired: context.translate.hintRequired,
                      decoration: inputDecoration(context, hint: context.translate.hintFirstNm),
                      suffix: Icon(AntDesign.user, color: context.iconColor),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.NAME,
                      controller: lNameCont,
                      focus: lNameFocus,
                      nextFocus: userNameFocus,
                      errorThisFieldRequired: context.translate.hintRequired,
                      decoration: inputDecoration(context, hint: context.translate.hintLastNm),
                      suffix: Icon(AntDesign.user, color: context.iconColor),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.USERNAME,
                      controller: userNameCont,
                      focus: userNameFocus,
                      nextFocus: emailFocus,
                      errorThisFieldRequired: context.translate.hintRequired,
                      decoration: inputDecoration(context, hint: context.translate.hintUserNm),
                      suffix: Icon(AntDesign.user, color: context.iconColor),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.EMAIL,
                      controller: emailCont,
                      focus: emailFocus,
                      nextFocus: mobileFocus,
                      errorThisFieldRequired: context.translate.hintRequired,
                      decoration: inputDecoration(context, hint: context.translate.hintEmailAddress),
                      suffix: Icon(Fontisto.email, color: context.iconColor),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.PHONE,
                      controller: mobileCont,
                      focus: mobileFocus,
                      nextFocus: passwordFocus,
                      errorThisFieldRequired: context.translate.hintRequired,
                      decoration: inputDecoration(context, hint: context.translate.hintContactNumber),
                      suffix: Icon(Ionicons.call_outline, color: context.iconColor),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.PASSWORD,
                      controller: passwordCont,
                      focus: passwordFocus,
                      errorThisFieldRequired: context.translate.hintRequired,
                      decoration: inputDecoration(context, hint: context.translate.hintPassword),
                      onFieldSubmitted: (s) {
                        register();
                      },
                    ),
                    24.height,
                    AppButton(
                      text: context.translate.signUp,
                      height: 40,
                      color: primaryColor,
                      textStyle: primaryTextStyle(color: white),
                      width: context.width() - context.navigationBarHeight,
                      onTap: () {
                        register();
                      },
                    ),
                    16.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(context.translate.alreadyHaveAccountTxt + ' ?', style: secondaryTextStyle()),
                        TextButton(
                            onPressed: () {
                              finish(context);
                            },
                            child: Text(context.translate.signIn, style: secondaryTextStyle(color: primaryColor))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ).center(),
          Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
          IconButton(onPressed: () => finish(context), icon: Icon(Icons.arrow_back, size: 28, color: white)).paddingTop(32)
        ],
      ),
    );
  }
}
