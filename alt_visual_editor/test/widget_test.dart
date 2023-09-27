// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cross_file/cross_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visual_editor/visual-editor.dart';

import 'package:app/main.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter/services.dart';

// importing mocks
import 'widget_test.mocks.dart';

/// This attempts to override the `image_picker` plugin inside `flutter-quill`,
/// but is currently failing.
///
/// Please check the links below for more context.
/// https://stackoverflow.com/questions/76586920/mocking-imagepicker-in-flutter-integration-tests-not-working
/// and https://stackoverflow.com/questions/52028969/testing-flutter-code-that-uses-a-plugin-and-platform-channel
/// and https://docs.flutter.dev/testing/plugins-in-tests#mock-the-platform-channel
///
/// This is currently commented because it crashes with a `PlatformException` stating
/// the `XFile` instance is an invalid argument (it does the same with `File`).
///
/// `XFile` would make sense since the line that calls `image-picker`
/// is in https://github.com/singerdmx/flutter-quill/blob/36d72c1987f0cb8d6c689c12542600364c07e20f/flutter_quill_extensions/lib/embeds/toolbar/image_video_utils.dart#L147.
void mockImagePicker(WidgetTester tester) {
  const channel = MethodChannel('plugins.flutter.io/image_picker');

  Future<XFile?> handler(MethodCall methodCall) async {
    if (methodCall.method == 'pickImage') {
      final file = XFile('test/sample.jpeg');
      return file;
    } else {
      return null;
    }
  }

  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (message) {
    return handler(message);
  });
}

@GenerateMocks([PlatformService])
void main() {
  /// Check for context: https://stackoverflow.com/questions/60671728/unable-to-load-assets-in-flutter-tests
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('Normal setup', (WidgetTester tester) async {
    final platformServiceMock = MockPlatformService();
    // Platform is mobile
    when(platformServiceMock.isWebPlatform()).thenAnswer((_) => false);

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      App(
        platformService: platformServiceMock,
      ),
    );
    await tester.pumpAndSettle();

    // Expect to find the normal page setup
    expect(find.text('Flutter Quill'), findsOneWidget);

    // Enter 'hi' into Quill Editor.
    await tester.tap(find.byType(VisualEditor));
    await tester.enterText(find.byType(VisualEditor), 'hi\n');
    await tester.pumpAndSettle();
  });

  testWidgets('Select image', (WidgetTester tester) async {
    final platformServiceMock = MockPlatformService();

    // Platform is mobile
    when(platformServiceMock.isWebPlatform()).thenAnswer((_) => false);

    // Mock image
    // mockImagePicker(tester);

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      App(
        platformService: platformServiceMock,
      ),
    );
    await tester.pumpAndSettle();

    // Expect to find the normal page setup
    expect(find.text('Flutter Quill'), findsOneWidget);

    // Enter 'hi' into Quill Editor.
    await tester.tap(find.byType(VisualEditor));
    await tester.enterText(find.byType(VisualEditor), 'hi\n');
    await tester.pumpAndSettle();

    final imageButton = find.byType(ImageButton);
    await tester.tap(imageButton);
    await tester.pumpAndSettle();
  });

  testWidgets('Normal setup (web version)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 600);
    tester.view.devicePixelRatio = 1.0;

    final platformServiceMock = MockPlatformService();
    // Platform is desktop
    when(platformServiceMock.isWebPlatform()).thenAnswer((_) => true);

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      App(
        platformService: platformServiceMock,
      ),
    );
    await tester.pumpAndSettle();

    // Expect to find the normal page setup
    expect(find.text('Flutter Quill'), findsOneWidget);

    // Enter 'hi' into Quill Editor.
    await tester.tap(find.byType(VisualEditor));
    await tester.enterText(find.byType(VisualEditor), 'hi\n');
    await tester.pumpAndSettle();
  });
}
