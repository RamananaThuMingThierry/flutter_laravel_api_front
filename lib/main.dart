import 'package:flutter/material.dart';
import 'package:flutter_laravel_api/pages/home.dart';
import 'package:flutter_laravel_api/pages/posts/post.dart';
import 'package:flutter_laravel_api/screens/loading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog teste api',
      home: HomePage(),
    );
  }
}
