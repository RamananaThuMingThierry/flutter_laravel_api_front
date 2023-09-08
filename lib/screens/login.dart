import 'package:flutter/material.dart';
import 'package:flutter_laravel_api/api/api_response.dart';
import 'package:flutter_laravel_api/pages/home.dart';
import 'package:flutter_laravel_api/screens/register.dart';
import 'package:flutter_laravel_api/services/user_services.dart';
import 'package:flutter_laravel_api/utils/constant.dart';
import 'package:flutter_laravel_api/utils/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  // Déclarations des variables
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => value!.isEmpty ? 'Veuillez saisir votre adresse e-mail!' : null,
              decoration: inputDecoration("Adresse e-mail")
            ),
            SizedBox(height: 10,),
            TextFormField(
              obscureText: true,
              controller: _password,
              keyboardType: TextInputType.text,
              validator: (value) => value!.isEmpty ? "Veuillez saisir votre mot de passe" : value!.length < 6 ? "Le mot de passe doit avoir au moins 6 caractères!" : null,
              decoration: inputDecoration("Mot de passe")
            ),
            SizedBox(height: 10,),
            loading ? Center(child: CircularProgressIndicator(),) : textButton("Login", (){
              if(formKey.currentState!.validate()){
                setState(() {
                  loading = !loading;
                });
                _loginUser();
              }else{
                print("Invalide");
              }
            }),
            SizedBox(height: 10,),
            loginRegisterHint("Don't have an account? ", "register",() => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Register()), (route) => false))
          ],
        ),
      ),
    );
  }

  void _loginUser()async{
    ApiResponse response = await login(_email.text, _password.text);
    if(response.error == null){
      print("Nous somme là");
      _saveAndRedirectToHome(response.data as User);
    }else{
      setState(() {
        loading = !loading;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${response.error}")));
    }
  }

  void _saveAndRedirectToHome(User user) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => HomePage()), (route) => false);
  }
}
