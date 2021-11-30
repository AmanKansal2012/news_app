import 'package:flutter/material.dart';
import 'package:news_app/data/news_fetch.dart';
import 'package:news_app/views/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => NewsFetch())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyNEWS',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
