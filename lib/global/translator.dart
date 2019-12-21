import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo_list_for_doit_software/model/language.dart';

/// Usage.
///
/// 1. If you want text of 'app_name' anywhere.
/// eg. Translator.of(context).text('app_name');
///
/// 2. If you add text/string.
/// The resource file of English is 'res/locale/en.json', so write there text you want.
///
/// 3. If you add another language text/string.
/// Create resource file of language you want from 'assets/locale' folder.
/// A resource file name rules is '<Language Code>.json'.
/// eg. The file name is 'es.json' if you want to create a Spanish resource.

class Translator {
  Translator(this.locale);

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static Translator of(BuildContext context) =>
      Localizations.of<Translator>(context, Translator);

  static const supportedLanguage = {
    const Language(language: 'English', code: 'en', countryCode: 'US'),
  };

  static final supportedLocales = supportedLanguage
      .map((language) => new Locale(language.code, language.countryCode));

  static const LocalizationsDelegate<Translator> delegate =
  _TranslatorDelegate();

  static const Iterable<LocalizationsDelegate<dynamic>> supportedDelegates = [
    Translator.delegate,
    // Built-in localization of basic text for Material widgets
    GlobalMaterialLocalizations.delegate,
    // Built-in localization for text direction LTR/RTL
    GlobalWidgetsLocalizations.delegate,
    // For iOS
    GlobalCupertinoLocalizations.delegate,
  ];

  static LocaleResolutionCallback resolutionCallback =
      (Locale locale, Iterable<Locale> supportedLocales) {
    // Check if the current device locale is supported
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode &&
          supportedLocale.countryCode == locale.countryCode) {
        return supportedLocale;
      }
    }
    // If the locale of the device is not supported, use the first one
    // from the list (English, in this case).
    return supportedLocales.first;
  };

  final Locale locale;
  static Map<String, String> _localizedValues;

  static Future<Translator> load(Locale locale) async {
    Translator translator = Translator(locale);
    // Load the language JSON file from the "assets/locale" folder.
    String jsonString =
    await rootBundle.loadString('res/locales/${locale.languageCode}.json');

    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedValues =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
    return translator;
  }

  get currentLanguage => locale.languageCode;

  String text(String key) => _localizedValues[key] ?? "$key not found";

  String appName() => _localizedValues["app_name"] ?? "not found";

  String signIn() => _localizedValues["sign_in"] ?? "not found";

}

// LocalizationsDelegate is a factory for a set of localized resources
// In this case, the localized strings will be gotten in an LocalizationsSupport object
class _TranslatorDelegate extends LocalizationsDelegate<Translator> {
  const _TranslatorDelegate();

  @override
  bool isSupported(Locale locale) => Translator.supportedLanguage
      .map((language) => language.code)
      .contains(locale.languageCode);

  @override
  Future<Translator> load(Locale locale) => Translator.load(locale);

  @override
  bool shouldReload(_TranslatorDelegate old) => false;
}
