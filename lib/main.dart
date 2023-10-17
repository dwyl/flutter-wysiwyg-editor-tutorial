import 'package:app/home_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:http/http.dart' as http;

// coverage:ignore-start
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    App(
      client: http.Client(),
      platformService: PlatformService(),
      imageFilePicker: ImageFilePicker(),
    ),
  );
}
// coverage:ignore-end

/// Entry gateway to the application.
/// Defining the MaterialApp attributes and Responsive Framework breakpoints.
class App extends StatelessWidget {
  const App({required this.platformService, required this.imageFilePicker, required this.client, super.key});

  final PlatformService platformService;
  final ImageFilePicker imageFilePicker;
  final http.Client client;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Editor Demo',
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 425, name: MOBILE),
          const Breakpoint(start: 426, end: 768, name: TABLET),
          const Breakpoint(start: 769, end: 1440, name: DESKTOP),
          const Breakpoint(start: 1441, end: double.infinity, name: '4K'),
        ],
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: HomePage(
        client: client,
        platformService: platformService,
        imageFilePicker: imageFilePicker,
      ),
    );
  }
}

// coverage:ignore-start
/// Platform service class that tells if the platform is web-based or not
class PlatformService {
  bool isWebPlatform() {
    return kIsWeb;
  }
}

class ImageFilePicker {
  Future<FilePickerResult?> pickImage() => FilePicker.platform.pickFiles(type: FileType.image);
}
// coverage:ignore-end
