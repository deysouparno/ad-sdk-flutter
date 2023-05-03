import 'package:adsdk/data/enums/ad_provider.dart';
import 'package:adsdk/interfaces/app_open_interface/app_open_ad_interface.dart';
import 'package:adsdk/utils/utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdMobAdProvider implements AppOpenAdAdInterface {
  @override
  String get adProviderName => AdProvider.ADMOB.name.toLowerCase();

  @override
  Future<void> loadAppOpenAd(
      {required String adUnit,
      required String adProvider,
      required Function(AppOpenAd p1) onAdLoaded,
      required Function(String p1) onAdFailedToLoad}) async {
    if (adProviderName != adProvider) {
      return;
    }

    AppOpenAd.load(
      adUnitId: adUnit,
      orientation: AppOpenAd.orientationPortrait,
      request: Utils.getAdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          onAdLoaded(ad);
        },
        onAdFailedToLoad: (adError) {
          onAdFailedToLoad(adError.toString());
        },
      ),
    );
  }
}
