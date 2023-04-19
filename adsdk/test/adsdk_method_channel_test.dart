import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adsdk/adsdk_method_channel.dart';

void main() {
  MethodChannelAdsdk platform = MethodChannelAdsdk();
  const MethodChannel channel = MethodChannel('adsdk');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
