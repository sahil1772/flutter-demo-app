import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/routing/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    getBatteryLevel();
  }

  getBatteryLevel() async {
    final int result = await const MethodChannel('com.example.app')
        .invokeMethod('getBatteryLevel');
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("$result")));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo App',
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: AppRouter.routes,
      initialRoute: '/',
    );
  }
}
