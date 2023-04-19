import 'package:adsdk/data/model/response/ad_response/ad_mob.dart';

class App {
  bool? showAppAds;
  bool isActive;
  String? id;
  String? appName;
  String? packageId;
  String? platform;
  int? latestVersion;
  int? criticalVersion;
  String? appUid;
  List<AdMob>? adMob;

  App(
      {this.showAppAds = true,
      this.isActive = true,
      this.id,
      this.appName,
      this.packageId,
      this.latestVersion,
      this.criticalVersion,
      this.appUid,
      this.adMob});
}
