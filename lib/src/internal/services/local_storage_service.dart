import 'package:adsdk/src/internal/models/api_response.dart';
import 'package:adsdk/src/internal/utils/adsdk_logger.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorage {
  static SharedPreferences? _prefs;

  static SharedPreferences get prefs => _prefs!;

  static Future<bool> init() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs != null;
  }

  static Future<AdSdkApiResponse?> getApiResponse(String jsonPath) async {
    try {
      String? json = prefs.getString("cachedApiResponse");
      json ??= await rootBundle.loadString(jsonPath);
      AdSdkLogger.info("Ad config loaded from cache.");
      return AdSdkApiResponse.fromJson(json);
    } catch (e) {
      AdSdkLogger.error(e.toString());
    }
    return null;
  }

  static setApiResponse(String json) =>
      prefs.setString("cachedApiResponse", json);
}
