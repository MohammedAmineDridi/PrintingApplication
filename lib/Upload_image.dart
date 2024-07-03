import 'dart:math';
import 'package:testproject/SQLite_Lib.dart';
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

class UploadImagePage extends StatefulWidget {
  const UploadImagePage({Key? key}) : super(key: key);
  State<UploadImagePage> createState() => UploadImageApp();
}

class UploadImageApp extends State<UploadImagePage> {
  // images params
  double current_x_offset_value = 0;
  double current_y_offset_value = 0;
  // image picker img_file & img_path
  XFile? img_File;
  String img_path = '';
  // icon favorites
  IconData iconFavorites = Icons.star_border;
  // -- vars dynamics --
  double m3 = 10;
  double h_img = 100; // h_img
  double w_img = 100; // w_img = h_img
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
  // database instance
  DataBase_SQLite sqlite = DataBase_SQLite();
  Future<List<Map>>? Number_Images_Gallery;
  int maxNbrImages = 5;
  int nbrImages = 0;

  @override
  void initState() {
    Number_Images_Gallery = sqlite.API_GetNumberImages("images");

    print("*********** nbr of img in gallery **************");
    Number_Images_Gallery!.then((count) => {
          setState(() {
            nbrImages = count[0]['count(*)'];
          })
        });
    print("nbr of images in gallery = " + nbrImages.toString());
    print("************************************************");
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
    // close database
    //sqlite.closeDatabase();
  }

