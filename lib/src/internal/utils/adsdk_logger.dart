import 'package:adsdk/src/internal/enums/ad_provider.dart';
import 'package:logger/logger.dart';

abstract class AdSdkLogger {
  static final _logger = Logger();

  static String info(String message) {
    _logger.i(message);
    return message;
  }

  static String error(String message) {
    _logger.e(message);
    return message;
  }

  static String debug(String message) {
    _logger.d(message);
    return message;
  }

  static void adLoadedLog({
    required String adName,
    required AdProvider adProvider,
  }) {
    info("Ad Loaded - Ad Name: $adName, Ad Provider: ${adProvider.key}");
  }
}
