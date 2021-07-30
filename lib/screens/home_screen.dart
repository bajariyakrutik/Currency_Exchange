import 'package:flutter/material.dart';
import 'package:country_icons/country_icons.dart';

class Home extends StatefulWidget {
  Home({this.curData});

  final curData;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final inrController = TextEditingController();
  final usdController = TextEditingController();
  final cadController = TextEditingController();

  double usd = 0.0;
  double cad = 0.0;

  @override
  void initState() {
    super.initState();
    var curData = widget.curData;
    usd = curData['rates']['USD'];
    cad = curData['rates']['CAD'];
  }

  // void updateUI(dynamic curData) {
  //   setState(() {
  //     usd = curData['rates']['USD'];
  //     cad = curData['rates']['CAD'];
  //   });
  // }

  void _clearAll() {
    inrController.text = "";
    usdController.text = "";
    cadController.text = "";
  }

  void _inrChanged(String text) {
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
    inrController.text = (usd / this.usd).toStringAsFixed(2);
    cadController.text = (usd / this.usd * cad).toStringAsFixed(2);
  }

  void _cadChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double cad = double.parse(text);
    inrController.text = (cad / this.cad).toStringAsFixed(2);
    usdController.text = (cad / this.cad * usd).toStringAsFixed(2);
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg_image.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.25), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image.asset('icons/flags/png/in.png', package: 'country_icons'),
              // Icon(Icons.monetization_on,
              //     size: 100.0, color: Colors.blueAccent),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    buildTextField("Rupees", "₹", inrController, _inrChanged),
              ),
              Divider(),
              Image.asset('icons/flags/png/ca.png', package: 'country_icons'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildTextField(
                    "Canadian Dollar", "CAD\$", cadController, _cadChanged),
              ),
              Divider(),
              Image.asset('icons/flags/png/us.png', package: 'country_icons'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildTextField(
                    "US Dollars", "US\$", usdController, _usdChanged),
              ),
            ],
          ),
        ),
      ),
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
    onChanged: (value) {
      f(value);
    },
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}