  @override
  Widget build(BuildContext context) {
    var colormode_provider = Provider.of<ColorMode>(context);
    return Scaffold(
      appBar: AppBar(
        title: Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: const Text("Upload Image Page")),
            SizedBox(width: 10),
            IconButton(
                onPressed: () {
                  if (iconFavorites == Icons.star_border) {
                    print("click icon add to favorites");
                    AwesomeDialog(
                            context: context,
                            dialogType: DialogType.info,
                            dialogBorderRadius: BorderRadius.circular(15.0),
                            animType: AnimType.scale,
                            title: 'CONFIRM',
                            desc:
                                'Are you sure to save this image to gallery ?',
                            btnCancelOnPress: () {
                              print("Image not saved");
                            },
                            btnOkOnPress: () {
                              print("image saved in gallery");
                              setState(() {
                                if (img_path != "") {
                                  // save image path in 'images(id,imagePath)' in galler.db
                                  if (nbrImages < maxNbrImages) {
                                    // max nbr = 5
                                    sqlite.API_Insert(
                                        "images", "imagePath", img_path);
                                    iconFavorites = Icons.star;
                                  } else {
                                    print(
                                        "ERROR : max nbr of images in gallery must < 5");
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      dialogBorderRadius:
                                          BorderRadius.circular(15.0),
                                      animType: AnimType.scale,
                                      title: 'ERROR',
                                      desc: 'Error ! Max number of gallery images is ' +
                                          maxNbrImages.toString() +
                                          ", if you want to add this image , please delete 1 image in gallery page !",
                                    ).show();
                                  }
                                } else {
                                  // show dialog 'choose your image first'
                                } // add img_path to database
                              });
                            },
                            btnOkIcon: Icons.check,
                            btnCancelIcon: Icons.cancel)
                        .show();
                  } else {
                    // image is already in favorites
                    print("Image is already in gallery !!");
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      dialogBorderRadius: BorderRadius.circular(15.0),
                      animType: AnimType.scale,
                      title: 'INFO',
                      desc:
                          'This image is already in gallery ! , you can remove it from gallery page',
                    ).show();
                  }
                },
                icon: Icon(iconFavorites,
                    color: const Color.fromARGB(255, 6, 96, 137))),
          ],
        )),
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
                width: w_prim, // w'= w1 = 360
                child: Center(
                    // image small container (h_img/w_img)
                    child: Container(
                  height: h_img, // h_img
                  width: h_img, // h_img = w_img
                  child: Center(
                    child: Transform.translate(
                        offset: Offset(
                            current_x_offset_value, current_y_offset_value),
                        child: img_path == ''
                            ? const SizedBox(height: 20.0)
                            : Image(image: FileImage(File(img_path)))),

                    // end here
                  ),
                )),
              ),
              // space between 2 main containers (SB0 = 40)
              SizedBox(height: sB0), // SB0 = 40
              Container(
                decoration: BoxDecoration(
                  color: colormode_provider.secondContainer_Color,
                  border: Border.all(
                      color: colormode_provider.borders_Color, width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                // container (h''/w'')
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
                            // container 1 : text 'Zoom'
                            Expanded(
                                child: Container(
                              child: Text("Zoom",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            )),
                            // container 2 : icon 1 (zoom +)
                            Expanded(
                                child: Container(
                              // icon (zoom+) in container
                              child: Container(
                                height: 50, // height icon
                                width: 60, // width icon
                                child: InkWell(
                                  child: IconButton(
                                    icon: new Image.asset("images/zoom_in.png"),
                                    onPressed: () {
                                      double scale_max =
                                          (h_prim / 2) - (h_img / 2);
                                      print('click zoom in');
                                      setState(() {
                                        if (scale_max > 0) {
                                          h_img +=
                                              (((h_prim / 2) - (w_img / 2)) /
                                                  5); // 10 fois zoom
                                          print("max scale devient = " +
                                              scale_max.toString());
                                        } else {
                                          print("no more scaling !");
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                            )),
                            // container 3 : icon 2 (zoom -)
                            Expanded(
                                child: Container(
                              child: Container(
                                height: 50, // height icon
                                width: 60, // width icon
                                child: InkWell(
                                  onLongPress: () {
                                    // Handle long press
                                    print('Long Press zoom out');
                                  },
                                  child: IconButton(
                                    icon:
                                        new Image.asset("images/zoom_out.png"),
                                    onPressed: () {
                                      // Handle normal press
                                      print('Short Press zoom out');
                                      setState(() {
                                        h_img -= 10;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            )),
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
                            // container 1 : text 'X translation'
                            Expanded(
                                child: Container(
                              child: Text("X Translation",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            )),
                            // container 2 : icon 1 ( left )
                            Expanded(
                                child: Container(
                              child: Container(
                                height: 50, // height icon
                                width: 60, // width icon
                                child: InkWell(
                                  child: IconButton(
                                    icon: new Image.asset(
                                        "images/left_arrow.png"),
                                    onPressed: () {
                                      // Handle normal press
                                      print('click left arrow');
                                      setState(() {
                                        current_x_offset_value -= 10;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            )),
                            // container 3 : icon 2 ( right )
                            Expanded(
                                child: Container(
                              child: Container(
                                height: 50, // height icon
                                width: 60, // width icon
                                child: InkWell(
                                  onLongPress: () {
                                    // Handle long press
                                    print('Long Press right arrow');
                                  },
                                  child: IconButton(
                                    icon: new Image.asset(
                                        "images/right_arrow.png"),
                                    onPressed: () {
                                      // Handle normal press
                                      print('Short Press right arrow');
                                      setState(() {
                                        current_x_offset_value += 10;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            )),
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
                            // container 1 : text 'X translation'
                            Expanded(
                                child: Container(
                              child: Text("Y Translation",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            )),
                            // container 2 : icon 1 ( left )
                            Expanded(
                                child: Container(
                              child: Container(
                                height: 50, // height icon
                                width: 60, // width icon
                                child: InkWell(
                                  onLongPress: () {
                                    // Handle long press
                                    print('Long Press down arrow');
                                  },
                                  child: IconButton(
                                    icon: new Image.asset(
                                        "images/down_arrow.png"),
                                    onPressed: () {
                                      // Handle normal press
                                      print('Short Press down arrow');
                                      setState(() {
                                        current_y_offset_value += 10;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            )),
                            // container 3 : icon 2 ( right )
                            Expanded(
                                child: Container(
                              child: Container(
                                height: 50, // height icon
                                width: 60, // width icon
                                child: InkWell(
                                  onLongPress: () {
                                    // Handle long press
                                    print('Long Press up arrow');
                                  },
                                  child: IconButton(
                                    icon:
                                        new Image.asset("images/up_arrow.png"),
                                    onPressed: () {
                                      // Handle normal press
                                      print('Short Press up arrow');
                                      setState(() {
                                        current_y_offset_value -= 10;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            )),
                          ]),
                    ),
                    SizedBox(height: sB1_4), // SB1->4 = 10
                    // container 4 : contient ROW of upload btn
                    Container(
                      // container (btn decoration 'border')
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: colormode_provider.borders_Color,
                            width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin: EdgeInsets.only(left: 10, right: 10),
                      height: h_row, // height btn upload
                      width: w1 / 3, // width btn upload
                      child: Center(
                          child: MaterialButton(
                              child: Center(
                                  child: Text("Upload Image",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              onPressed: () async {
                                // select image and show
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(
                                    source: ImageSource.gallery);
                                setState(() {
                                  try {
                                    img_File = image;
                                    img_path = image!.path;
                                    print("---- image path = " + image!.path);
                                  } catch (e) {
                                    print("upload error");
                                  }
                                });
                              })),
                    ),
                    SizedBox(height: sB1_4), // SB1->4 = 10
                    // container 5 : contient ROW of print btn
                    Container(
                      decoration: BoxDecoration(
                        color: colormode_provider.secondContainer_Color,
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
                            Text('Print',
                                style: TextStyle(fontWeight: FontWeight.bold)),
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
