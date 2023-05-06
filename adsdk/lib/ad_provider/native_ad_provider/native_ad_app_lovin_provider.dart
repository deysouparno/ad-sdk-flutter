import 'package:adsdk/data/enums/ad_provider.dart';
import 'package:adsdk/interfaces/native_ad_interface/native_ad_interface.dart';
import 'package:applovin_max/applovin_max.dart';

class NativeAdAppLovin extends NativeAdInterface {
  @override
  String get adProviderName => AdProvider.APPLOVIN.name.toLowerCase();

  @override
  Future<void> loadNativeAd(
      {required String adUnit,
      required String adProvider,
      required Function(dynamic p1) onAdLoaded,
      required Function(String p1) onAdFailedToLoad}) async {
    if (adProviderName != adProvider) {
      return;
    }
    // TODO find alternate as
    // Applovin does not provide native ad
    Map? configuration = await AppLovinMAX.initialize(adUnit);
    if (configuration != null) {}
  }
}
