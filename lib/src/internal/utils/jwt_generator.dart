import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

abstract class JwtGenerator {
  static String generateToken(
    String privateKey, {
    required String userId,
    required String api,
  }) {
    final iat = DateTime.now().millisecondsSinceEpoch;
    final exp =
        DateTime.now().add(const Duration(days: 365)).millisecondsSinceEpoch;
    final jwt = JWT(
      {
        "user_id": userId,
        "api": api,
        "iat": iat,
        "exp": exp,
      },
      audience: Audience.one("adutils"),
      header: {},
    );
    final key = RSAPrivateKey(privateKey);

    return jwt.sign(key, algorithm: JWTAlgorithm.RS256);
  }
}