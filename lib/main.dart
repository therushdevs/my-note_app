import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/views/constants/routes.dart';
import 'package:my_notes/views/login_view.dart';
import 'package:my_notes/views/register_view.dart';
import 'package:my_notes/views/verifyEmail_view.dart';
import 'Dart:developer' as devtools show log;

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
        routes: {
          loginRoute : (context){
            return const LoginView();
          },
          registerRoute: (context){
            return const RegisterView();
          },
          notesRoute : (context){
            return const NotesView();
          },
          verifyEmailRoute: (context){
            return const VerifyEmailView();
          }
        },
      ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    //Homepage returns the login view only so there's no meaning in
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){

          if (snapshot.connectionState == ConnectionState.done){
            // Print the below statement after log in to see the details of current user and
            //different attributes helpful to understand the Verification.
            // print(FirebaseAuth.instance.currentUser);
            final user = FirebaseAuth.instance.currentUser;
            // if (user?.emailVerified == true) devtools.log('Verification Complete');
            // final verifiedUser = user?.emailVerified ??  false;
            if (user != null) {
               if (user.emailVerified){
                 devtools.log('User Email Verified');
                  return const NotesView();
               }else{
                 return const VerifyEmailView();
               }
            } else {
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder:  (context) => const VerifyEmailView(),
              // )
              // );
              return const LoginView();
            }
          //  The reason for returning the text in here was I never returned anything in Verified condition
          }else{
            // Adds a circular loading Animation
            return const CircularProgressIndicator();
          }

        },
      );

  }
}

//The main UI of the project after user logged in
class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}


enum MenuAction {logout}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
          Text('MyNote App'),

          Text('Your Notes'),
          ],
          ),
          actions: [
            PopupMenuButton<MenuAction>(
              onSelected: (value) async{
              // Navigator.of(context).pushNamedAndRemoveUntil('/login/', (route) => false);
              switch(value){
                case MenuAction.logout:
                  // TODO: Handle this case.
                  final shouldLogout = await showLogoutDialogue(context);
                  if (shouldLogout){
                   await FirebaseAuth.instance.signOut();
                   Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  }
                  break;
              }
              },
              itemBuilder: (context){
              return const [
                PopupMenuItem<MenuAction>(value: MenuAction.logout,
                child: Text('Log Out'),
                ),
              ];
            },)
          ],
        ),
    );
  }
}

Future<bool> showLogoutDialogue (BuildContext context){
  return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            ElevatedButton(onPressed: (){
              Navigator.of(context).pop(false);
            }, child: const Text('Cancel')),
            ElevatedButton(onPressed: (){
              Navigator.of(context).pop(true);
            }, child: const Text('Log Out'))
          ],
        );
      }).then((value) => value ?? false);
}


