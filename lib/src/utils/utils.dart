

import 'package:flutter/material.dart';

bool isNumeric(String s){
   
   if (s.isEmpty) return false;

   final n = num.tryParse(s);

   return (n == null) ? false : true;
}

void mostrarAlerta(BuildContext context, String mensaje){


showDialog(
  context: context,
  builder: (context){
    return AlertDialog(
       title: const Text('Datos incorrectos'),
       content: Text(mensaje),
       actions: <Widget>[
         FlatButton(
           child: const Text('OK'),
           onPressed: () => Navigator.of(context).pop(),
         )
       ],

    );
  }
);

}