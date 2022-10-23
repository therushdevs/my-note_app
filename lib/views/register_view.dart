import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/utilities/show_error_dialogue.dart';
import 'package:my_notes/views/constants/routes.dart';
import '../firebase_options.dart';
import 'Dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

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

              Text('Sign Up'),
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

                try {
                  //We no more need to return these credentials so no need to assign to a variable
                  // final userCred =
                  await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  // PushNamed used caused we want to put the register screen in the background
                  //so that is user wanna make changes in email or password he could be able to do it so
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                  // devtools.log(userCred.toString());
                }on FirebaseAuthException catch (e){
                  if(e.code == 'weak-password') {
                    await showErrorDialogue(context, 'Wrong Password');
                  } else if (e.code == 'mail-already-in-use') {
                    await showErrorDialogue(context, 'Email already in use');
                  } else if (e.code == 'invalid-email') {
                    await showErrorDialogue(context, 'Invalid Email');
                  }else{
                    await showErrorDialogue(context, 'Error: ${e.code}');
                  }
                } catch (e){
                await showErrorDialogue(context, e.toString());
                }

              },
              child:const Text('SignUp')
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('Already Registered? '),

              ElevatedButton(onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
              }, child: const Text('Log In'))
            ],
          )

        ],
      ),
    );
  }
}
