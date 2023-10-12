import 'dart:io';

import 'package:adsdk/src/adsdk_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HardstopDialog extends StatelessWidget {
  const HardstopDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: const Icon(Icons.close_rounded),
              ),
            ),
            const SizedBox(height: 8),
            Image.asset(
              "assets/installation.png",
              package: "adsdk",
            ),
            const SizedBox(height: 16),
            Text(
              AdSdkState.apiResp?.app.redirectLinkDescription ?? "",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Add a button
            ElevatedButton(
              onPressed: () {
                try {
                  launchUrlString(
                    AdSdkState.apiResp?.app.redirectLink ?? "",
                    mode: LaunchMode.externalApplication,
                  );
                } catch (_) {}
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF725E),
                textStyle: const TextStyle(
                  color: Colors.white,
                ),
                fixedSize: Size.fromWidth(
                  MediaQuery.sizeOf(context).width * 0.7,
                ),
              ),
              child: const Text("Update Now!"),
            ),
          ],
        ),
      ),
    );
  }
}
