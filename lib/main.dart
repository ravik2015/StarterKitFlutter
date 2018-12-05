import 'package:flutter/material.dart';
import 'package:starter_flutter/ui/home/home_page.dart';
import 'package:starter_flutter/ui/about/about_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'News'),
      routes: <String, WidgetBuilder>{
        // Set named routes
        AboutPage.routeName: (BuildContext context) => new AboutPage(),
      },
    );
  }
}
