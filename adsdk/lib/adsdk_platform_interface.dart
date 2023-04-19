import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'adsdk_method_channel.dart';

abstract class AdsdkPlatform extends PlatformInterface {
  /// Constructs a AdsdkPlatform.
  AdsdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static AdsdkPlatform _instance = MethodChannelAdsdk();

  /// The default instance of [AdsdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelAdsdk].
  static AdsdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AdsdkPlatform] when
  /// they register themselves.
  static set instance(AdsdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
