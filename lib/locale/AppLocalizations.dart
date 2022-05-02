import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/locale/LanguageAr.dart';
import 'package:handyman_provider_flutter/locale/LanguageEn.dart';
import 'package:handyman_provider_flutter/locale/LanguageEs.dart';
import 'package:handyman_provider_flutter/locale/LanguageGu.dart';
import 'package:handyman_provider_flutter/locale/LanguageHi.dart';
import 'package:handyman_provider_flutter/locale/Languages.dart';
import 'package:handyman_provider_flutter/locale/LanguageAf.dart';
import 'package:handyman_provider_flutter/locale/LanguageDe.dart';
import 'package:handyman_provider_flutter/locale/LanguageFr.dart';
import 'package:handyman_provider_flutter/locale/LanguageId.dart';
import 'package:handyman_provider_flutter/locale/LanguageNl.dart';
import 'package:handyman_provider_flutter/locale/LanguagePt.dart';
import 'package:handyman_provider_flutter/locale/LanguageTr.dart';
import 'package:handyman_provider_flutter/locale/LanguageVi.dart';
import 'package:nb_utils/nb_utils.dart';

import 'LanguageSq.dart';

class AppLocalizations extends LocalizationsDelegate<Languages> {
  const AppLocalizations();

  @override
  Future<Languages> load(Locale locale) async {

    switch (locale.languageCode) {
      case 'en':
        return LanguageEn();
      case 'hi':
        return LanguageHi();
      case 'gu':
        return LanguageGu();
      case 'af':
        return LanguageAf();
      case 'ar':
        return LanguageAr();
      case 'nl':
        return LanguageNl();
      case 'de':
        return LanguageDe();
      case 'fr':
        return LanguageFr();
      case 'id':
        return LanguageId();
      case 'pt':
        return LanguagePt();
      case 'es':
        return LanguageEs();
      case 'tr':
        return LanguageTr();
      case 'vi':
        return LanguageVi();
      case 'sq':
        return LanguageSq();
      default:
        return LanguageEn();
    }
  }

  @override
  bool isSupported(Locale locale) => LanguageDataModel.languages().contains(locale.languageCode);

  @override
  bool shouldReload(LocalizationsDelegate<Languages> old) => false;
}
