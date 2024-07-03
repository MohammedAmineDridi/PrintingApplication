import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

class ColorMode extends ChangeNotifier {
  bool mode = false; // default = false = (light mode)
  // colors
  Color appBar_Color = Color.fromRGBO(60, 168, 110, 0.612);
  Color screen_Color = Color.fromRGBO(255, 255, 255, 50.0);
  Color mainContainer_Color = Colors.white;
  Color secondContainer_Color = Color.fromRGBO(60, 168, 110, 0.612);
  Color texts_Color = Colors.black;
  Color borders_Color = Colors.black;
  // set mode
  changeMode() {
    mode = !mode;
    print("mode devient = " + mode.toString());
    if (mode == false) {
      appBar_Color = Color.fromRGBO(60, 168, 110, 0.612);
      screen_Color = Color.fromRGBO(255, 255, 255, 50.0);
      mainContainer_Color = Colors.white;
      secondContainer_Color = Color.fromRGBO(60, 168, 110, 0.612);
      texts_Color = Colors.black;
      borders_Color = Colors.black;
    } else {
      // mode = true (dark mode)
      appBar_Color = Color.fromRGBO(197, 194, 19, 0.808); // yellow
      screen_Color = Color.fromRGBO(86, 79, 164, 0.357); // dark blue
      mainContainer_Color = Colors.white;
      secondContainer_Color = Color.fromRGBO(197, 194, 19, 0.808); // yellow
      texts_Color = Colors.white;
      borders_Color = Colors.black;
    }
    notifyListeners(); // notification for all widgets
  }
}
