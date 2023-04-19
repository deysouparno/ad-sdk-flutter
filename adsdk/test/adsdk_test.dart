import 'package:flutter_test/flutter_test.dart';
import 'package:adsdk/adsdk.dart';
import 'package:adsdk/adsdk_platform_interface.dart';
import 'package:adsdk/adsdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAdsdkPlatform
    with MockPlatformInterfaceMixin
    implements AdsdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AdsdkPlatform initialPlatform = AdsdkPlatform.instance;

  test('$MethodChannelAdsdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAdsdk>());
  });

  test('getPlatformVersion', () async {
    Adsdk adsdkPlugin = Adsdk();
    MockAdsdkPlatform fakePlatform = MockAdsdkPlatform();
    AdsdkPlatform.instance = fakePlatform;

    expect(await adsdkPlugin.getPlatformVersion(), '42');
  });
}
