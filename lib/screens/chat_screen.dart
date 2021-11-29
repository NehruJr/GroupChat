import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/screens/signin_screen.dart';

final _firestore = FirebaseFirestore.instance;
User? signedUser;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  static const routeName = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  String? messageText;
  final messageTextController = TextEditingController();

  void getCurrentUser(){
   User? user =  _auth.currentUser;
   try {
     if (user != null) {
       signedUser = user;
       print(signedUser!.email);
       print(user.email);
     }
   }catch(e){print(e);}
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: const Text('Messages' , style: TextStyle(color: Colors.white),),
      actions: [
        TextButton(onPressed: (){
          _auth.signOut();
          Navigator.pushNamedAndRemoveUntil(context, SignInScreen.routeName, (route) => true);
        }, child: const Text('Sign out')),
      ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStreamBuilder(),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.orange , width: 2),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: TextField(
                    controller: messageTextController,
                    onChanged: (value){
                      messageText = value;
                    },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10 , horizontal: 20),
                  hintText:'write your message here...',
                    border: InputBorder.none
                  ),

                  ),
                  ),
                  TextButton(onPressed: (){
                    _firestore.collection('messages').add({
                      'text' : messageText,
                      'sender' : signedUser!.email,
                      'time' : FieldValue.serverTimestamp(),
                    });
                    messageTextController.clear();
                  }, child: Text('Send' , style: TextStyle(
                    color: Colors.blue[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStreamBuilder extends StatelessWidget {
  const MessageStreamBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('time').snapshots(),
      builder: (context, snapshot) {
        List<MessageLine> messagesWidgets = [];
        if(!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );

        }
        snapshot.data!.docs.reversed.forEach((message) {
          final messageText = message.get('text');
          final messageSender = message.get('sender');
          final currentUser = signedUser!.email;

          final messageWidget = MessageLine(
            text: messageText,
            sender: messageSender,
          isMe: currentUser == messageSender? true : false,);
          messagesWidgets.add(messageWidget);
        });
        return Expanded(
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.all(20),
            children: messagesWidgets,
          ),
        );

      },);
  }
}


class MessageLine extends StatelessWidget {
  const MessageLine({Key? key, this.sender, this.text, required this.isMe}) : super(key: key);
  final String? sender;
  final String? text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender! ,style: TextStyle(fontSize: 12 , color: Colors.yellow[900]) ,),
          Material(
            elevation: 5,
            borderRadius: isMe? const BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ) :  const BorderRadius.only(
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            color: isMe ? Colors.blue[800] : Colors.grey[300],
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0 , horizontal: 20),
              child: Text(text! , style: TextStyle(fontSize: 15 , color: isMe ? Colors.white : Colors.black),),
            ),
          ),
        ],
      ),
    );
  }
}

