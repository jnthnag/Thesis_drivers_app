import 'package:flutter/material.dart';
import 'package:thesis_driver_app/authentication/login_screen.dart';
import 'package:thesis_driver_app/authentication/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thesis_driver_app/firebase_options.dart';


Future<void> main()async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black87,

      ),
      home: SignUpScreen(),
    );
  }
}

