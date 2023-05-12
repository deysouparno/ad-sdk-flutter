import 'package:google_mobile_ads/google_mobile_ads.dart';

enum AdSdkAdSize {
  banner("banner"),
  largeBanner("large_banner"),
  mediumBanner("medium_banner");

  final String key;

  const AdSdkAdSize(this.key);
}

extension AdSdkAdSizeStringExtension on String {
  AdSdkAdSize get adSdkAdSize {
    if (toLowerCase() == AdSdkAdSize.largeBanner.key.toLowerCase()) {
      return AdSdkAdSize.largeBanner;
    } else if (toLowerCase() == AdSdkAdSize.mediumBanner.key.toLowerCase()) {
      return AdSdkAdSize.mediumBanner;
    }
    return AdSdkAdSize.banner;
  }
}

extension AdSdkAdSizeExtension on AdSdkAdSize {
  AdSize get adSize {
    switch (this) {
      case AdSdkAdSize.largeBanner:
        return AdSize.largeBanner;
      case AdSdkAdSize.mediumBanner:
        return AdSize.mediumRectangle;
      default:
        return AdSize.banner;
    }
  }
}
