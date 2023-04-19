import 'dart:developer';
import 'package:adsdk/service/rsa_key_generator_service.dart';
import 'package:adsdk/utils/constants.dart';
import 'package:dio/dio.dart';

String get baseUrl => URLs.baseURL;

class NetworkRequester {
  late Dio _dio;

  static NetworkRequester? _instance;

  static NetworkRequester get instance => _instance ??= NetworkRequester();

  Future<void> prepareRequest() async {
    String authToken = await _fetchToken();

    BaseOptions dioOptions = BaseOptions(
      connectTimeout: const Duration(milliseconds: Constants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: Constants.receiveTimeout),
      baseUrl: baseUrl,
      responseType: ResponseType.json,
      headers: {
        'Accept': Headers.jsonContentType,
        'Authorization': authToken,
        'Content-Type': 'application/json'
      },
    );

    _dio = Dio(dioOptions);

    _dio.interceptors.clear();

    _dio.interceptors.add(LogInterceptor(
      error: true,
      request: true,
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
      logPrint: _printLog,
    ));
  }

  _printLog(Object object) => log(object.toString());

  Future<dynamic> get({
    required String path,
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: query);
      if (response.data != null) {
        return response.data;
      }
    } on Exception catch (exception) {
      log(exception.toString());
    }
  }

  Future<dynamic> post({
    required String path,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.post(
        path,
        queryParameters: query,
        data: data,
      );
      if (response.data != null) {
        return response.data;
      }
    } on Exception catch (error) {
      log(error.toString());
    }
  }

  Future<String> _fetchToken() async {
    String token = '';
    try {
      Map<String, String> data = {};
      data["user_id"] = "test_user";
      data["aud"] = "dapps";
      data["api"] = "users";
      token = await RSAKeyGeneratorService().getJWTToken(data: data);
    } catch (e) {
      log(e.toString());
    }
    return "Bearer $token";
  }
}
