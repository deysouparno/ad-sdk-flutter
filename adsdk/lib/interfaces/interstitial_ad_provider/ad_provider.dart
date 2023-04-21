abstract class InterstitialAdAdProvider {
  String get adProviderName;

  Future<void> loadInterstitialAd(
      {required String adUnit,
      required String adProvider,
      required Function(dynamic) onAdLoaded,
      required Function(String) onAdFailedToLoad});
}
