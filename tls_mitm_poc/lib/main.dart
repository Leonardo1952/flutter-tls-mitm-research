import 'package:flutter/material.dart';

import 'home_page.dart';

void main() {
  runApp(const RateTodayApp());
}

class RateTodayApp extends StatelessWidget {
  const RateTodayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rate Today',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const HomePage(),
    );
  }
}
