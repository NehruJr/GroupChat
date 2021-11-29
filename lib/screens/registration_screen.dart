import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/screens/chat_screen.dart';
import 'package:groupchat/widgets/mybutton.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  static const routeName = 'registration_screen';


  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;

   late String userEmail;
   late String userPassword;

   bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 180,
                child: Text('Group Chat'),
              ),
              const SizedBox(
                height: 50,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value){
                  userEmail = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter Your Email',
                  contentPadding: EdgeInsets.symmetric(vertical: 10 , horizontal: 20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Colors.orange,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value){
                    userPassword = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter Your Password',
                  contentPadding: EdgeInsets.symmetric(vertical: 10 , horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Colors.orange,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              myButton(color: Colors.blue[800]!, title: 'register', onPressed: ()async{
                setState(() {
                  _saving = true;
                });
                try{
                  final newUser = await _auth.createUserWithEmailAndPassword(email: userEmail, password: userPassword);
                  Navigator.pushNamed(context, ChatScreen.routeName);
                  setState(() {
                    _saving = false;
                  });
                }catch(e){
                  print(e);
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
