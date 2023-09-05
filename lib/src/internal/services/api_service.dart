import 'dart:convert';
import 'package:adsdk/src/internal/constants/constants.dart';
import 'package:adsdk/src/internal/constants/private_keys.dart';
import 'package:adsdk/src/internal/services/local_storage_service.dart';
import 'package:adsdk/src/internal/utils/adsdk_logger.dart';
import 'package:adsdk/src/internal/utils/jwt_generator.dart';
import 'package:http/http.dart' as http;

abstract class ApiService {
  static Future<void> fetchAds({
    required String packageId,
    required String platform,
  }) async {
    try {
      final response = await http.post(
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
      var jsonResponse = jsonDecode(response.body);
      AdSdkLogger.info(jsonResponse.toString());
      if (response.statusCode == 200) {
        LocalStorage.setApiResponse(jsonEncode(jsonResponse));
      } else {
        throw Exception('Bad Response');
      }
    } catch (e) {
      AdSdkLogger.error(e.toString());
      throw Exception(e.toString());
    }
  }
}
