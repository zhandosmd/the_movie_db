import 'package:flutter/material.dart';

class LocalizedModelStorage {
  String _localeTag = '';
  String get localeTag => _localeTag;

  bool updateLocal(Locale locale){
    final localeTag = locale.toLanguageTag();
    if (_localeTag == localeTag) return false;
    _localeTag = localeTag;
    return true;
  }
}