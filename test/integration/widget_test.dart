import 'dart:convert';

import 'package:app/image_button_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/flutter_quill_test.dart';
import 'package:http/http.dart' as http;

import 'package:app/main.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter/services.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

// importing mocks
import 'widget_test.mocks.dart';

/// Class that is used to override the `getApplicationDocumentsDirectory()` function.
class FakePathProviderPlatform extends PathProviderPlatform implements Fake {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    // Make sure is the same folder used in the tests.
    return 'test';
  }
}

@GenerateMocks([PlatformService, ImageFilePicker, http.Client])
void main() {
  // See https://stackoverflow.com/questions/76586920/mocking-imagepicker-in-flutter-integration-tests-not-working for context.
  setUp(() {
    /// Check for context: https://stackoverflow.com/questions/60671728/unable-to-load-assets-in-flutter-tests
    PathProviderPlatform.instance = FakePathProviderPlatform();
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Setup: ', () {
    testWidgets('Normal', (WidgetTester tester) async {
      final clientMock = MockClient();
      final platformServiceMock = MockPlatformService();
      final filePickerMock = MockImageFilePicker();

      // Platform is mobile
      when(platformServiceMock.isWebPlatform()).thenAnswer((_) => false);

      // Set mock behaviour for `filePickerMock`
      final listMockFiles = [PlatformFile(name: 'sample.jpeg', size: 200, path: 'assets/sample.jpeg')];
      when(filePickerMock.pickImage()).thenAnswer((_) async => Future<FilePickerResult?>.value(FilePickerResult(listMockFiles)));

      // Build our app and trigger a frame.
      await tester.pumpWidget(
        App(
          client: clientMock,
          platformService: platformServiceMock,
          imageFilePicker: filePickerMock,
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

    testWidgets('Normal (web version)', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 600);
      tester.view.devicePixelRatio = 1.0;

      final clientMock = MockClient();
      final platformServiceMock = MockPlatformService();
      final filePickerMock = MockImageFilePicker();

      // Platform is mobile
      when(platformServiceMock.isWebPlatform()).thenAnswer((_) => true);

      // Set mock behaviour for `filePickerMock`
      final listMockFiles = [PlatformFile(name: 'sample.jpeg', size: 200, path: 'assets/sample.jpeg')];
      when(filePickerMock.pickImage()).thenAnswer((_) async => Future<FilePickerResult?>.value(FilePickerResult(listMockFiles)));

      // Build our app and trigger a frame.
      await tester.pumpWidget(
        App(
          client: clientMock,
          platformService: platformServiceMock,
          imageFilePicker: filePickerMock,
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
  });

  group('Image picker: ', () {
    testWidgets('Image picker select image', (WidgetTester tester) async {
      final clientMock = MockClient();

      final platformServiceMock = MockPlatformService();
      final filePickerMock = MockImageFilePicker();

      // Platform is mobile
      when(platformServiceMock.isWebPlatform()).thenAnswer((_) => false);

      // Set mock behaviour for `filePickerMock`
      final listMockFiles = [PlatformFile(name: 'sample.jpeg', size: 200, path: 'assets/sample.jpeg')];
      when(filePickerMock.pickImage()).thenAnswer((_) async => Future<FilePickerResult?>.value(FilePickerResult(listMockFiles)));

      // Build our app and trigger a frame.
      await tester.pumpWidget(
        App(
          client: clientMock,
          platformService: platformServiceMock,
          imageFilePicker: filePickerMock,
        ),
      );
      await tester.pumpAndSettle();

      // Should show editor and toolbar
      final editor = find.byType(QuillEditor);

      // Press image button
      // Because of the override, should embed image.x
      final imageButton = find.byType(ImageToolbarButton);
      await tester.tap(imageButton);
      await tester.pumpAndSettle();

      // Image correctly added, editor should be visible again.
      expect(editor.hitTestable(), findsOneWidget);
    });

    testWidgets('Image picker select image - web version', (WidgetTester tester) async {
      mockNetworkImagesFor(() async {
        final clientMock = MockClient();
        final platformServiceMock = MockPlatformService();
        final filePickerMock = MockImageFilePicker();

        // Platform is mobile
        when(platformServiceMock.isWebPlatform()).thenAnswer((_) => true);

        // Set mock behaviour for `filePickerMock` with jpeg magic number byte array https://gist.github.com/leommoore/f9e57ba2aa4bf197ebc5
        final listMockFiles = [
          PlatformFile(name: 'sample.jpeg', size: 200, path: 'assets/sample.jpeg', bytes: Uint8List.fromList([0xff, 0xd8, 0xff, 0xe0])),
        ];
        when(filePickerMock.pickImage()).thenAnswer((_) async => Future<FilePickerResult?>.value(FilePickerResult(listMockFiles)));

        // Set mock behaviour for `requestMock`
        const body = '{"url":"return_url"}';
        final bodyBytes = utf8.encode(body);
        when(clientMock.send(any)).thenAnswer((_) async => http.StreamedResponse(Stream<List<int>>.fromIterable([bodyBytes]), 200));

        // Build our app and trigger a frame.
        await tester.pumpWidget(
          App(
            client: clientMock,
            platformService: platformServiceMock,
            imageFilePicker: filePickerMock,
          ),
        );
        await tester.pumpAndSettle();

        // Should show editor and toolbar
        final editor = find.byType(QuillEditor);

        // Press image button
        // Because of the override, should embed image.
        final imageButton = find.byType(ImageToolbarButton);
        await tester.tap(imageButton);
        await tester.pumpAndSettle();

        // Image correctly added, editor should be visible again.
        expect(editor.hitTestable(), findsOneWidget);
      });
    });

    testWidgets('Image picker select image - web version (smaller than mobile)', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(350, 600);
      tester.view.devicePixelRatio = 1.0;

      mockNetworkImagesFor(() async {
        final clientMock = MockClient();
        final platformServiceMock = MockPlatformService();
        final filePickerMock = MockImageFilePicker();

        // Platform is web
        when(platformServiceMock.isWebPlatform()).thenAnswer((_) => true);

        // Set mock behaviour for `filePickerMock` with jpeg magic number byte array https://gist.github.com/leommoore/f9e57ba2aa4bf197ebc5
        final listMockFiles = [
          PlatformFile(name: 'sample.jpeg', size: 200, path: 'assets/sample.jpeg', bytes: Uint8List.fromList([0xff, 0xd8, 0xff, 0xe0])),
        ];
        when(filePickerMock.pickImage()).thenAnswer((_) async => Future<FilePickerResult?>.value(FilePickerResult(listMockFiles)));

        // Set mock behaviour for `requestMock`
        const body = '{"url":"return_url"}';
        final bodyBytes = utf8.encode(body);
        when(clientMock.send(any)).thenAnswer((_) async => http.StreamedResponse(Stream<List<int>>.fromIterable([bodyBytes]), 200));

        // Build our app and trigger a frame.
        await tester.pumpWidget(
          App(
            client: clientMock,
            platformService: platformServiceMock,
            imageFilePicker: filePickerMock,
          ),
        );
        await tester.pumpAndSettle();

        // Should show editor and toolbar
        final editor = find.byType(QuillEditor);

        // Press image button
        // Because of the override, should embed image.
        final imageButton = find.byType(ImageToolbarButton);
        await tester.tap(imageButton);
        await tester.pumpAndSettle();

        // Image correctly added, editor should be visible again.
        expect(editor.hitTestable(), findsOneWidget);
      });

      tester.view.resetPhysicalSize();
    });
  });
}
