import 'package:media_key_detector_platform_interface/media_key_detector_platform_interface.dart';

/// Contains methods to add/remove listeners for the media key
class MediaKeyDetector {
  /// Contains methods to add/remove listeners for the media key
  factory MediaKeyDetector() {
    return _singleton;
  }

  MediaKeyDetector._internal();

  static final MediaKeyDetector _singleton = MediaKeyDetector._internal();

  final List<void Function(MediaKey mediaKey)> _listeners = [];

  /// Listen for the media key event
  void addListener(void Function(MediaKey mediaKey) listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  /// Remove the previously registered listener
  void removeListener(void Function(MediaKey mediaKey) listener) {
    _listeners.remove(listener);
  }

  /// Trigger all listeners to indicate that the specified media key was pressed
  void triggerListeners(MediaKey mediaKey) {
    for (final l in _listeners) {
      l(mediaKey);
    }
  }
}

/// Global singleton instance of the [MediaKeyDetector]
final mediaKeyDetector = MediaKeyDetector._singleton;
