abstract class NativeAdInterface {
  String get adProviderName;

  Future<void> loadNativeAd(
      {required String adUnit,
      required String adProvider,
      required Function(dynamic) onAdLoaded,
      required Function(String) onAdFailedToLoad});
}
