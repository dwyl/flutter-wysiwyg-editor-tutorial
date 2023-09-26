import 'package:app/emoji_picker_widget.dart';
import 'package:app/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/main.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';


// importing mocks
import 'widget_test.mocks.dart';

@GenerateMocks([PlatformService])
void main() {
  /// Check for context: https://stackoverflow.com/questions/60671728/unable-to-load-assets-in-flutter-tests
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('Click on emoji button should show the emoji picker', (WidgetTester tester) async {
    // Set size because it's needed to correctly tap on emoji picker
    await tester.binding.setSurfaceSize(const Size(380, 800));

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
}
