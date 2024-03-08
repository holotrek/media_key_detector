import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:media_key_detector_platform_interface/media_key_detector_platform_interface.dart';

/// The Linux implementation of [MediaKeyDetectorPlatform].
class MediaKeyDetectorLinux extends MediaKeyDetectorPlatform {
  /// Constructs a [MediaKeyDetectorLinux].
  MediaKeyDetectorLinux() {
    ServicesBinding.instance.keyboard.addHandler(defaultHandler);
  }

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('media_key_detector_linux');

  /// Registers this class as the default instance of [MediaKeyDetectorPlatform]
  static void registerWith() {
    MediaKeyDetectorPlatform.instance = MediaKeyDetectorLinux();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
