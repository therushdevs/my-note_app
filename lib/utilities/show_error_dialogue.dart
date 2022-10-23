

import 'package:flutter/material.dart';

Future <void> showErrorDialogue(BuildContext context, String text){
  return showDialog(context: context, builder: (context){
    return AlertDialog(
      title: const Text('An Error Occurred!'),
      content: Text(text),
      actions: [
        ElevatedButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: const Text('Ok'),
        )
      ],

    );
  });
}