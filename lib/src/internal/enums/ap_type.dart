enum AdUnitType {
  appOpen("appopen"),
  interstitial("interstitial"),
  rewarded("rewarded");

  final String key;

  const AdUnitType(this.key);
}

extension StringExtension on String {
  AdUnitType get adUnitType {
    if (toLowerCase() == AdUnitType.appOpen.key.toLowerCase()) {
      return AdUnitType.appOpen;
    } else if (toLowerCase() == AdUnitType.rewarded.key.toLowerCase()) {
      return AdUnitType.rewarded;
    }
    return AdUnitType.interstitial;
  }
}
