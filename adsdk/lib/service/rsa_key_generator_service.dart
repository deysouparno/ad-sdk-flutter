import 'package:adsdk/utils/constants.dart';
import 'package:corsac_jwt/corsac_jwt.dart';

class RSAKeyGeneratorService {
  Future<String> getJWTToken({required Map<String, String> data}) async {
    String userId = data["user_id"]!;
    String api = data["api"]!;
    String prevJwt = data["jwt_token"]!;
    String date = DateTime.now().millisecond.toString();
    JWTRsaSha256Signer jwtRsaSha256Signer =
        _getPrivateKey(Constants.privateKey);
    final jwt = JWTBuilder()
      ..setClaim('user_id', userId)
      ..setClaim('api', api)
      ..setClaim('iat', date)
      ..audience = 'adUtils';

    final token = jwt.getSignedToken(jwtRsaSha256Signer);

    return token.toString();
  }

  JWTRsaSha256Signer _getPrivateKey(String privateKey) {
    JWTRsaSha256Signer jwtRsaSha256Signer;
    jwtRsaSha256Signer = JWTRsaSha256Signer(privateKey: privateKey);
    return jwtRsaSha256Signer;
  }
}
