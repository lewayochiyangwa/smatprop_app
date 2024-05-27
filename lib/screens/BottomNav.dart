import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smatprop/screens/payments.dart';

import '../constants/global_constants.dart';
import '../widgets/DrawerClass.dart';
import 'AllProperties.dart';
import 'Payments2.dart';
import 'Settings.dart';
import 'dashboard/Dashboard.dart';
import 'package:http/http.dart' as http;

import 'dashboard/dashboard_screen.dart';



class BottomNavigationExample extends StatefulWidget {
  const BottomNavigationExample({Key? key}) : super(key: key);

  @override
  _BottomNavigationExampleState createState() =>
      _BottomNavigationExampleState();
}

class _BottomNavigationExampleState extends State {
  int _selectedTab = 0;
  late SharedPreferences logindata;
  late String role="";
  List _pages = [
    Dashboard(),
    AllProperties(),
    Payments2(),// Payments(),
    Settings(),
  ];



  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  // List of available languages
  final List<String> languages = ['English', 'Spanish', 'French', 'German'];

  Map<String, String> myMap = {
    'en': 'US',
    'sn': 'ZW',
  };
  Map<String, String> languageMap = {
    'en': 'English',
    'sn': 'Shona'

  };


@override
 initState() {
    // TODO: implement initState
  userfunction_log_control();
    super.initState();
  initial_state();

  }

  initial_state() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      role = logindata.getString('role') ?? '';

       _pages = [
        role=="ADMIN"?DashboardScreen():Dashboard(),
        AllProperties(),
        Payments2(),// Payments(),
        Settings(),
      ];
    });
  }

  void tryIt()async{
    final uploadUrl = Uri.parse('http://localhost:93/basamaoko_api/api/client/upload.php'); // Replace with the URL where you want to send the file and JSON data

// Set the file path and name
    final filePath = '/path/to/file.jpg'; // Replace with the actual file path
    final fileName = 'file.jpg'; // Replace with the desired file name

// Set the JSON data
    final jsonData = {'name': 'lee'};

// Create a multipart request
    final request = http.MultipartRequest('POST', uploadUrl);

// Add the file to the request
    request.files.add(await http.MultipartFile.fromPath('file', filePath, filename: fileName));

// Add the JSON data to the request
    request.fields.addAll(jsonData);

// Send the request and get the response
    final response = await request.send();

// Print the response
    if (response.statusCode == 200) {
      print('Response: ${await response.stream.bytesToString()}');
    } else {
      print('Error: ${response.reasonPhrase}');
    }



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

                Text('Privacy'),
                SizedBox(width: 15,),
                InkWell(
                  child: Icon(Icons.help_outline),
                  onTap:(){

                  /*  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FaqPage()),// Settings()),
                    );*/
                  },
                ),
                PopupMenuButton<String>(
                  onSelected: (String result) {
                    setState(() {
                      var locale;
                      selectedLanguage = result;
                      print("is this"+selectedLanguage.toString());
                      if(selectedLanguage.toString()=="en")
                        locale  = Locale('en','US');

                      /* if(selectedLanguage.toString()=="hi")
                           locale = Locale('hi','IN');*/

                      if(selectedLanguage.toString()=="sn")
                        locale = Locale('sn','ZW');
                      Get.updateLocale(locale);
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return languageMap.keys.map((String key) {
                      return PopupMenuItem<String>(
                        value: key,
                        child: Text(languageMap[key]!),
                      );
                    }).toList();
                  },
                ),
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