import 'package:flutter/material.dart';
import 'services/parse_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ParseService.initializeParse();
  final user = await ParseService.currentUser();

  runApp(MaterialApp(
    home: user == null ? const LoginScreen() : const HomeScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
