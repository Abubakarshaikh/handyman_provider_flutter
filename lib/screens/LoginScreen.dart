import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:handyman_provider_flutter/chatServices/AuthSertvices.dart';
import 'package:handyman_provider_flutter/components/AppWidgets.dart';
import 'package:handyman_provider_flutter/models/ProfileUpdateResponse.dart';
import 'package:handyman_provider_flutter/networks/NetworkUtils.dart';
import 'package:handyman_provider_flutter/networks/RestApis.dart';
import 'package:handyman_provider_flutter/screens/DashboardScreen.dart';
import 'package:handyman_provider_flutter/screens/SingUpScreen.dart';
import 'package:handyman_provider_flutter/utils/Colors.dart';
import 'package:handyman_provider_flutter/utils/Common.dart';
import 'package:handyman_provider_flutter/utils/Constant.dart';
import 'package:handyman_provider_flutter/utils/ModelKeys.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:handyman_provider_flutter/extensions/ContextExt.dart';

import '../main.dart';
import 'ForgotPasswordScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AuthServices authService = AuthServices();

  late TextEditingController emailCont = TextEditingController(text: DEFAULT_EMAIL);
  late TextEditingController passwordCont = TextEditingController(text: DEFAULT_PASS);

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  Future<void> init() async {
    if (getStringAsync(PLAYERID).isEmpty) saveOneSignalPlayerId();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      //
      var request = {
        UserKeys.email: emailCont.text,
        UserKeys.password: passwordCont.text,
        UserKeys.playerId: getStringAsync(PLAYERID),
      };

      appStore.setLoading(true);
      await loginUser(request).then((res) async {
        if (res.data!.uid.validate().isNotEmpty) {
          authService.signInWithEmailPassword(context, email: emailCont.text, password: passwordCont.text).then((value) {
            toast(context.translate.loginSuccessfully);
            if (res.data!.status.validate() != 0) {
              if (res.data!.userType == UserTypeProvider) {
                DashboardScreen(index: 0).launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
              } else {
                toast(context.translate.cantLogin, print: true);
              }
            } else {
              appStore.setLoading(false);
              toast(context.translate.lblWaitForAcceptReq);
            }
          });
        } else {
          authService.signIn(context, res: res, email: emailCont.text, password: passwordCont.text).then((value) async {
            toast(context.translate.loginSuccessfully);
            if (res.data!.status.validate() != 0) {
              MultipartRequest multiPartRequest = await getMultiPartRequest('update-profile');
              multiPartRequest.fields[UserKeys.uid] = getStringAsync(UID);

              multiPartRequest.headers.addAll(buildHeaderTokens());
              appStore.setLoading(true);
              sendMultiPartRequest(
                multiPartRequest,
                onSuccess: (data) async {
                  appStore.setLoading(false);
                  if (data != null) {
                    if ((data as String).isJson()) {
                      ProfileUpdateResponse res = ProfileUpdateResponse.fromJson(jsonDecode(data));
                      saveUserData(res.data!);
                      DashboardScreen(index: 0).launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
                      toast(res.message, print: true);
                      finish(context);
                    }
                  }
                },
                onError: (error) {
                  toast(error.toString(), print: true);
                  appStore.setLoading(false);
                },
              );
            } else {
              toast(context.translate.lblContactAdmin);
            }
          });
        }
      }).catchError((e) {
        toast(e.toString(), print: true);
        appStore.setLoading(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.primaryColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.translate.welcome, style: boldTextStyle(size: 28, color: white)).paddingOnly(left: 16, bottom: 8),
                Text(context.translate.back, style: boldTextStyle(size: 28, color: white)).paddingOnly(left: 16),
                32.height,
                Container(
                  margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.bottomCenter,
                  decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), blurRadius: 0, backgroundColor: context.cardColor),
                  child: AutofillGroup(
                    child: Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          16.height,
                          Text(context.translate.appName, style: boldTextStyle(size: 20, color: primaryColor).copyWith(height: 1.5)),
                          24.height,
                          AppTextField(
                            textFieldType: TextFieldType.EMAIL,
                            controller: emailCont,
                            focus: emailFocus,
                            nextFocus: passwordFocus,
                            errorThisFieldRequired: context.translate.hintRequired,
                            decoration: inputDecoration(context, hint: context.translate.hintEmailAddress),
                            suffix: Icon(Fontisto.email, color: context.iconColor),
                            autoFillHints: [AutofillHints.email],
                          ),
                          16.height,
                          AppTextField(
                            textFieldType: TextFieldType.PASSWORD,
                            controller: passwordCont,
                            focus: passwordFocus,
                            errorThisFieldRequired: context.translate.hintRequired,
                            decoration: inputDecoration(context, hint: context.translate.hintPassword),
                            autoFillHints: [AutofillHints.password],
                            onFieldSubmitted: (s) {
                              login();
                            },
                          ),
                          12.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  4.width,
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: Checkbox(
                                      value: getBoolAsync(IS_REMEMBERED, defaultValue: true),
                                      onChanged: (v) async {
                                        await setValue(IS_REMEMBERED, v);
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  4.width,
                                  Text(context.translate.rememberMe, style: secondaryTextStyle()).onTap(
                                    () async {
                                      await setValue(IS_REMEMBERED, !getBoolAsync(IS_REMEMBERED));
                                    },
                                  ),
                                ],
                              ),
                              Text(context.translate.forgotPassword, style: secondaryTextStyle()).onTap(
                                () {
                                  ForgotPasswordScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                                },
                              ),
                            ],
                          ),
                          24.height,
                          Container(
                            decoration: boxDecorationWithRoundedCorners(
                              borderRadius: radius(defaultRadius),
                              gradient: LinearGradient(
                                  colors: [primaryColor, Color(0xFF00CCFF)], begin: FractionalOffset(0.0, 0.0), end: FractionalOffset(1.0, 0.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                            ),
                          ),
                          AppButton(
                            text: context.translate.signIn,
                            height: 40,
                            color: primaryColor,
                            textStyle: primaryTextStyle(color: white),
                            width: context.width() - context.navigationBarHeight,
                            onTap: () {
                              login();
                            },
                          ),
                          16.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(context.translate.doNotHaveAccount, style: secondaryTextStyle()),
                              TextButton(
                                  onPressed: () {
                                    SignUpScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                                  },
                                  child: Text(context.translate.signUp, style: secondaryTextStyle(color: primaryColor)))
                            ],
                          ),
                          16.height
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ).center(),
          Observer(
            builder: (_) => LoaderWidget().center().visible(appStore.isLoading),
          ),
        ],
      ),
    );
  }
}
