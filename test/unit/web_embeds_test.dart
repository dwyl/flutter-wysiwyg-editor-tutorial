import 'package:app/web_embeds/mobile_platform_registry.dart';
import 'package:app/web_embeds/web_embeds.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../integration/emoji_widget_test.mocks.dart';

void main() {
  test('PlatformViewRegistry class initialization', () {
    final registry = PlatformViewRegistry();
    PlatformViewRegistry.registerViewFactory("viewId", () {});

    expect(registry, isNotNull);
  });

  test('PlatformViewRegistryFix class initialization', () {
    final registryFix = PlatformViewRegistryFix();

    final platformServiceMock = MockPlatformService();

    // Platform is web
    when(platformServiceMock.isWebPlatform()).thenAnswer((_) => true);

    registryFix.registerViewFactory(platformServiceMock, "imageUrl", () {});
    expect(registryFix, isNotNull);
  });
}
