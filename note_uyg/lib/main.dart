import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note_uyg/screens/edit_note.dart';
import 'package:note_uyg/pages/home_page.dart';
import 'package:note_uyg/pages/sign_up.dart';

import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/loginPage": (context) => LoginPage(),
        "/homePage": (context) => HomePage(),
        "/signUp": (context) => SignUp(),
        "/editNote": (context) =>
            EditNote(noteId: '', initialTitle: '', initialContent: ''),
      },
      home: Scaffold(
        body: LoginPage(),
      ),
    );
  }
}
