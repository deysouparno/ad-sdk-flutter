package com.appyhigh.plugins.adsdk

import android.content.Context
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

/** AdsdkPlugin */
class AdsdkPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var flutterEngine : FlutterEngine
  private lateinit var context : Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "adsdk")
    channel.setMethodCallHandler(this)

    flutterEngine = flutterPluginBinding.getFlutterEngine()
    context = flutterPluginBinding.getApplicationContext()
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "registerNativeAds") {
      val nativeAdFactory: GoogleMobileAdsPlugin.NativeAdFactory = CustomNativeAd(context)
      GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "nativeAdView", nativeAdFactory)

      val smallNativeAdFactory: GoogleMobileAdsPlugin.NativeAdFactory = CustomNativeAdSmall(context)
      GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "smallNativeAdView", smallNativeAdFactory)

      val smallerNativeAdFactory: GoogleMobileAdsPlugin.NativeAdFactory = CustomNativeAdSmaller(context)
      GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "smallerNativeAdView", smallerNativeAdFactory)
      result.success(true)
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "nativeAdView");
    GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "smallNativeAdView");
    GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "smallerNativeAdView");
  }
}
