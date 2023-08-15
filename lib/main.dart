import 'package:app/home_page.dart';
import 'package:flutter/material.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}