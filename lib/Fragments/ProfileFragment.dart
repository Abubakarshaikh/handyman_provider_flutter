import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:handyman_provider_flutter/components/AppWidgets.dart';
import 'package:handyman_provider_flutter/components/ThemeSelectionDaiLog.dart';
import 'package:handyman_provider_flutter/networks/RestApis.dart';
import 'package:handyman_provider_flutter/screens/ServiceAddressesScreen.dart';
import 'package:handyman_provider_flutter/screens/ChangePasswordScreen.dart';
import 'package:handyman_provider_flutter/screens/EditProfileScreen.dart';
import 'package:handyman_provider_flutter/screens/HandymanListScreen.dart';
import 'package:handyman_provider_flutter/screens/LanguagesScreen.dart';
import 'package:handyman_provider_flutter/screens/ServiceListScreen.dart';
import 'package:handyman_provider_flutter/utils/Colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:handyman_provider_flutter/extensions/ContextExt.dart';
import '../main.dart';

class ProfileFragment extends StatefulWidget {
  @override
  ProfileFragmentState createState() => ProfileFragmentState();
}

class ProfileFragmentState extends State<ProfileFragment> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      appStore.setLoading(true);
      init();
    });
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    setStatusBarColor(context.primaryColor);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Observer(
          builder: (_) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (appStore.userProfileImage.isNotEmpty) cachedImage(appStore.userProfileImage, height: 65, width: 65, fit: BoxFit.cover).cornerRadiusWithClipRRect(40),
                    16.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appStore.userFullName, style: boldTextStyle(color: primaryColor)),
                        4.height,
                        Text(appStore.userEmail, style: secondaryTextStyle()),
                      ],
                    ).expand(),
                    IconButton(
                      icon: Icon(AntDesign.edit, color: primaryColor, size: 20),
                      onPressed: () {
                        EditProfileScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                      },
                    )
                  ],
                ).paddingOnly(left: 16, right: 8, top: 16, bottom: 8).visible(appStore.isLoggedIn),
                Divider(height: 5, thickness: 1.2),
                SettingItemWidget(
                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                  leading: Icon(Icons.location_on_outlined, color: context.iconColor),
                  title: context.translate.lblServiceAddress,
                  onTap: () {
                    ServiceAddressesScreen(false).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                  },
                ),
                Divider(height: 5),
                SettingItemWidget(
                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                  leading: Icon(Icons.miscellaneous_services_outlined, color: context.iconColor),
                  title: context.translate.lblServices,
                  onTap: () {
                    ServiceListScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                  },
                ),
                Divider(height: 5),
                SettingItemWidget(
                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                  leading: Icon(MaterialCommunityIcons.account_outline, color: context.iconColor),
                  title: context.translate.handyman,
                  onTap: () {
                    HandymanListScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                  },
                ),
                Divider(height: 5),
                SettingItemWidget(
                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                  leading: Icon(FontAwesome.language, color: context.iconColor),
                  title: context.translate.language,
                  onTap: () {
                    LanguagesScreen().launch(context);
                  },
                ),
                Divider(height: 5),
                SettingItemWidget(
                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                  leading: Icon(Ionicons.color_palette_outline, color: context.iconColor),
                  title: context.translate.appTheme,
                  onTap: () async {
                    await showInDialog(
                      context,
                      builder: (context) => ThemeSelectionDaiLog(context),
                      contentPadding: EdgeInsets.zero,
                      title: Text(context.translate.chooseTheme, style: boldTextStyle(size: 20)),
                    );
                  },
                ),
                Divider(height: 5),
                SettingItemWidget(
                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                  leading: Icon(Ionicons.key_outline, color: context.iconColor),
                  title: context.translate.changePassword,
                  onTap: () {
                    ChangePasswordScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                  },
                ),
                Divider(height: 5),
                SettingItemWidget(
                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                  leading: Icon(MaterialCommunityIcons.logout, color: context.iconColor),
                  title: context.translate.logout,
                  onTap: () {
                    logout(context);
                  },
                ),
                24.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
