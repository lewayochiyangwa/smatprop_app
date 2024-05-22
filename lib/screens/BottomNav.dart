import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/global_constants.dart';
import '../widgets/DrawerClass.dart';
import 'Settings.dart';
import 'dashboard/Dashboard.dart';




class BottomNavigationExample extends StatefulWidget {
  const BottomNavigationExample({Key? key}) : super(key: key);

  @override
  _BottomNavigationExampleState createState() =>
      _BottomNavigationExampleState();
}

class _BottomNavigationExampleState extends State {
  int _selectedTab = 0;

  List _pages = [
    Dashboard(),
    Dashboard(),
    Dashboard(),
    Settings(),



  ];

  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }


@override
 initState() {
    // TODO: implement initState
  userfunction_log_control();
    super.initState();
  }

 void userfunction_log_control() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    logindata.getString("function_log_control");
    print("this is it the null we want"+logindata.getString("function_log_control").toString());
}
  // Default language selection
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.white,//ThemeColor ,//Colors.red.shade900
        iconTheme: IconThemeData(color:ThemeColor2),
        //

          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                ],
              ),
            )
          ],
        title:Image.asset('assets/images/logo.png',width: 70,height: 70,),
      ),
     /** appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),*/
      drawer: DrawerClass(),
      body: _pages[_selectedTab],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Fixed
        backgroundColor: ThemeColor, // <-- This works for fixed
        currentIndex: _selectedTab,
        onTap: (index) => _changeTab(index),
        selectedItemColor:ThemeColor2,
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: "Available"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle,), label: "Payments"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
          /*BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Extras"),*/
        ],
      ),
    );
  }
}