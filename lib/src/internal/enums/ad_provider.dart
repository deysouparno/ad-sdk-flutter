enum AdProvider {
  admob("Admob"),
  admanager("Admanager"),
  applovin("Applovin");

  final String key;

  const AdProvider(this.key);
}

extension StringExtensions on String {
  AdProvider get adProvider {
    if (toLowerCase() == AdProvider.admanager.key.toLowerCase()) {
      return AdProvider.admanager;
    } else if (toLowerCase() == AdProvider.applovin.key.toLowerCase()) {
      return AdProvider.applovin;
    }
    return AdProvider.admob;
  }
}
