import 'package:flutter/material.dart';
import 'package:flutter_laravel_api/pages/posts/post.dart';
import 'package:flutter_laravel_api/pages/posts/post_form.dart';
import 'package:flutter_laravel_api/pages/profiles/profile.dart';
import 'package:flutter_laravel_api/screens/login.dart';
import 'package:flutter_laravel_api/services/user_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Déclarations des variables
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(onPressed: (){
            logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
          }, icon: Icon(Icons.logout))
        ],
      ),
      body: currentIndex == 0 ? PostIndex() : Profiles(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (ctx) => PostForm(title: "Ajouter une post")));
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5,
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              label: '',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(Icons.person),
            ),
          ],
          currentIndex: currentIndex,
          onTap: (value){
            currentIndex = value;
          },
        ),
      ),
    );
  }
}
