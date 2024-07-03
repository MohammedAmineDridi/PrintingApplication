import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';
import "package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart";
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_painting_tools/flutter_painting_tools.dart';
import 'package:testproject/Color_mode.dart';
import 'package:provider/provider.dart';

class HandDrawPage extends StatefulWidget {
  const HandDrawPage({Key? key}) : super(key: key);
  State<HandDrawPage> createState() => HandDrawApp();
}

class HandDrawApp extends State<HandDrawPage> {
  // paintingboard controller
  late final PaintingBoardController controller;
  // -- vars dynamics --
  double m3 = 10;
  double m2 = 5;
  double sB0 = 40;
  double sB1_4 = 15;
  double h1 = 540; // h1 (540)
  double w1 = 460; // w1 (460)
  double h_prim = 0; // h'
  double w_prim = 0; // w'
  double h_second = 0; // h''
  double w_second = 0; // w''
  double h_row =
      0; // height of row of image params (zoom/left-right/up-down...)
  double nbr_sb1_4 = 4;
  double nbr_rows = 5;

  @override
  void initState() {
    // Init the painting controller
    controller = PaintingBoardController();
    // init : h'/h''/h_row = fct(h1) , + w'/w''/w_row = fct(w1)
    h_prim = (h1 / 2) - (sB0 / 2);
    w_prim = w1;
    h_second = (h1 / 2) - (sB0 / 2);
    w_second = w1;
    h_row = (h_second - (nbr_sb1_4 * sB1_4)) / nbr_rows;
    sB1_4 = 15 - m2;
    print("SB1 = SB2 = SB3 = SB4 = " + sB1_4.toString());
    print("h1 = " + h1.toString() + " / w1 = " + w1.toString());
    print("h' = " + h_prim.toString() + " / w' = " + w_prim.toString());
    print("h'' = " + h_second.toString() + " / w'' = " + w_second.toString());
    print("h_row1_4 = " + h_row.toString());
    super.initState();
  }

  @override
  void dispose() {
    // Dispose the controller
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var colormode_provider = Provider.of<ColorMode>(context);
    return Scaffold(
      appBar: AppBar(
        title: Container(
            margin: EdgeInsets.only(right: 60),
            child: Center(child: const Text("Hand Draw Page"))),
        backgroundColor: colormode_provider.appBar_Color,
      ),
      backgroundColor: colormode_provider.screen_Color,
      body: Container(
          margin: EdgeInsets.all(30),
          height: h1, // h1
          width: w1, // w1
          child: Column(
            children: [
              // column to split in 2 containers : 1 - img container / 2 - params container
              // image big container (h'/w')
              Container(
                color: Colors.white,
                height: h_prim, // h'
                width: w1, // w'= w1 = 460
                child: PaintingBoard(
                  boardDecoration: BoxDecoration(color: Colors.white),
                  controller: controller, // use here the controller
                  boardHeight: h_prim,
                  boardWidth: 350,
                ),
              ),
              // space between 2 main containers (SB0 = 40)
              SizedBox(height: sB0), // SB0 = 40
              Container(
                // container (h''/w'')
                decoration: BoxDecoration(
                  color: colormode_provider.secondContainer_Color,
                  border: Border.all(
                      color: colormode_provider.borders_Color, width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: h_second, // h''  => h' = h'' = 210
                width: w_second, // w'' = w' = w1 = 360
                child: Column(
                  children: [
                    // column of containers -> rows : (r1=zoom / r2=left-right / r3=up/down / r4=upload_btn / r5=print_btn)
                    // container 1 : contient ROW of ZOOM components
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      height: 2 * h_row + sB1_4, // h_col_row1
                      width: w1, // w_col_row1 = w1 = w' = w'' = 360
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // container 1 : color bar
                            Expanded(
                                child: Container(
                              // color bar
                              child: PaintingColorBar(
                                controller:
                                    controller, // use here the controller defined before
                                paintingColorBarMargin:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                colorsType: ColorsType.material,
                                onTap: (Color color) {
                                  // do your logic here with the pressed color, for example change the color of the brush
                                  print('tapped color: $color');
                                  controller.changeBrushColor(color);
                                },
                              ),
                            )),
                          ]),
                    ),
                    SizedBox(height: sB1_4), // SB1->4 = 10
                    // container 2 : contient ROW of up/down components
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      height: 2 * h_row + sB1_4, // h_col_row1
                      width: w1, // w_col_row1 = w1 = w' = w'' = 360
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // container 2 : icon 1 ( left )
                            Expanded(
                                child: Container(
                              child: Container(
                                height: 50, // height icon
                                width: 60, // width icon
                                child: IconButton(
                                    onPressed: () {
                                      print("return arrow clicked");
                                      controller.deleteLastLine();
                                    },
                                    icon: new Image.asset(
                                      "images/return_arrow.png",
                                    )),
                              ),
                            )),
                            // container 3 : icon 2 ( right )
                            Expanded(
                                child: Container(
                              child: Container(
                                height: 50, // height icon
                                width: 60, // width icon
                                child: IconButton(
                                    onPressed: () {
                                      print("trash clicked");
                                      controller.deletePainting();
                                    },
                                    icon: new Image.asset(
                                      "images/trash.png",
                                    )),
                              ),
                            )),
                          ]),
                    ),
                    SizedBox(height: sB1_4), // SB1->4 = 10
                    // SB1->4 = 10
                    // container 5 : contient ROW of print btn
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                            color: colormode_provider.borders_Color,
                            width: 1.0),
                      ),
                      margin: EdgeInsets.only(left: 10, right: 10),
                      height: h_row, // height btn print
                      width: w1 / 2, //width btn print
                      child: Center(
                          child: MaterialButton(
                        onPressed: () {
                          //print("print clicked"); // alert to comfirm printing process
                          AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.success,
                                  dialogBorderRadius:
                                      BorderRadius.circular(15.0),
                                  animType: AnimType.scale,
                                  title: 'CONFIRMATION',
                                  desc: 'Do you confirm to print ?',
                                  btnCancelOnPress: () {
                                    print("printing is canceled");
                                  },
                                  btnOkOnPress: () {
                                    print("printing is comfirmed");
                                  },
                                  btnOkIcon: Icons.check,
                                  btnCancelIcon: Icons.cancel)
                              .show();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                                'images/print.png'), // Replace with your desired icon
                            SizedBox(
                                width:
                                    12), // Adjust the spacing between icon and text
                            Text('Print'),
                          ],
                        ),
                      )),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
