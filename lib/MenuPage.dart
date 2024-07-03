import 'package:flutter/material.dart';
import 'package:testproject/Color_mode.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height_screen = MediaQuery.of(context).size.height;
    var width_screen = MediaQuery.of(context).size.width;
    var colormode_provider = Provider.of<ColorMode>(context);
    //return MaterialApp(
    return Scaffold(
      appBar: AppBar(
        title: Container(
            margin: EdgeInsets.only(left: width_screen / 6),
            child:
                const Text("Menu Page", style: TextStyle(color: Colors.white))),
        backgroundColor: colormode_provider.appBar_Color,
      ),
      backgroundColor: colormode_provider.screen_Color,
      body: Center(
          child: Container(
              margin: EdgeInsets.only(
                  top: height_screen / 6, left: height_screen / 42),
              height: height_screen,
              width: width_screen,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
              alignment: Alignment.center,
              child: Column(
                children: [
                  // row 1 (icon 1 'upload' + icon 2 'gallery')
                  Row(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: colormode_provider.secondContainer_Color,
                              border: Border.all(
                                  color:
                                      colormode_provider.secondContainer_Color,
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(30)),
                          height: height_screen / 4.5,
                          width: width_screen / 2.5,
                          child: Center(
                              child: Column(
                            children: [
                              Container(
                                height: height_screen / 8,
                                width: width_screen / 2,
                                margin:
                                    EdgeInsets.only(top: height_screen / 30),
                                child: IconButton(
                                    onPressed: () {
                                      print("click icon 1 'upload'");
                                      Navigator.of(context)
                                          .pushNamed("uploadImage_route");
                                    },
                                    icon: new Image.asset(
                                      "images/upload_image.png",
                                    )),
                              ),
                              SizedBox(height: height_screen / 90), // 10
                              Container(
                                  child: Center(child: Text("Upload Image"))),
                            ],
                          ))),
                      SizedBox(width: height_screen / 21),
                      Container(
                          decoration: BoxDecoration(
                              color: colormode_provider.secondContainer_Color,
                              border: Border.all(
                                  color:
                                      colormode_provider.secondContainer_Color,
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(30)),
                          height: height_screen / 4.5,
                          width: width_screen / 2.5,
                          child: Center(
                              child: Column(
                            children: [
                              Container(
                                height: height_screen / 8,
                                width: width_screen / 2,
                                margin:
                                    EdgeInsets.only(top: height_screen / 24),
                                child: IconButton(
                                    onPressed: () {
                                      print("click icon 2 'gallery'");
                                      Navigator.of(context)
                                          .pushNamed("gallery_route");
                                    },
                                    icon: new Image.asset(
                                      "images/gallery.png",
                                    )),
                              ),
                              Container(child: Center(child: Text("Gallery"))),
                            ],
                          ))),
                    ],
                  ),
                  SizedBox(height: width_screen / 8),
                  // row 2 (icon 3 + icon 4)
                  Row(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: colormode_provider.secondContainer_Color,
                              border: Border.all(
                                  color:
                                      colormode_provider.secondContainer_Color,
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(30)),
                          height: height_screen / 4.5,
                          width: width_screen / 2.5,
                          child: Center(
                              child: Column(
                            children: [
                              Container(
                                height: height_screen / 8,
                                width: width_screen / 2,
                                margin:
                                    EdgeInsets.only(top: height_screen / 40),
                                child: IconButton(
                                    onPressed: () {
                                      print("click icon 3");
                                      Navigator.of(context)
                                          .pushNamed("addText_route");
                                    },
                                    icon: new Image.asset(
                                      "images/addText.png",
                                    )),
                              ),
                              SizedBox(height: height_screen / 60),
                              Container(child: Center(child: Text("Add Text"))),
                            ],
                          ))),
                      SizedBox(width: width_screen / 10),
                      Container(
                          decoration: BoxDecoration(
                              color: colormode_provider.secondContainer_Color,
                              border: Border.all(
                                  color:
                                      colormode_provider.secondContainer_Color,
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(30)),
                          height: height_screen / 4.5,
                          width: width_screen / 2.5,
                          child: Center(
                              child: Column(
                            children: [
                              Container(
                                height: height_screen / 8,
                                width: width_screen / 2,
                                margin:
                                    EdgeInsets.only(top: height_screen / 40),
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed("handDraw_route");
                                    },
                                    icon: new Image.asset(
                                      "images/hand_draw.png",
                                    )),
                              ),
                              SizedBox(height: height_screen / 60),
                              Container(
                                  child: Center(child: Text("Free Hand Draw"))),
                            ],
                          ))),
                    ],
                  ),
                ],
              ))),
    );
  }
}
