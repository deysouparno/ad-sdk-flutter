enum AdUnitType {
  appOpen("appopen"),
  interstitial("interstitial"),
  rewarded("rewarded"),
  banner("banner"),
  native("native");

  final String key;

  const AdUnitType(this.key);
}

extension AdUnitTypeStringExtension on String {
  AdUnitType get adUnitType {
    if (toLowerCase() == AdUnitType.appOpen.key.toLowerCase()) {
      return AdUnitType.appOpen;
    } else if (toLowerCase() == AdUnitType.rewarded.key.toLowerCase()) {
      return AdUnitType.rewarded;
    } else if (toLowerCase() == AdUnitType.banner.key.toLowerCase()) {
      return AdUnitType.banner;
    } else if (toLowerCase() == AdUnitType.native.key.toLowerCase()) {
      return AdUnitType.native;
    }
    return AdUnitType.interstitial;
  }
}
