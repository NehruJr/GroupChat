import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/screens/chat_screen.dart';
import 'package:groupchat/screens/signin_screen.dart';
import 'package:groupchat/screens/welcome_screen.dart';

import 'screens/registration_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: _auth.currentUser !=null ? ChatScreen.routeName : WelcomeScreen.routeName,
      routes: {
        WelcomeScreen.routeName : (context) => WelcomeScreen(),
        SignInScreen.routeName : (context) => SignInScreen(),
        RegistrationScreen.routeName : (context) => RegistrationScreen(),
        ChatScreen.routeName : (context) => ChatScreen(),
      },
    );
  }
}
