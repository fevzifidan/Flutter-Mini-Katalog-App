import 'package:flutter/material.dart';
import 'services/local_storage_service.dart';
import 'views/login_screen.dart';
import 'views/home_screen.dart';

void main() {
  runApp(const MiniKatalogApp());
}

class MiniKatalogApp extends StatelessWidget {
  const MiniKatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Katalog Uygulaması',
      home: _buildInitialScreen(),
    );
  }

  Widget _buildInitialScreen() {
    if (LocalStorageService.isLoggedIn) {
      return const HomeScreen();
    }
    return const LoginScreen();
  }
}

