import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_laravel_api/api/api_response.dart';
import 'package:flutter_laravel_api/models/user.dart';
import 'package:flutter_laravel_api/screens/login.dart';
import 'package:flutter_laravel_api/services/user_services.dart';
import 'package:flutter_laravel_api/utils/constant.dart';
import 'package:flutter_laravel_api/utils/functions.dart';
import 'package:image_picker/image_picker.dart';

class Profiles extends StatefulWidget {
  const Profiles({Key? key}) : super(key: key);

  @override
  State<Profiles> createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {
  User? user;
  bool loading = true;
  File? _imageFile;
  final _picker = ImagePicker();
  TextEditingController nameController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  Future getImage() async{
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void getUser() async{
    ApiResponse response = await getUserDetails();
    if(response.error == null){
      setState(() {
        user = response.data as User;
        loading = false;
        nameController.text = user!.name ?? '';
      });
    }else if(response.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${response.error}")));
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ?
    Center(child: CircularProgressIndicator(),)
        :
    Padding(
        padding: EdgeInsets.only(top: 40, right: 40, left: 40),
        child: ListView(
          children: [
            Center(
              child: GestureDetector(
                onTap: () => getImage,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    image: _imageFile == null ? user!.image != null ? DecorationImage(
                        image: NetworkImage('${user!.image}'),
                        fit: BoxFit.cover
                    ):null : DecorationImage(
                        image: FileImage(_imageFile ?? File('')),
                        fit: BoxFit.cover
                    ),
                    color: Colors.amber
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Form(
                key: formkey,
                child: TextFormField(
                  decoration: inputDecoration("Nom"),
                  controller: nameController,
                  validator: (value) => value!.isEmpty ? "Veuillez saisir votre nom" : null,
                )
            ),
            SizedBox(height: 20,),
            textButton('Modifier', (){
              if(formkey.currentState!.validate()){
                setState(() {
                  loading = true;
                });
                updateProfile();
              }
            })
          ],
        ),
    );
  }

  void updateProfile() async{
    ApiResponse response = await updateUser(nameController.text, getStringImage(_imageFile));
    setState(() {
      loading = false;;
    });
    if(response.error == null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${response.data}")));
    }else if(response.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${response.error}")));
    }
  }
}
