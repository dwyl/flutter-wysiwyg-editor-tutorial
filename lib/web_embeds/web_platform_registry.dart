import 'dart:ui_web' as web_ui;

class PlatformViewRegistry {
  static void registerViewFactory(String viewId, dynamic cb) {
    web_ui.platformViewRegistry.registerViewFactory(viewId, cb);
  }
}