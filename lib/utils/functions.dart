import 'package:flutter/material.dart';

TextButton textButton(String label, Function onPressed){
 return TextButton(
     onPressed: () => onPressed(),
     child: Text(label, style: TextStyle(color: Colors.white),),
     style: ButtonStyle(
         backgroundColor: MaterialStateColor.resolveWith((state) => Colors.blue),
         padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.symmetric(vertical: 10)))
 );
}

Row loginRegisterHint(String text, String label, Function onTap){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text),
      GestureDetector(
        child: Text(label, style: TextStyle(color: Colors.blue),),
        onTap: () => onTap(),
      ),
    ],
  );
}