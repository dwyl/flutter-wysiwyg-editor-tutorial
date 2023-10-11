import 'package:app/emoji_picker_widget.dart';
import 'package:app/home_page.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/main.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:responsive_framework/responsive_framework.dart';

// importing mocks
import './widget_test.mocks.dart';

@GenerateMocks([PlatformService, ImageFilePicker])
void main() {
  /// Check for context: https://stackoverflow.com/questions/60671728/unable-to-load-assets-in-flutter-tests
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('Click on emoji button should show the emoji picker', (WidgetTester tester) async {
    // Set size because it's needed to correctly tap on emoji picker
    await tester.binding.setSurfaceSize(const Size(380, 800));

    final platformServiceMock = MockPlatformService();
    final filePickerMock = MockImageFilePicker();

    // Platform is mobile
    when(platformServiceMock.isWebPlatform()).thenAnswer((_) => false);

    // Set mock behaviour for `filePickerMock`
    final listMockFiles = [PlatformFile(name: 'sample.jpeg', size: 200, path: "assets/sample.jpeg")];
    when(filePickerMock.pickImage()).thenAnswer((_) async => Future<FilePickerResult?>.value(FilePickerResult(listMockFiles)));

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      App(
        platformService: platformServiceMock,
        imageFilePicker: filePickerMock,
      ),
    );
    await tester.pumpAndSettle();

    // Expect to find the normal page setup and emoji picker not being shown
    expect(find.text('Flutter Quill'), findsOneWidget);
    expect(find.byKey(emojiPickerWidgetKey).hitTestable(), findsNothing);

    // Click on emoji button should show the emoji picker
    var emojiIcon = find.byIcon(Icons.emoji_emotions);

    await tester.tap(emojiIcon);
    await tester.pumpAndSettle();

    emojiIcon = find.byIcon(Icons.emoji_emotions);

    // Expect the emoji picker being shown
    expect(find.byKey(emojiButtonKey).hitTestable(), findsOneWidget);

    // Tap on smile category
    await tester.tapAt(const Offset(61, 580));
    await tester.pumpAndSettle();

    // Tap on smile icon
    await tester.tapAt(const Offset(14, 632));
    await tester.pumpAndSettle();

    // Tap on emoji icon to close the emoji pickers
    emojiIcon = find.byIcon(Icons.emoji_emotions);

    await tester.tap(emojiIcon);
    await tester.pumpAndSettle();

    expect(find.byKey(emojiPickerWidgetKey).hitTestable(), findsNothing);
  });

  testWidgets('Testing focus change when clicking on emoji, then editor, then emoji', (WidgetTester tester) async {
    // Set size because it's needed to correctly tap on emoji picker
    await tester.binding.setSurfaceSize(const Size(380, 800));

    final platformServiceMock = MockPlatformService();
    final filePickerMock = MockImageFilePicker();

    // Platform is mobile
    when(platformServiceMock.isWebPlatform()).thenAnswer((_) => false);

    // Set mock behaviour for `filePickerMock`
    final listMockFiles = [PlatformFile(name: 'sample.jpeg', size: 200, path: "assets/sample.jpeg")];
    when(filePickerMock.pickImage()).thenAnswer((_) async => Future<FilePickerResult?>.value(FilePickerResult(listMockFiles)));

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      App(
        platformService: platformServiceMock,
        imageFilePicker: filePickerMock,
      ),
    );
    await tester.pumpAndSettle();

    // Expect to find the normal page setup and emoji picker not being shown
    expect(find.text('Flutter Quill'), findsOneWidget);
    expect(find.byKey(emojiPickerWidgetKey).hitTestable(), findsNothing);

    // Click on emoji button should show the emoji picker
    var emojiIcon = find.byIcon(Icons.emoji_emotions);

    await tester.tap(emojiIcon);
    await tester.pumpAndSettle();

    emojiIcon = find.byIcon(Icons.emoji_emotions);

    // Expect the emoji picker being shown
    expect(find.byKey(emojiButtonKey).hitTestable(), findsOneWidget);

    // Tap on editor
    final editor = find.byType(QuillEditor);
    await tester.tap(editor);
    await tester.pumpAndSettle();

    // Tap on emoji icon to close the emoji pickers
    await tester.tap(emojiIcon);
    await tester.pumpAndSettle();
  });

  testWidgets('should be shown and tap on emoji.', (WidgetTester tester) async {
    // Initialize widget that should show picker
    final app = MaterialApp(
      home: const OffstageEmojiPicker(
        offstageEmojiPicker: false,
      ),
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 425, name: MOBILE),
          const Breakpoint(start: 426, end: 768, name: TABLET),
          const Breakpoint(start: 769, end: 1024, name: DESKTOP),
          const Breakpoint(start: 1025, end: 1440, name: 'LARGE_DESKTOP'),
          const Breakpoint(start: 1441, end: double.infinity, name: '4K'),
        ],
      ),
    );
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.byType(EmojiPicker), findsOneWidget);

    // Tap on emoji
    final emoji = find.text('😍');
    await tester.tap(emoji);
    await tester.pumpAndSettle();

    expect(find.byType(EmojiPicker), findsOneWidget);
  });
}
