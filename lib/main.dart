import 'package:app/home_page.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

// coverage:ignore-start
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
// coverage:ignore-end

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      home: const HomePage(),
    );
  }
}