import 'package:flutter/material.dart';

import 'pages/catalog_page.dart';

void main() {
  runApp(const KopiKitaApp());
}

/// Widget root aplikasi (StatelessWidget): hanya mengatur tema dan halaman awal.
class KopiKitaApp extends StatelessWidget {
  const KopiKitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kopi Kita',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6F4E37),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFAF5EF),
        appBarTheme: const AppBarTheme(centerTitle: true),
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const CatalogPage(),
    );
  }
}
