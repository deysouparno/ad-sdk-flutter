abstract class AppOpenAdAdProvider {
  String get adProviderName;

  Future<void> loadAppOpenAd(
      {required String adUnit,
      required String adProvider,
      required Function(dynamic) onAdLoaded,
      required Function(String) onAdFailedToLoad});
}
