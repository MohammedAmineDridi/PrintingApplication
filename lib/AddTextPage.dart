import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';
import "package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart";
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:testproject/Color_mode.dart';
import 'package:provider/provider.dart';

class AddTextPage extends StatefulWidget {
  const AddTextPage({Key? key}) : super(key: key);
  State<AddTextPage> createState() => AddTextApp();
}

class AddTextApp extends State<AddTextPage> {
  // -------- params add text
  // textfield 'main container'
  double height_all_container = 460;
  double width_all_container = 460;
  // textfield txt controller
  TextEditingController textController = TextEditingController();
  // dynamic values
  double zoomValue = 0;
  double fontSizeValue = 30; // intialement 'font size' = 10
  FontWeight? fontWeightValue = FontWeight.normal; // init 'font weight' = w100
  String? fontFamilyValue = "Arial";
  Color colorPickerTextValue = Colors.black; // init color = black
  final colorNotifier = ValueNotifier<Color>(Colors.black); // init color
  final List<FontWeight> listFontWeights = [FontWeight.normal, FontWeight.bold];

  List<String> listFontFamily = [
    "Arial",
    "BrushScript",
    "SnellRoundhand",
    "Impact",
    "Lunarir",
    "Blippo",
    "Stencil",
    "MarkerFat",
  ];

