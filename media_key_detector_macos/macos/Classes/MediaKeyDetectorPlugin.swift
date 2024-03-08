import FlutterMacOS
import Foundation

public class MediaKeyDetectorPlugin: NSObject, FlutterPlugin, FlutterAppLifecycleDelegate {
  private var mediaKeyHandler = MediaKeyHandler()
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "media_key_detector_macos",
      binaryMessenger: registrar.messenger)
      
    // Setup an event channel in addition to the method channel. This will react to native events and then notify Dart code.
    let eventChannel = FlutterEventChannel(
      name: "media_key_detector_macos_events",
      binaryMessenger: registrar.messenger)

    let instance = MediaKeyDetectorPlugin()

    // Add the MediaKeyHandler to the event channel stream
    eventChannel.setStreamHandler(instance.mediaKeyHandler)

    // Register the instance to listen to method calls from Dart
    registrar.addMethodCallDelegate(instance, channel: channel)

    // Register the instance to handle the FlutterAppLifecycle
    registrar.addApplicationDelegate(instance)
  }
    
  public func handleDidBecomeActive(_ notification: Notification) {
    NSEvent.addLocalMonitorForEvents(matching: .systemDefined, handler: handleKeyEvent)
  }

  func handleKeyEvent(event: NSEvent) -> NSEvent? {
    var handled = false
    if (event.type == .systemDefined && event.subtype.rawValue == 8) {
      let keyCode = ((event.data1 & 0xFFFF0000) >> 16)
      let keyFlags = (event.data1 & 0x0000FFFF)
      // Get the key state. 0xA is KeyDown, OxB is KeyUp
      let keyState = (((keyFlags & 0xFF00) >> 8)) == 0xA
      handled = mediaKeyEvent(key: Int32(keyCode), state: keyState)
    }
    return handled ? nil : event
  }
  
  func mediaKeyEvent(key: Int32, state: Bool) -> Bool {
    // Only send events on KeyDown. Without this check, these events will happen twice
    if (state) {
      switch(key) {
        case NX_KEYTYPE_PLAY:
          mediaKeyHandler.onKeyEvent(key: 0)
          return true
        case NX_KEYTYPE_PREVIOUS:
          fallthrough
        case NX_KEYTYPE_REWIND:
          mediaKeyHandler.onKeyEvent(key: 1)
          return true
        case NX_KEYTYPE_NEXT:
          fallthrough
        case NX_KEYTYPE_FAST:
          mediaKeyHandler.onKeyEvent(key: 2)
          return true
        default:
          return false
      }
    }
    return false
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformName":
      result("MacOS")    
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

class MediaKeyHandler: NSObject, FlutterStreamHandler {
  // Declare our eventSink, it will be initialized later
  private var eventSink: FlutterEventSink?

  func onKeyEvent(key: Int32) {
    self.eventSink?(key)
  }
    
  func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
    self.eventSink = eventSink
    return nil
  }
  
  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }
}
