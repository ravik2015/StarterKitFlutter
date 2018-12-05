import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math' as Math;

import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:starter_flutter/ui/layout/layout_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  static const List<IconData> icons = const [Icons.settings, Icons.view_list];

  var newsSelection = "crypto-coins-news";
  String apiKey = "97ec2e1bd66c4a83bea5a50471589972";
  var data;
  final FlutterWebviewPlugin flutterWebViewPlugin = new FlutterWebviewPlugin();

  Future getData() async {
    var response = await http.get(
        Uri.encodeFull(
            'https://newsapi.org/v2/everything?sources=' + newsSelection),
        headers: {
          "Accept": "application/json",
          "X-Api-Key": apiKey,
        });
    var localData = json.decode(response.body);

    this.setState(() {
      data = localData;
    });
  }

  @override
  void initState() {
    _controller = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    this.getData();
    super.initState();
  }

  Future refresh() async {
    await getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // AppBar
      appBar: new AppBar(
        // Title
        title: Text(widget.title),
        // App Bar background color
        backgroundColor: Colors.red,
      ),
      // Body
      body: new Container(
        constraints: new BoxConstraints.expand(),
        // Center the content
        child: new Stack(
          children: <Widget>[
            new Container(
              padding: new EdgeInsets.fromLTRB(0.0, 0, 0.0, 0.0),
              child: data == null
                  ? const Center(child: const CircularProgressIndicator())
                  : data["articles"].length != 0
                      ? new RefreshIndicator(
                          onRefresh: refresh,
                          child: new ListView.builder(
                            itemCount:
                                data == null ? 0 : data["articles"].length,
                            padding: new EdgeInsets.all(8.0),
                            itemBuilder: (BuildContext context, int index) {
                              print(data["articles"][index]["source"]["name"]);
                              return new Container(
                                  height: 400,
                                  margin: new EdgeInsets.only(top: 10.0),
                                  decoration: new BoxDecoration(
                                    color: new Color(0xFFFFFFFF),
                                    shape: BoxShape.rectangle,
                                    // borderRadius: new BorderRadius.circular(30.0),
                                    boxShadow: <BoxShadow>[
                                      new BoxShadow(
                                        color: new Color(0xFF000000),
                                        blurRadius: 10.0,
                                        offset: new Offset(0.0, 10.0),
                                      ),
                                    ],
                                  ),
                                  child: new Column(children: [
                                    new Expanded(
                                      flex: 6,
                                      child: Container(
                                          constraints: BoxConstraints.expand(),
                                          color: Colors.red,
                                          child: new Image.network(
                                            data["articles"][index]
                                                ["urlToImage"],
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                    new Expanded(
                                      flex: 3,
                                      child: new Padding(
                                        padding: new EdgeInsets.all(10.0),
                                        child: new GestureDetector(
                                          child: new Container(
                                            constraints:
                                                BoxConstraints.expand(),
                                            color: Colors.white,
                                            child: Center(
                                              child: new Padding(
                                                padding: new EdgeInsets.only(
                                                    left: 4.0,
                                                    right: 4.0,
                                                    bottom: 4.0),
                                                child: new Text(
                                                  data["articles"][index]
                                                      ["description"],
                                                  style: new TextStyle(
                                                    color: Colors.grey[500],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(
                                              new PageRouteBuilder(
                                                pageBuilder: (_, __, ___) =>
                                                    new WebviewScaffold(
                                                      url: data["articles"]
                                                          [index]["url"],
                                                      appBar: new AppBar(
                                                        centerTitle: true,
                                                        title: new Text(
                                                          "News Details",
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Poppins',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                    ),
                                                transitionsBuilder: (context,
                                                        animation,
                                                        secondaryAnimation,
                                                        child) =>
                                                    new FadeTransition(
                                                        opacity: animation,
                                                        child: child),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    new Expanded(
                                      flex: 1,
                                      child: Container(
                                        constraints: BoxConstraints.expand(),
                                        color: Colors.white,
                                        child: Center(
                                          child: new Padding(
                                            padding: new EdgeInsets.all(10.0),
                                            child: new Row(
                                              children: <Widget>[
                                                new Padding(
                                                  padding: new EdgeInsets.only(
                                                      left: 4.0),
                                                  child: new Text(
                                                    timeago.format(DateTime
                                                        .parse(data["articles"]
                                                                [index]
                                                            ["publishedAt"])),
                                                    style: new TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ),
                                                new Padding(
                                                  padding:
                                                      new EdgeInsets.all(5.0),
                                                  child: new Text(
                                                    data["articles"][index]
                                                        ["source"]["name"],
                                                    style: new TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ]));
                            },
                          ),
                        )
                      : new Center(
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              new Icon(Icons.chrome_reader_mode,
                                  color: Colors.grey, size: 60.0),
                              new Text(
                                "No articles",
                                style: new TextStyle(
                                    fontSize: 24.0, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the Drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
