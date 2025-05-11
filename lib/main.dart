import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smatprop/screens/BottomNav.dart';
import 'package:smatprop/screens/splash/onbording.dart';
import 'package:smatprop/widgets/CollapsibleCard.dart';


void main() {


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home:Onbording(),//ExpandedTile(),//Onbording(),//BottomNavigationExample(),

    );
  }
}
