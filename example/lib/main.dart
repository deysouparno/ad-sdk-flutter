import 'package:adsdk/adsdk.dart';
import 'package:adsdk_example/pages/banner_ads.dart';
import 'package:adsdk_example/pages/home.dart';
import 'package:adsdk_example/pages/native_ads.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AdSdk.initialize(
    bundleId: "com.appyhigh.plugins.adsdk_example",
    platform: "ANDROID",
    adSdkConfig: AdSdkConfiguration(isTestMode: true),
    configPath: "",
    applovinSdkKey:
        "pA3NAGLWSFkdUbKoK9gLEDnpXe6x8XU6D2TgT5vsHlZXt4FATcoLWTvA3fHBVhG6hh7HJWJa6JD1akUlTlVgwx",
  );

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Test Ads',
      initialRoute: HomePage.routeName,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      routes: {
        HomePage.routeName: (_) => const HomePage(),
        BannerAds.routeName: (_) => const BannerAds(),
        NativeAds.routeName: (_) => const NativeAds(),
      },
    );
  }
}
