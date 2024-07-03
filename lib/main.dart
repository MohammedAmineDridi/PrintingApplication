import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
/* ----------------- printx pages imports ------------------------ */
import 'package:testproject/SelectDevice_ConnectPage.dart';
import 'package:testproject/MenuPage.dart';
import 'package:testproject/Hand_draw_page.dart';
import 'package:testproject/Add_text_page.dart';
import 'package:testproject/Upload_image.dart';
import 'package:testproject/Gallery_page.dart';
import 'package:testproject/Color_mode.dart';
import 'package:testproject/Qrcode_scan_page.dart';

void main() {
  //runApp(MyApp());
  runApp(
    ChangeNotifierProvider(
      create: (context) => ColorMode(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SelectConnectPage(), routes: {
      "select_device_connect_route": (context) => SelectConnectPage(),
      "menu_route": (context) => MenuPage(),
      "handDraw_route": (context) => HandDrawPage(),
      "addText_route": (context) => AddTextPage(),
      "uploadImage_route": (context) => UploadImagePage(),
      "gallery_route": (context) => GalleryPage(),
      "qrcode_scan_route": (context) => QrCodePage(),
    });
  }
}
