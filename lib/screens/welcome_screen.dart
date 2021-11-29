import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:groupchat/screens/registration_screen.dart';
import 'package:groupchat/screens/signin_screen.dart';
import 'package:groupchat/widgets/mybutton.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  static const routeName = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Group Chat' , style: TextStyle(fontSize: 40),),
            SizedBox(height: 30,),
            myButton(
              color: Colors.yellow[900]!,
              title: 'Sign in',
              onPressed: (){
                Navigator.pushNamed(context, SignInScreen.routeName);
              },
            ),
            myButton(
              color: Colors.blue[800]!,
              title: 'Sign up',
              onPressed: (){
                Navigator.pushNamed(context, RegistrationScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
