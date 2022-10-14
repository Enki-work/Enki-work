import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../BannerAdModel.dart';
import 'PurchaseModel.dart';

part 'AppConfigState.freezed.dart';

@freezed
class AppConfigState with _$AppConfigState {
  const AppConfigState._();
  const factory AppConfigState({
    @Default("") String android_inline_banner,
    @Default("") String android_inline_native,
    @Default("") String android_appid,
    @Default("") String ios_inline_banner,
    @Default("") String ios_inline_native,
    @Default("") String ios_appid,
    @Default("") String estatAppId,
    @Default(true) bool isThemeFollowSystem,
    @Default(false) bool isThemeDarkMode,
    PurchaseModel? purchaseModel,
    BannerAdModel? bannerAdModel,
  }) = _AppConfigState;

  ThemeMode get getThemeMode {
    if (isThemeFollowSystem) {
      return ThemeMode.system;
    } else if (isThemeDarkMode) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }
}