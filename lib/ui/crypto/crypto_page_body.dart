import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:starter_flutter/ui/crypto/details/crypto_summary.dart';
import 'package:path_provider/path_provider.dart';
import 'package:starter_flutter/ui/model/cryptos.dart';

class CryptoPageBody extends StatefulWidget {
  @override
  CryptoPageBodyState createState() => new CryptoPageBodyState();
}

class CryptoPageBodyState extends State<CryptoPageBody> {
  List data;
  bool isLoading = true;

  Future<bool> getDataFromAPI() async {
    var response = await http.get(
      Uri.encodeFull("https://api.coinmarketcap.com/v1/ticker/?convert=" +
          "EUR" +
          "&limit=100"),
      headers: {"Accept": "application/json"},
    );

    this.setState(() {
      data = json.decode(response.body);
      isLoading = false;
    });
    String content = response.body;
    (await getLocalFile()).writeAsString('$content');

    return true;
  }

  Future refresh() async {
    await getDataFromAPI();
  }

  Future<File> getLocalFile() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/coin_list.txt');
  }

  Future<bool> getDataFromLocal() async {
    try {
      File file = await getLocalFile();
      String contents = await file.readAsString();
      print(json.decode(contents));
      this.setState(() {
        data = json.decode(contents);
        isLoading = false;
      });

      return true;
    } on FileSystemException {
      return false;
    }
  }

  Future<bool> getData() async {
    if (!(await getDataFromLocal())) {
      await getDataFromAPI();
    }
    return true;
  }

  Future loadData() async {
    await getDataFromAPI();
    await getData();
  }

  Crypto getCoin(int index) {
    if (data != null) {
      return new Crypto(
        data[index]["id"],
        data[index]["name"],
        data[index]["symbol"],
        data[index]["rank"],
        data[index]["price_usd"],
        data[index]["price_btc"],
        data[index]["24h_volume_usd"],
        data[index]["market_cap_usd"],
        data[index]["available_supply"],
        data[index]["total_supply"],
        data[index]["percent_change_1h"],
        data[index]["percent_change_24h"],
        data[index]["percent_change_7d"],
        data[index]["last_updated"],
        data[index]["price_eur"],
        data[index]["24h_volume_eur"],
        data[index]["market_cap_eur"],
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        // Center the content
        child: new RefreshIndicator(
            onRefresh: refresh,
            child: new CustomScrollView(
                scrollDirection: Axis.vertical,
                shrinkWrap: false,
                slivers: <Widget>[
                  new SliverPadding(
                    padding: new EdgeInsets.all(8.0),
                    sliver: new SliverList(
                      delegate: data != null
                          ? new SliverChildBuilderDelegate(
                              (context, index) =>
                                  new CryptoSummary(getCoin(index)),
                              childCount: data == null ? 100 : data.length,
                            )
                          : new SliverChildBuilderDelegate(
                              (context, index) => new CircularProgressIndicator(
                                    backgroundColor: Colors.red,
                                  ),
                              childCount: 0,
                            ),
                    ),
                  )
                ])));
  }
}
