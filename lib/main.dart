import 'package:btl/Pages/history/History.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:btl/Object/user.dart';
import 'package:btl/Pages/Wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyADo5uh1vfK4UPGEE3_-m4Gj6a85igxwQM',
    appId: '1:488251418205:android:8ae7930ac08b6bb83fcfb4',
    messagingSenderId: '488251418205',
    projectId: 'baitl-38912',
    storageBucket: 'baitl-38912.appspot.com',
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
          providers: [ChangeNotifierProvider(create: (context) => user())],
          child: const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: History(),
          )),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
        ),
      ),
    );
  }
}
