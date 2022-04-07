import 'package:flutter/cupertino.dart';

import 'package:hive/hive.dart';

import '../../res/strings.dart';
import '../models/local_lang.dart';

abstract class LangRepository {
  Future<void> init();
  bool get isEmpty;
  Future<Locale> getLang();
  Future<void> updateLang(String langCode);
  Future<void> addLang(String langCode);
}

class LangRepositoryImpl implements LangRepository {
  late Box<LocalLang> _localLangBox;

  @override
  Future<void> init() async {
    Hive.registerAdapter(LocalLangAdapter());
    _localLangBox = await Hive.openBox<LocalLang>(AppStrings.langBoxKey);
  }

  bool get isEmpty => _localLangBox.isEmpty;

  @override
  Future<Locale> getLang() async {
    LocalLang localOpj = _localLangBox.values.first;
    return Locale(localOpj.langCode);
  }

  @override
  Future<void> updateLang(String langCode) async {
    LocalLang localOpj = _localLangBox.values.first;
    await _localLangBox.put(localOpj.key, LocalLang(langCode));
  }

  @override
  Future<void> addLang(String langCode) async {
    if (_localLangBox.values.isEmpty) {
      _localLangBox.add(LocalLang(langCode));
    }
  }
}
