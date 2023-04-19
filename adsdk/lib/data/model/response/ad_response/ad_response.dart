import 'package:adsdk/data/model/response/ad_response/app.dart';

class AdResponse {
  String? status;
  String? message;
  App? app;

  AdResponse({this.status, this.message, this.app});
}
