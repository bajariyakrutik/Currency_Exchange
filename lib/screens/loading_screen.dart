import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:currency_exchange/services/networking.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class LoadingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoadingScreenState();
  }
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    String request = "https://open.er-api.com/v6/latest/INR";

    NetworkHelper networkHelper = NetworkHelper(request);
    var data = await networkHelper.getData();

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Home(
        curData: data,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitFoldingCube(
          color: Colors.white,
          size: 100.0,
        ),
      ),
    );
  }
}
