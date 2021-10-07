// @dart=2.9
import 'dart:async';
import 'package:flutter/material.dart';
import 'Translate.dart';

class MyLocalizationsDelegate extends LocalizationsDelegate<Tran> {
  const MyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['zh','en','my','th'].contains(locale.languageCode);

  @override
  Future<Tran> load(Locale locale) async {
    Tran localizations = new Tran(locale);
    await localizations.load();

    //print("Load ${locale.languageCode}");

    return localizations;
  }

  @override
  bool shouldReload(MyLocalizationsDelegate old) => false;
}