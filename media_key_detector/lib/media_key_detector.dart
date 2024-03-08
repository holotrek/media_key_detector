/// Plugin which allows you to detect the media buttons on the keyboard, which
/// does not fire for regular key events on MacOS
library media_key_detector;

import 'package:media_key_detector_platform_interface/media_key_detector_platform_interface.dart';

export 'package:media_key_detector_platform_interface/media_key_detector_platform_interface.dart'
    show MediaKey;
export 'src/media_key_detector.dart' show MediaKeyDetector, mediaKeyDetector;

MediaKeyDetectorPlatform get _platform => MediaKeyDetectorPlatform.instance;

/// Returns the name of the current platform.
Future<String> getPlatformName() async {
  final platformName = await _platform.getPlatformName();
  if (platformName == null) throw Exception('Unable to get platform name.');
  return platformName;
}
