import 'package:flutter/material.dart';
import 'package:my_document_scanner/screens/home_screen.dart';
import 'package:my_document_scanner/screens/splash_screen.dart';
import 'db_helper/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  runApp(const MyApp());
}
// #
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ScanMate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff46A094)),
        useMaterial3: true,
        appBarTheme: const  AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
          color: Color(0xff46A094),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/':(context) => const AnimatedSplashScreen(),
        '/home':(context) => const HomeScreen(),
      },
    );
  }
}