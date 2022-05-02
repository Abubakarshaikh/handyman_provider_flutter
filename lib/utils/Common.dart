import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:handyman_provider_flutter/components/AppWidgets.dart';
import 'package:handyman_provider_flutter/utils/Constant.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import 'Colors.dart';
import 'Images.dart';

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(id: 1, name: 'English', languageCode: 'en', fullLanguageCode: 'en-US', flag: 'images/flag/ic_us.png'),
    LanguageDataModel(id: 2, name: 'Hindi', languageCode: 'hi', fullLanguageCode: 'hi-IN', flag: 'images/flag/ic_india.png'),
    LanguageDataModel(id: 3, name: 'Gujrati', languageCode: 'gu', fullLanguageCode: 'gu-IN', flag: 'images/flag/ic_india.png'),
    LanguageDataModel(id: 4, name: 'afrikaan', languageCode: 'af', fullLanguageCode: 'ar-AF', flag: 'images/flag/ic_ar.png'),
    LanguageDataModel(id: 5, name: 'Arabic', languageCode: 'ar', fullLanguageCode: 'ar-AR', flag: 'images/flag/ic_ar.png'),
    LanguageDataModel(id: 6, name: 'Dutch', languageCode: 'nl', fullLanguageCode: 'nl-NL', flag: 'images/flag/ic_nl.png'),
    LanguageDataModel(id: 7, name: 'French', languageCode: 'fr', fullLanguageCode: 'fr-FR', flag: 'images/flag/ic_fr.png'),
    LanguageDataModel(id: 8, name: 'German', languageCode: 'de', fullLanguageCode: 'de-DE', flag: 'images/flag/ic_de.png'),
    LanguageDataModel(id: 9, name: 'Indonesian', languageCode: 'id', fullLanguageCode: 'id-ID', flag: 'images/flag/ic_id.png'),
    LanguageDataModel(id: 10, name: 'Portugal', languageCode: 'pt', fullLanguageCode: 'pt-PT', flag: 'images/flag/ic_pt.png'),
    LanguageDataModel(id: 11, name: 'Spanish', languageCode: 'es', fullLanguageCode: 'es-ES', flag: 'images/flag/ic_es.png'),
    LanguageDataModel(id: 12, name: 'Turkish', languageCode: 'tr', fullLanguageCode: 'tr-TR', flag: 'images/flag/ic_tr.png'),
    LanguageDataModel(id: 13, name: 'Vietnam', languageCode: 'vi', fullLanguageCode: 'vi-VI', flag: 'images/flag/ic_vi.png'),
    LanguageDataModel(id: 14, name: 'Albanian', languageCode: 'sq', fullLanguageCode: 'sq-SQ', flag: 'images/flag/ic_arbanian.png'),
  ];
}

InputDecoration inputDecoration(BuildContext context, {String? hint, Widget? prefixIcon}) {
  return InputDecoration(
    // labelStyle: TextStyle(color: Theme.of(context).textTheme.headline6!.color),
    labelStyle: secondaryTextStyle(),
    contentPadding: EdgeInsets.all(8),
    labelText: hint,
    hintStyle: secondaryTextStyle(),
    prefixIcon: prefixIcon,
    enabledBorder: OutlineInputBorder(
      borderRadius: radius(defaultRadius),
      borderSide: BorderSide(color: viewLineColor, width: 1.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(defaultRadius),
      borderSide: BorderSide(color: Colors.red, width: 1.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(defaultRadius),
      borderSide: BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2,
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(defaultRadius),
      borderSide: BorderSide(color: primaryColor, width: 1.0),
    ),
  );
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

Widget setLoader() {
  return Container(
      padding: EdgeInsets.all(8),
      decoration: boxDecorationWithRoundedCorners(backgroundColor: primaryColor.withOpacity(0.1), borderRadius: radius(60)),
      child: cachedImage(loaderGif, height: 80, width: 80, fit: BoxFit.cover));
}

Widget noDataFound() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      cachedImage(notDataFoundImg, height: 200, width: 200),
      8.height,
      Text('No Data Found', style: boldTextStyle()),
    ],
  );
}

String formateDate(String? dateTime) {
  return "${DateFormat.yMd().add_jm().format(DateTime.parse(dateTime.validate()))}";
}

String durationToString(int minutes) {
  var d = Duration(minutes: minutes);
  List<String> parts = d.toString().split(':');
  return '${parts[0].padLeft(2, '0')} :${parts[1].padLeft(2, '0')} min';
}

String getFirstWord(String inputString) {
  List<String> wordList = inputString.split(" ");
  if (wordList.isNotEmpty) {
    return wordList[0];
  } else {
    return ' ';
  }
}

Widget confirmationButton(BuildContext context, String btnTxt, IconData iconData, {Function? onTap}) {
  return AppButton(
    elevation: 0,
    padding: EdgeInsets.zero,
    color: Colors.transparent,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(iconData, color: context.iconColor, size: 24),
        8.width,
        Text(btnTxt, style: primaryTextStyle()),
      ],
    ),
    onTap: onTap,
  );
}

Widget statusButton(double width, String btnTxt, Color color, Color txtcolor, {Function? onTap}) {
  return AppButton(
    width: width,
    padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
    elevation: 0,
    color: color,
    shapeBorder: RoundedRectangleBorder(
      borderRadius: radius(defaultAppButtonRadius),
      side: BorderSide(color: primaryColor),
    ),
    child: Text(
      btnTxt,
      style: boldTextStyle(color: txtcolor),
      textAlign: TextAlign.justify,
    ),
    onTap: onTap,
  );
}

Future<void> launchUrl(String url, {bool forceWebView = false, bool forceSafariVC = false}) async {
  await launch(url, forceWebView: forceWebView, enableJavaScript: true, forceSafariVC: forceSafariVC).catchError((e) {
    toast('Invalid URL: $url');
  });
}

Future<void> launchMap(String address) async {
  await launch("https://www.google.com/maps/search/?api=1&query=" + address).catchError((e) {
    toast('Invalid URL' + ': $address');
  });
}

Future<void> saveOneSignalPlayerId() async {
  await OneSignal.shared.getDeviceState().then((value) async {
    if (value!.userId.validate().isNotEmpty) await setValue(PLAYERID, value.userId.validate());
  });
}

calculateLatLong(String address) async {
  try {
    List<Location> destinationPlacemark = await locationFromAddress(address);
    double? destinationLatitude = destinationPlacemark[0].latitude;
    double? destinationLongitude = destinationPlacemark[0].longitude;
    List<double?> destinationCoordinatesString = [destinationLatitude, destinationLongitude];
    return destinationCoordinatesString;
  } catch (e) {
    throw errorSomethingWentWrong;
  }
}

bool get isRTL => RTLLanguage.contains(appStore.selectedLanguageCode);

Color getRateColor(num rating) {
  if (rating.validate() == 1) {
    return primaryColor;
  } else if (rating.validate() == 2) {
    return yellowColor;
  } else if (rating.validate() == 3) {
    return yellowColor;
  } else {
    return Color(0xFF66953A);
  }
}
