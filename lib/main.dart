import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const request = "https://open.er-api.com/v6/latest/INR";

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.blueAccent, primaryColor: Colors.red),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final usdController = TextEditingController();
  final cadController = TextEditingController();

  //here we have declared the variables, that store rates from API
  double cad;
  double usd;

  void _clearAll() {
    realController.text = "";
    usdController.text = "";
    cadController.text = "";
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    usdController.text = (real * usd).toStringAsFixed(2);
    cadController.text = (real * cad).toStringAsFixed(2);
  }

  void _usdChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double usd = double.parse(text);
    realController.text = (usd / this.usd).toStringAsFixed(2);
    cadController.text = (usd / this.usd * cad).toStringAsFixed(2);
  }

  void _cadChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double cad = double.parse(text);
    realController.text = (cad * this.cad).toStringAsFixed(2);
    usdController.text = (cad * this.cad / usd).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Indian Currency Converter"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: getData(),
          //snapshot of the context/getData
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: Text(
                  "Loading...",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ));
              default:
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    "Error :(",
                    style: TextStyle(color: Colors.blueAccent, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ));
                } else {
                  //here we pull the us and eur rate
                  usd = snapshot.data["rates"]["USD"];
                  cad = snapshot.data["rates"]["CAD"];
                  return SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      Icon(Icons.monetization_on,
                          size: 100.0, color: Colors.blueAccent),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildTextField(
                            "Rupees", "₹", realController, _realChanged),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildTextField("Canadian Dollar", "CAD\$",
                            cadController, _cadChanged),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildTextField(
                            "US Dollars", "US\$", usdController, _usdChanged),
                      ),
                    ],
                  ));
                }
            }
          }),
    );
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController c, Function f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blueAccent),
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(color: Colors.blueAccent, fontSize: 25.0),
    onChanged: f,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}
