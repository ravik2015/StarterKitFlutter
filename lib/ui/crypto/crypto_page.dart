import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:starter_flutter/ui/crypto/crypto_page_body.dart';

class CryptoPage extends StatefulWidget {
  static const String routeName = "/crypto";

  @override
  State createState() => new CryptoPageState();
}

class CryptoPageState extends State<CryptoPage> with TickerProviderStateMixin {
  AnimationController _controller;
  static const List<IconData> icons = const [Icons.settings, Icons.view_list];

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // AppBar
      appBar: new AppBar(
        // Title
        title: new Text("Market"),
        // App Bar background color
        backgroundColor: Colors.red,
      ),
      // Body
      body: new CryptoPageBody(),
    );
  }
}
