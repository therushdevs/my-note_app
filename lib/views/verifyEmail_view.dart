import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:  const [
              Text('MyNote App'),

              Text('Please Verify'),

            ],
          )

      ),
      body: Column(

        children: [
          const Text('Please verify your email address.'),
          ElevatedButton(onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
          } ,
            child: const Text('Sent verification email'),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('Verified your email? Login again to confirm: '),

              ElevatedButton(onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
              }, child: const Text('Click here'))
            ],
          ),
        ],
      ),
    );
  }
}




