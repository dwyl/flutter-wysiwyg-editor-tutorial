import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/main.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';

// importing mocks
import '../test/widget_test.mocks.dart';

/// Run `flutter test integration_test` with a device connected to see it running on the real device.

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
  /// Check for context: https://stackoverflow.com/questions/60671728/unable-to-load-assets-in-flutter-tests
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    ImagePickerPlatform.instance = FakeImagePicker();
  });

  testWidgets('Image picker select image', (WidgetTester tester) async {
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
}
