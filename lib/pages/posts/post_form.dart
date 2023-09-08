import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_laravel_api/api/api_response.dart';
import 'package:flutter_laravel_api/models/post.dart';
import 'package:flutter_laravel_api/pages/home.dart';
import 'package:flutter_laravel_api/screens/login.dart';
import 'package:flutter_laravel_api/services/post_service.dart';
import 'package:flutter_laravel_api/services/user_services.dart';
import 'package:flutter_laravel_api/utils/constant.dart';
import 'package:flutter_laravel_api/utils/functions.dart';
import 'package:image_picker/image_picker.dart';

class PostForm extends StatefulWidget {

  final Posts? post;
  final String? title;

  PostForm({
    this.post,
    this.title
  });

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {

  // Déclarations des variables
  Posts? postE;
  String? title;
  TextEditingController _body = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool loading = false;
  File? _imageFile;
  final _picker = ImagePicker();

  Future getImage() async{
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _createPost() async{
    String? image = _imageFile == null ?  null : getStringImage(_imageFile);
    ApiResponse response = await createPost(_body.text, image);
    if(response.error == null){
      Navigator.pop(context);
    }else if(response.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${response.error}")));
      setState(() {
        loading = !loading;
      });
    }
  }

  void _editPost(int postId) async{
    ApiResponse response = await updatePost(postId, _body.text);
    if(response.error == null){
      Navigator.pop(context);
    }else if(response.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${response.error}")));
      setState(() {
        loading = !loading;
      });
    }
  }

  @override
  void initState() {
    title = widget.title;
    postE = widget.post;
    if(postE != null){
      _body.text = postE!.body ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$title"),
      ),
      body: loading ? Center(child: CircularProgressIndicator(),) : ListView(
        children: [
          postE != null ? SizedBox() :
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            decoration: BoxDecoration(
              image: _imageFile == null ? null : DecorationImage(
                  image: FileImage(_imageFile ?? File('')), fit: BoxFit.cover
              )
            ),
            child: Center(
              child: IconButton(
                icon: Icon(Icons.image, size: 50, color: Colors.black38,),
                onPressed: (){
                    getImage();
                },
              ),
            ),
          ),
          Form(
            key: _formkey,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: TextFormField(
                controller: _body,
                keyboardType: TextInputType.multiline,
                maxLines: 9,
                validator: (value) => value!.isEmpty ? 'Post body is required' : null,
                decoration: InputDecoration(
                  hintText: "Post body....",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.black38),
                  ),
                ),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: textButton('Post', (){
                if(_formkey.currentState!.validate()){
                  setState(() {
                    loading = !loading;
                  });
                  if(postE == null){
                    _createPost();
                  }else{
                    _editPost(postE!.id ?? 0);
                  }
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => HomePage()), (route) => false);
                }
              }),
          )
        ],
      ),
    );
  }
}
