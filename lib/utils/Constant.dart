import 'package:nb_utils/nb_utils.dart';

const mAppName = 'Provider';

//region URLs & Keys
const mBaseUrl = 'https://wordpress.iqonic.design/product/mobile/booking-service/api/';

const mOneSignalAppId = '01e97a22-4721-475e-a96d-62948ebfbaf4';
const mOneSignalChannelId = "0ee01f0d-2e1c-4554-9050-27dd9c020292";
const mOneSignalRestKey = "NzFhNDZjYTEtOWUzYS00NzgxLThlZDktODYyYWZmOTQ1ODJk";

const mAppIconUrl = "images/ic_splash_logo.png";

const demoUser = "demo@provider.com";

//region Configs
const defaultLanguage = 'en';
const perPageItem = 5;

//region Messages
var passwordLengthMsg = 'Password length should be more than $passwordLengthGlobal';
//endregion

//MapKey
const API_KEY = 'AIzaSyCHJwjZjGSOBc18-3mJM8tCqDYoV3Nk9tQ';

//region LiveStream Keys
const tokenStream = 'tokenStream';
const streamTab = 'streamTab';

/* Theme Mode Type */
const ThemeModeLight = 0;
const ThemeModeDark = 1;
const ThemeModeSystem = 2;

//region SharedPreferences Keys
const IS_FIRST_TIME = 'IsFirstTime';
const IS_LOGGED_IN = 'IS_LOGGED_IN';
const USER_ID = 'USER_ID';
const FIRST_NAME = 'FIRST_NAME';
const LAST_NAME = 'LAST_NAME';
const USER_EMAIL = 'USER_EMAIL';
const PROFILE_IMAGE = 'PROFILE_IMAGE';
const IS_REMEMBERED = "IS_REMEMBERED";
const TOKEN = 'TOKEN';
const USERNAME = 'USERNAME';
const DISPLAY_NAME = 'DISPLAY_NAME';
const CONTACT_NUMBER = 'CONTACT_NUMBER';
const COUNTRY_ID = 'COUNTRY_ID';
const STATE_ID = 'STATE_ID';
const CITY_ID = 'CITY_ID';
const STATUS = 'STATUS';
const ADDRESS = 'ADDRESS';
const PLAYERID = 'PLAYERID';
const UID = 'UID';

/* Login Type */
const UserTypeProvider = 'provider';
const UserTypeHandyman = 'handyman';
const UserStatusCode = 1;

/* Notification Mark as Read */
const MarkAsRead = 'markas_read';

/*service type*/
const HOURLY = 'hourly';
const FIXED = 'fixed';
const TXT_HOURLY = 'hr';

/*service payment method*/
const COD = 'cash';

/*service payment status*/
const PAID = 'paid';
const PENDING = 'pending';

/* default handyman login*/
const DEFAULT_EMAIL = 'demo@provider.com';
const DEFAULT_PASS = '12345678';

/*currency*/
const CURRENCY_COUNTRY_SYMBOL = 'CURRENCY_COUNTRY_SYMBOL';
const CURRENCY_COUNTRY_CODE = 'CURRENCY_COUNTRY_CODE';
const CURRENCY_COUNTRY_ID = 'CURRENCY_COUNTRY_ID';

/*ADS*/
const showMobileAds = true;
const INITIAL_AD_COUNT = 'INITIAL_AD_COUNT';
const SHOW_INITIAL_AD_NUMBER = 3;
const maxFailedLoadAttempts = 3;
const bannerAdIdForAndroid = 'ca-app-pub-3940256099942544/6300978111';
const bannerAdIdForIos = 'ca-app-pub-3940256099942544/2934735716';

/*URL*/
const MAIL_TO = 'mailto:';
const TEL = 'tel:';

///FireBase Collection Name
const MESSAGES_COLLECTION = "messages";
const USER_COLLECTION = "users";
const CONTACT_COLLECTION = "contact";
const CHAT_DATA_IMAGES = "chatImages";

const IS_ENTER_KEY = "IS_ENTER_KEY";
const SELECTED_WALLPAPER = "SELECTED_WALLPAPER";
const PER_PAGE_CHAT_COUNT = 50;

const TEXT = "TEXT";
const IMAGE = "IMAGE";

const VIDEO = "VIDEO";
const AUDIO = "AUDIO";

List<String> RTLLanguage = ['ar', 'ur'];

enum MessageType {
  TEXT,
  IMAGE,
  VIDEO,
  AUDIO,
}

extension MessageExtension on MessageType {
  String? get name {
    switch (this) {
      case MessageType.TEXT:
        return 'TEXT';
      case MessageType.IMAGE:
        return 'IMAGE';
      case MessageType.VIDEO:
        return 'VIDEO';
      case MessageType.AUDIO:
        return 'AUDIO';
      default:
        return null;
    }
  }
}
