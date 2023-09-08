import 'package:flutter/material.dart';
import 'package:flutter_laravel_api/api/api_response.dart';
import 'package:flutter_laravel_api/models/user.dart';
import 'package:flutter_laravel_api/pages/home.dart';
import 'package:flutter_laravel_api/screens/login.dart';
import 'package:flutter_laravel_api/services/user_services.dart';
import 'package:flutter_laravel_api/utils/constant.dart';
import 'package:flutter_laravel_api/utils/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  // Déclarations des variables
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmePassword = TextEditingController();
  bool loading = false;

  void _registerUser() async {
    ApiResponse response = await register(_name.text, _email.text, _password.text);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            TextFormField(
                controller: _name,
                keyboardType: TextInputType.name,
                validator: (value) => value!.isEmpty ? 'Veuillez saisir votre nom' : null,
                decoration: inputDecoration("Nom")
            ),
            SizedBox(height: 10,),
            TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? 'Adresse e-mail est invalide!' : null,
                decoration: inputDecoration("Adresse e-mail")
            ),
            SizedBox(height: 10,),
            TextFormField(
                obscureText: true,
                controller: _password,
                keyboardType: TextInputType.text,
                validator: (value) => value!.isEmpty ? 'Le mot de passe doit avoir au moins 6 caractères!1' : null,
                decoration: inputDecoration("Mot de passe")
            ),
            SizedBox(height: 10,),
            TextFormField(
                obscureText: true,
                controller: _confirmePassword,
                keyboardType: TextInputType.text,
                validator: (value) => value!.isEmpty ? 'Le mot de passe doit avoir au moins 6 caractères!' : value != _password.text ? "Confirmer votre mot de passe!" : null,
                decoration: inputDecoration("Confirmer votre mot de passe")
            ),
            SizedBox(height: 10,),
            loading? Center(child: CircularProgressIndicator(),) :
            textButton("S'inscrire", (){
              setState(() {
                loading = !loading;
              });
              _registerUser();
            }),
            SizedBox(height: 10,),
            loginRegisterHint("I have already an account? ", "login",() => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false))
          ],
        ),
      ),
    );
  }
}