  // pick color alert dialog function
  void showAlertDialog_pickTextColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Return the dialog
        return AlertDialog(
          title: Center(
              child: Text('Choose Text Color',
                  style: TextStyle(color: Colors.white))),
          content: Container(
            height: height_all_container,
            width: width_all_container,
            child: SingleChildScrollView(
              child: ValueListenableBuilder<Color>(
                valueListenable: colorNotifier,
                builder: (_, color, __) {
                  return ColorPicker(
                      initialPicker: Picker.paletteHue,
                      color: color,
                      onChanged: (newPickedColor) => {
                            setState(() {
                              colorPickerTextValue = newPickedColor;
                              print("new picked color = " +
                                  newPickedColor.toString());
                            })
                          });
                },
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  // -- vars dynamics --
  double m3 = 10;
  double h_img = 100; // h_img
  double w_img = 100; // w_img
  double m2 = 5;
  double sB0 = 40;
  double sB1_4 = 15;
  double h1 = 540; // h1 (460)
  double w1 = 460; // w1 (360)
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
    super.initState();
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var colormode_provider = Provider.of<ColorMode>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Container(
            margin: EdgeInsets.only(right: 60),
            child: Center(child: Text("Add Text Page"))),
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
              Container(
                color: Colors.white,
                height: h_prim, // h'
                width: w_prim, // w'= w1 = 360
                child: TextField(
                  style: TextStyle(
                      fontFamily: fontFamilyValue,
                      fontSize: fontSizeValue,
                      fontWeight: fontWeightValue,
                      color: colorPickerTextValue),
                  controller: textController,
                  maxLines: 5, // Allows for an unlimited number of lines

                  inputFormatters: [
                    LengthLimitingTextInputFormatter(
                        30), // Set the desired maximum characters per line = 30
                    FilteringTextInputFormatter.deny('\n'), // Prevents newlines
                  ],
                  // so max => 5 lines // 1 line => max 30 caracters

                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Colors.transparent), // Set color to transparent
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Colors.transparent), // Set color to transparent
                    ),
                    focusColor: colormode_provider.secondContainer_Color,
                    hintText: "Enter your Text ...",
                    hintStyle: TextStyle(fontSize: 14.0),
                  ),
                ),
              ),
              // space between 2 main containers (SB0 = 40)
              SizedBox(height: sB0), // SB0 = 40
              Container(
                // container (h''/w'')
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: colormode_provider.secondContainer_Color,
                  border: Border.all(
                      color: colormode_provider.borders_Color, width: 0.5),
                ),
                height: h_second, // h''  => h' = h'' = 210
                width: w_second, // w'' = w' = w1 = 360
                child: Column(
                  children: [
                    // column of containers -> rows : (r1=zoom / r2=left-right / r3=up/down / r4=upload_btn / r5=print_btn)
                    // container 1 : contient ROW of ZOOM components
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      height: h_row, // h_col_row1
                      width: w1, // w_col_row1 = w1 = w' = w'' = 360
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // container 1 : text 'Font Family'
                            Expanded(
                                child: Container(
                              child: Text("Font Family",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            )),
                            // container 2 : select tag font family
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  isExpanded: true,
                                  hint: Text(
                                    'Font Family',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  items: listFontFamily
                                      .map((String item) =>
                                          DropdownMenuItem<String>(
                                            value: item,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                    item.length > 11
                                                        ? item.substring(0, 12)
                                                        : item,
                                                    style: TextStyle(
                                                        fontFamily: item,
                                                        fontSize: 14.0)),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                  value: fontFamilyValue,
                                  onChanged: (String? newfontFamilyValue) {
                                    setState(() {
                                      fontFamilyValue = newfontFamilyValue;
                                    });
                                    print("new font family selected = " +
                                        fontFamilyValue.toString());
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    decoration: BoxDecoration(
                                        color: colormode_provider
                                            .secondContainer_Color,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                          color: colormode_provider
                                              .borders_Color, // Set your border color here
                                          width:
                                              1.0, // Set the border width here
                                        )),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    height: 50,
                                    width: 300,
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ),
                    SizedBox(height: sB1_4), // SB1->4 = 10
                    // container 2 : contient ROW of left/right components
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      height: h_row, // h_col_row1
                      width: w1, // w_col_row1 = w1 = w' = w'' = 360
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // container 1 : text 'Font size'
                            Expanded(
                                child: Container(
                              child: Text("Font Size",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            )),
                            // container 2 : slider font size
                            Expanded(
                              child: Slider(
                                thumbColor: colormode_provider.borders_Color,
                                activeColor: colormode_provider.borders_Color,
                                min: 0,
                                max: 100,
                                value: fontSizeValue,
                                onChanged: (newfontSizeValue) {
                                  setState(() {
                                    fontSizeValue = newfontSizeValue;
                                  });
                                  print("new font size selected = " +
                                      fontSizeValue.toString());
                                },
                                //divisions: 10, // division of slider
                                label: fontSizeValue.round().toString(),
                              ),
                            ),
                          ]),
                    ),
                    SizedBox(height: sB1_4), // SB1->4 = 10
                    // container 3 : contient ROW of up/down components
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      height: h_row, // h_col_row1
                      width: w1, // w_col_row1 = w1 = w' = w'' = 360
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // container 1 : text 'Font Weight'
                            Expanded(
                                child: Container(
                              child: Text("Font Weight",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            )),
                            // container 2 : select tag font weight
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<FontWeight>(
                                  isExpanded: true,
                                  hint: Text(
                                    'Font Weight',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  items: listFontWeights
                                      .map((FontWeight item) =>
                                          DropdownMenuItem<FontWeight>(
                                            value: item,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                item.toString().substring(11) ==
                                                        "w400"
                                                    ? Text("normal")
                                                    : Text("bold"),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                  value: fontWeightValue,
                                  onChanged: (FontWeight? value) {
                                    setState(() {
                                      fontWeightValue = value;
                                    });
                                    print("new font weight value = " +
                                        fontWeightValue.toString());
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    decoration: BoxDecoration(
                                        color: colormode_provider
                                            .secondContainer_Color,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                          color: colormode_provider
                                              .borders_Color, // Set your border color here
                                          width:
                                              1.0, // Set the border width here
                                        )),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    height: 50,
                                    width: 300,
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ),
                    SizedBox(height: sB1_4), // SB1->4 = 10
                    // container 4 : contient ROW of upload btn
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      height: h_row, // h_col_row1
                      width: w1, // w_col_row1 = w1 = w' = w'' = 360
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // container 1 : text 'Color picker'
                            Expanded(
                                child: Container(
                              child: Text("Color",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            )),
                            // container 2 : select tag font weight
                            Expanded(
                              child: MaterialButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.circle,
                                        color: colorPickerTextValue),
                                    SizedBox(width: 10),
                                    Text("Text Color")
                                  ],
                                ),
                                onPressed: () {
                                  // dialog to choose color (color picker)
                                  showAlertDialog_pickTextColor(context);
                                },
                              ),
                            ),
                          ]),
                    ),
                    SizedBox(height: sB1_4),
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
