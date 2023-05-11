import 'package:adsdk/adsdk.dart';
import 'package:adsdk_example/pages/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AdSdk.initialize(
    bundleId: "com.appyhigh.plugins.adsdk_example",
    platform: "ANDROID",
    configuration: AdSdkConfiguration(isTestMode: kDebugMode),
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
      title: 'AdSdk Example App',
      theme: ThemeData.light(useMaterial3: true),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (_) => const HomePage(),
      },
    );
  }
}
