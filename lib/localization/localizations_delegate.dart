// @dart=2.9
import 'dart:async';
import 'package:flutter/material.dart';
import 'translate.dart';

class MyLocalizationsDelegate extends LocalizationsDelegate<Tran> {
  const MyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['zh', 'en', 'my'].contains(locale.languageCode);

  @override
  Future<Tran> load(Locale locale) async {
    Tran localizations = Tran(locale);
    await localizations.load();

    //

    return localizations;
  }

  @override
  bool shouldReload(MyLocalizationsDelegate old) => false;
  // @override
  // Future<Tran> load(Locale locale) async {
  //   Tran localizations = Tran(locale);
  //   await localizations.load();
  //
  //   return localizations;
  // }
  //
  // @override
  // bool shouldReload(MyLocalizationsDelegate old) => false;
}
