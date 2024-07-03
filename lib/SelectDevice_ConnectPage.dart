import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:testproject/Color_mode.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';

// ---------------------------------------------------------------------
// -----------    select device & connect page     --------------------
// ---------------------------------------------------------------------

class SelectConnectPage extends StatefulWidget {
  const SelectConnectPage({Key? key}) : super(key: key);
  State<SelectConnectPage> createState() => SelectConnectApp();
}

class SelectConnectApp extends State<SelectConnectPage> {
  // select wifi printer params
  final List<String> listWifi = [
    'Home',
    'MiniPrinter 1',
    'MiniPrinter 2',
  ];
  String? wifiselectedValue;
  // connected icon
  List<Map> connection_status_data = [
    {
      "name": "unconnected",
      "icon": Icons.wifi_off_rounded,
      "color": Color.fromRGBO(255, 68, 51, 100)
    },
    {
      "name": "connected",
      "icon": Icons.wifi_rounded,
      "color": Color.fromRGBO(80, 200, 120, 100)
    }
  ];

  // textfield password params
  TextEditingController passwordController = TextEditingController();
  bool obscureTextPassword = true; // password textfield (show/hide) param.
  bool visibilityPassword = false;

  void checkConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    print(result.name);
  }

  // switch mode params
  Color _textColor = Colors.black;
  Color _appBarColor = Color.fromRGBO(36, 41, 46, 1);
  Color _scaffoldBgcolor = Colors.white;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    var height_screen = MediaQuery.of(context).size.height;
    var width_screen = MediaQuery.of(context).size.width;
    var colormode_provider = Provider.of<ColorMode>(context);
    //return MaterialApp(
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              child: FlutterSwitch(
                width: 80.0,
                height: 35.0,
                toggleSize: 30.0,
                value: colormode_provider.mode,
                borderRadius: 30.0,
                padding: 2.0,
                activeToggleColor: Color(0xFF6E40C9),
                inactiveToggleColor: Color(0xFF2F363D),
                activeSwitchBorder: Border.all(
                  color: Color(0xFF3C1E70),
                  width: 6.0,
                ),
                inactiveSwitchBorder: Border.all(
                  color: Color(0xFFD1D5DA),
                  width: 6.0,
                ),
                activeColor: Color(0xFF271052),
                inactiveColor: Colors.white,
                activeIcon: Icon(
                  Icons.nightlight_round,
                  color: Color(0xFFF8E3A1),
                ),
                inactiveIcon: Icon(
                  Icons.wb_sunny,
                  color: Color(0xFFFFDF5D),
                ),
                onToggle: (newmodeSelected) {
                  setState(() {
                    colormode_provider.changeMode();
                    print("new mode selected = " +
                        colormode_provider.mode.toString());
                    if (newmodeSelected) {
                      _textColor = Colors.white;
                      _appBarColor = Color.fromRGBO(22, 27, 34, 1);
                      _scaffoldBgcolor = Color(0xFF0D1117);
                    } else {
                      _textColor = Colors.black;
                      _appBarColor = Color.fromRGBO(36, 41, 46, 1);
                      _scaffoldBgcolor = Colors.white;
                    }
                  });
                },
              ),
            ),
            SizedBox(width: 30),
            Container(
                child: Text("Select Printer",
                    style: TextStyle(color: Colors.white))),
            SizedBox(width: 30),
            Container(
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("qrcode_scan_route");
                    },
                    icon: Icon(Icons.qr_code_2)))
          ]),
          backgroundColor: colormode_provider.appBar_Color,
        ),
        backgroundColor: colormode_provider.screen_Color, // color of screen
        body: Column(
          children: [
            // col 1 => 1 row (connection state icon+text)
            Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(right: 20, top: 20),
              child: Container(
                height: 36,
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(
                        color: colormode_provider.texts_Color, width: 1)),
                child: StreamBuilder(
                    stream: Connectivity().onConnectivityChanged,
                    builder: (context, snapshot) {
                      if (snapshot.data == ConnectivityResult.wifi) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(connection_status_data[1]['icon'],
                                color: connection_status_data[1][
                                    'color']), // Replace with your desired icon
                            SizedBox(
                                width:
                                    10), // Adjust the spacing between icon and text
                            Text(connection_status_data[1]['name'],
                                style: TextStyle(
                                    color: colormode_provider.texts_Color)),
                          ],
                        );
                      } else {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(connection_status_data[0]['icon'],
                                color: connection_status_data[0][
                                    'color']), // Replace with your desired icon
                            SizedBox(
                                width:
                                    10), // Adjust the spacing between icon and text
                            Text(connection_status_data[0]['name'],
                                style: TextStyle(
                                    color: colormode_provider.texts_Color)),
                          ],
                        );
                      }
                    }),
              ),
            ),
            // col 2 'main interface'
            Center(
              child: Column(
                children: [
                  // container 1 (image printx)
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: height_screen / 5, // h = 130.0
                    width: width_screen,
                    child: Center(child: Image.asset('images/PRINTX_logo.png')),
                  ),
                  // container 2 (select printer wifi list)
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.all(50.0),
                    height: height_screen / 5,
                    width: width_screen,
                    child: Center(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            'Select Printer Wifi',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          items: listWifi
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.wifi_rounded,
                                            color: Colors
                                                .black), // Replace with your desired icon
                                        SizedBox(
                                            width:
                                                12), // Adjust the spacing between icon and text
                                        Text(item,
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ],
                                    ),
                                  ))
                              .toList(),
                          value: wifiselectedValue,
                          onChanged: (String? value) {
                            setState(() {
                              wifiselectedValue = value;
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            decoration: BoxDecoration(
                                color: colormode_provider.secondContainer_Color,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: Colors
                                      .black, // Set your border color here
                                  width: 1.0, // Set the border width here
                                )),
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: height_screen / 12,
                            width: width_screen,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // container 3 (textfiled of printer wifi password)
                  Container(
                    //margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.all(50.0),
                    height: height_screen / 5,
                    width: width_screen,
                    child: Center(
                        child: TextField(
                            style: TextStyle(
                                color: colormode_provider.texts_Color),
                            controller: passwordController,
                            obscureText:
                                obscureTextPassword, // Set to true to obscure the text (password type)
                            decoration: InputDecoration(
                                focusColor:
                                    colormode_provider.secondContainer_Color,
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color:
                                      colormode_provider.secondContainer_Color,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    // you have to setState(visibilityPassword variable) here
                                    setState(() {
                                      obscureTextPassword =
                                          !obscureTextPassword;
                                      visibilityPassword = !visibilityPassword;
                                    });
                                    print("visibility password = " +
                                        visibilityPassword.toString());
                                  },
                                  icon: Icon(
                                    visibilityPassword
                                        ? Icons.visibility
                                        : Icons
                                            .visibility_off, // Conditionally set the icon
                                    color: colormode_provider
                                        .secondContainer_Color,
                                  ),
                                ),
                                hintText: "Enter Password ...",
                                hintStyle: TextStyle(fontSize: 14.0),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: colormode_provider
                                            .secondContainer_Color,
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(
                                        10)), // standard border
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: colormode_provider
                                          .secondContainer_Color,
                                    ),
                                    borderRadius: BorderRadius.circular(30))))),
                  ),
                  // container 4 ( button ) get all data 'username/psw/gender/rating'
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: height_screen / 12,
                    width: width_screen / 2, // width = 300 is too much for btn
                    padding:
                        EdgeInsets.all(10.0), // space between btn and container
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colormode_provider.secondContainer_Color,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.black, width: 1.0),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          print("**************** DATA *********************");
                          print("selected wifi = " +
                              wifiselectedValue.toString() +
                              " / password = " +
                              passwordController.text.toString());
                          // verif data
                          if (passwordController.text.toString() != "1234") {
                            //alert => wrong password .
                            AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    dialogBorderRadius:
                                        BorderRadius.circular(15.0),
                                    animType: AnimType.scale,
                                    title: 'ERROR',
                                    desc:
                                        'Wrong wifi password ! Please , re-try again',
                                    //btnCancelOnPress: () {},
                                    btnOkOnPress: () {},
                                    //btnOkIcon: Icons.check,
                                    btnCancelIcon: Icons.cancel)
                                .show();
                          } else {
                            // go to next page (menu interface) .
                            Navigator.of(context).pushNamed("menu_route");
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                                'images/valid.png'), // Replace with your desired icon
                            SizedBox(
                                width:
                                    12), // Adjust the spacing between icon and text
                            Text('Connect'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
    //);
  }
}
