// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/embeds/toolbar/image_button.dart';
import 'package:flutter_quill/flutter_quill_test.dart';

import 'package:app/main.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';

// importing mocks
import 'widget_test.mocks.dart';

class FakeImagePicker extends ImagePickerPlatform {
  @override
  Future<XFile?> getImageFromSource({
    required ImageSource source,
    ImagePickerOptions options = const ImagePickerOptions(),
  }) async {
    final data = await rootBundle.load('assets/sample.jpeg');
    final bytes = data.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final file = await File(
      '${tempDir.path}/doc.png',
    ).writeAsBytes(bytes);

    return XFile(file.path);
  }

  @override
  Future<List<XFile>> getMultiImageWithOptions({
    MultiImagePickerOptions options = const MultiImagePickerOptions(),
  }) async {
    final data = await rootBundle.load('assets/sample.jpeg');
    final bytes = data.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final file = await File(
      '${tempDir.path}/sample.jpeg',
    ).writeAsBytes(bytes);
    return <XFile>[
      XFile(
        file.path,
      ),
    ];
  }
}

@GenerateMocks([PlatformService, ImageFilePicker])
void main() {
  // See https://stackoverflow.com/questions/76586920/mocking-imagepicker-in-flutter-integration-tests-not-working for context.
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    ImagePickerPlatform.instance = FakeImagePicker();
  });

  testWidgets('Normal setup', (WidgetTester tester) async {
    final platformServiceMock = MockPlatformService();
    final filePickerMock = MockImageFilePicker();

    // Platform is mobile
    when(platformServiceMock.isWebPlatform()).thenAnswer((_) => false);

    // Set mock behaviour for `filePickerMock`
    final listMockFiles = [PlatformFile(name: 'image.png', size: 200, path: "some_path")];
    when(filePickerMock.pickImage()).thenAnswer((_) async => Future<FilePickerResult?>.value(FilePickerResult(listMockFiles)));

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      App(
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

  testWidgets('Image picker select image', (WidgetTester tester) async {
    final platformServiceMock = MockPlatformService();
    final filePickerMock = MockImageFilePicker();

    // Platform is mobile
    when(platformServiceMock.isWebPlatform()).thenAnswer((_) => false);

    // Set mock behaviour for `filePickerMock`
    final listMockFiles = [PlatformFile(name: 'image.png', size: 200, path: "some_path")];
    when(filePickerMock.pickImage()).thenAnswer((_) async => Future<FilePickerResult?>.value(FilePickerResult(listMockFiles)));

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      App(
        platformService: platformServiceMock,
        imageFilePicker: filePickerMock,
      ),
    );
    await tester.pumpAndSettle();

    // Should show editor and toolbar
    final editor = find.byType(QuillEditor);

    // Press image button
    // Because of the override, should embed image.x
    final imageButton = find.byType(ImageButton);
    await tester.tap(imageButton);
    await tester.pumpAndSettle();

    // Image correctly added, editor should be visible again.
    expect(editor.hitTestable(), findsOneWidget);
  });

  testWidgets('Normal setup (web version)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 600);
    tester.view.devicePixelRatio = 1.0;

    final platformServiceMock = MockPlatformService();
    final filePickerMock = MockImageFilePicker();

    // Platform is mobile
    when(platformServiceMock.isWebPlatform()).thenAnswer((_) => true);

    // Set mock behaviour for `filePickerMock`
    final listMockFiles = [PlatformFile(name: 'image.png', size: 200, path: "some_path")];
    when(filePickerMock.pickImage()).thenAnswer((_) async => Future<FilePickerResult?>.value(FilePickerResult(listMockFiles)));

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      App(
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
}
