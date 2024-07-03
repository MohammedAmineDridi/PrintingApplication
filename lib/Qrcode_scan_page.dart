import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:testproject/Color_mode.dart';

class QrCodePage extends StatefulWidget {
  @override
  const QrCodePage({Key? key}) : super(key: key);
  State<QrCodePage> createState() => QrCodeApp();
}

class QrCodeApp extends State<QrCodePage> {
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context1) {
    var colormode_provider = Provider.of<ColorMode>(context1);
    var height_screen = MediaQuery.of(context1).size.height;
    var width_screen = MediaQuery.of(context1).size.width;
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Container(
                  margin: EdgeInsets.only(left: width_screen / 5),
                  child: const Text('Printer QrCode scan')),
              backgroundColor: colormode_provider.appBar_Color,
            ),
            backgroundColor: colormode_provider.screen_Color,
            body: Builder(builder: (BuildContext context2) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: colormode_provider.secondContainer_Color,
                          border: Border.all(
                              color: colormode_provider.borders_Color,
                              width: 0.5),
                          borderRadius: BorderRadius.circular(30.0)),
                      child: MaterialButton(
                          height: height_screen / 12,
                          minWidth: width_screen / 2,
                          onPressed: () => scanQR(),
                          child: Text('Start QR scan'))),
                  SizedBox(height: height_screen / 8),
                  Text('$_scanBarcode\n',
                      style: TextStyle(
                          fontSize: 20, color: colormode_provider.texts_Color)),
                  SizedBox(height: height_screen / 8),
                  Container(
                      decoration: BoxDecoration(
                          color: colormode_provider.secondContainer_Color,
                          border: Border.all(
                              color: colormode_provider.borders_Color,
                              width: 0.5),
                          borderRadius: BorderRadius.circular(30.0)),
                      child: MaterialButton(
                          height: height_screen / 12,
                          minWidth: width_screen / 2,
                          onPressed: () {
                            Navigator.of(context1).pop();
                          },
                          child: Text('Back'))),
                ],
              ));
            })));
  }
}
