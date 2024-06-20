import 'package:flutter/material.dart';
import 'package:qr_code_scanner/QrScanner.dart';
import 'package:qr_code_scanner/test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Qr Code scanner",
      home: const QrScanner(),
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent
        )
      ),
    );
  }
}
