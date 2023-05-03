abstract class RewardedAdInterface {

  String get adProviderName;

  Future<void> loadRewardedAd(
      {required String adUnit,
      required String adProvider,
      required Function(dynamic) onAdLoaded,
      required Function(String) onAdFailedToLoad});
}
