// Strings
import 'package:flutter/material.dart';

// const baseURL = 'http://127.0.0.1:8000/api';
const baseURL = 'http://192.168.222.146:8000/api';
const loginURL = baseURL + '/login';
const registerURL = baseURL + '/register';
const logoutURL = baseURL + '/logout';
const userURL = baseURL + '/user';
const userIdURL = baseURL + '/userId';
const postsURL = baseURL + '/posts';
const commentairesURL = baseURL + '/commentaires';

// Erreurs
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';

// Input Decoration
InputDecoration inputDecoration(String label){
  return InputDecoration(
      labelText: label,
      contentPadding: EdgeInsets.all(10),
      border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey))
  );
}

// Like and Commentaires btn

Expanded kLikeAndComment(int value, IconData iconData, Color color, Function onTap){
  return Expanded(
      child: Material(
    child: InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, size: 16, color: color,),
            SizedBox(width: 4,),
            Text('${value}')
          ],
        ),
      ),
    ),
  ));
}