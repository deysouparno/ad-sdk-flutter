import 'package:adsdk/src/internal/constants/constants.dart';
import 'package:adsdk/src/internal/constants/private_keys.dart';
import 'package:adsdk/src/internal/models/api_response.dart';
import 'package:adsdk/src/internal/utils/adsdk_logger.dart';
import 'package:adsdk/src/internal/utils/jwt_generator.dart';
import 'package:http/http.dart' as http;

abstract class ApiService {
  static Future<AdSdkApiResponse?> fetchAds({
    required String packageId,
    required String platform,
  }) async {
    try {
      final resp = await http.post(
        Uri.parse("${AdSdkConstants.baseUrl}${AdSdkConstants.endpoint}"),
        body: {
          "packageId": packageId,
          "platform": platform,
        },
        headers: {
          "Authorization":
              "Bearer ${JwtGenerator.generateToken(PrivateKeys.jwtPrivateKey, userId: "test_user", api: "users")}"
        },
      );
      AdSdkLogger.info(resp.body);
      return AdSdkApiResponse.fromJson(resp.body);
    } catch (e) {
      AdSdkLogger.error(e.toString());
    }
    return null;
  }
}
