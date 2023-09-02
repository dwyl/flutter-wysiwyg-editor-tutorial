// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:app/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/embeds/toolbar/image_button.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quill/flutter_quill_test.dart';

import 'package:app/main.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:integration_test/integration_test.dart';


// importing mocks
import 'widget_test.mocks.dart';

@GenerateMocks([PlatformService])
void main() {
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
    await tester.tap(find.byType(QuillEditor));
    await tester.quillEnterText(find.byType(QuillEditor), 'hi\n');
    await tester.pumpAndSettle();
  });

  testWidgets('Select image', (WidgetTester tester) async {
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
    await tester.tap(find.byType(QuillEditor));
    await tester.quillEnterText(find.byType(QuillEditor), 'hi\n');
    await tester.pumpAndSettle();

    final imageButton = find.byType(ImageButton);
    await tester.tap(imageButton);
    await tester.pumpAndSettle();

    //TODO add image picker
    //https://github.com/dwyl/flutter-image-upload-demo/blob/main/test/widget_test.dart
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
    await tester.tap(find.byType(QuillEditor));
    await tester.quillEnterText(find.byType(QuillEditor), 'hi\n');
    await tester.pumpAndSettle();
  });
}
