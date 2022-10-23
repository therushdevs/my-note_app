import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_notes/main.dart';
import 'package:my_notes/views/constants/routes.dart';
import '../firebase_options.dart';
import '../utilities/show_error_dialogue.dart';
import 'firebase_options.dart';

//important library for debugging purpose: devtools.log();
// import 'Dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  late final TextEditingController _email;
  late final TextEditingController _password;


  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text('MyNote App'),

              Text('Log In'),
            ],
          )

      ),
      body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              controller: _email,
              decoration: const InputDecoration(
                hintText: 'Please Enter your Email ',
              ),
            ),
            TextField(
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              controller: _password,
              decoration: const InputDecoration(
                  hintText: 'Please Enter your Password '
              ),
            ),
            ElevatedButton(
              // The reason behind using async is the registration will take some time
              // to add the info on backend so we might need to use Iterables, Streams or Future.
                onPressed: () async {

                  // await Firebase.initializeApp(
                  //   options: DefaultFirebaseOptions.currentPlatform,
                  // ); removed and placed in future parameter of FutureBuilder
                  final email = _email.text;
                  final password = _password.text;

                  try{
                    await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => const NotesView()));
                    Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false);
                  } on FirebaseAuthException catch (e){
                    // To see the type of exception to handle it properly
                    //  print(e.runtimeType);
                    //  Given a specific exception to handle
                    //  Now the e isn't really an object anymore it hase became the var of type of the exception mentioned
                    //   print(e.code);

                    //  Now we can return message for specific errors.
                    if (e.code == 'user-not-found') {
                      await showErrorDialogue(context, 'User not found');
                    } else if (e.code == 'wrong-password') {
                      await showErrorDialogue(context, 'Wrong Password');
                    }else{
                      await showErrorDialogue(context, 'Error: ${e.code}');
                    }
                  }

                },
                child:const Text('Log In')
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('Not Registered Yet? '),

                ElevatedButton(onPressed: (){
                  Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
                },
                    child: const Text('Register Here'))
              ],
            )
          ],
        ),
    );

  }
}

