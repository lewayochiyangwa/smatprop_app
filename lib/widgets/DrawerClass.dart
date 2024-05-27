
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smatprop/screens/Login/login_screen.dart';
import '../constants/global_constants.dart';

import '../screens/AllProperties.dart';
import '../screens/Signup/signup_screen.dart';
import 'CustomDevider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';





class DrawerClass extends StatefulWidget {
  DrawerClass({Key? key}) : super(key: key);

  @override
  State<DrawerClass> createState() => _DrawerClassState();
}

class _DrawerClassState extends State<DrawerClass> {
  late SharedPreferences logindata;
  late String email="";
  late String token="";
  late String proLink="";
  late String profilepicLink="";

  @override
  void initState() {
    super.initState();
    initial_state();
  }

  initial_state() async {




    logindata = await SharedPreferences.getInstance();
    setState(() {
    //  token=logindata.getString('token')!;
    //  email=logindata.getString('email')!;
      token = logindata.getString('token') ?? '';
      email = logindata.getString('email') ?? '';
      proLink = logindata.getString('proLink') ?? '';
    });
    print('kutoramba ka uku');
    print(proLink);

  }

  @override
  Widget build(BuildContext context) {
    return  Drawer(

      child: Container(
        color: ThemeColor,
        child: ListView(

          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color:ThemeColor,
              ),
              accountName: Text("test name", style: TextStyle(color: ThemeColor2)),
              accountEmail: Text(email, style: TextStyle(color: ThemeColor2)),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(proLink),
              ),
              /*  decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/basamaoko_logo.png"),
                  fit: BoxFit.fill,
                ),
              ),*/
            ),

            ListTile(
              leading: Icon(Icons.home),
              title: Text("Dashboard",style: TextStyle(color: ThemeColor2)),
              onTap: () {

              },
            ),//
            Divider(
              height: 30.0,
              thickness: 2.0,
              color: ThemeColor,
              indent: 20.0,
              endIndent: 20.0,),
          /*  ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text("test 1",style: TextStyle(color: ThemeColor2)),
              onTap: () {
              },
            ),
            Divider(
              height: 30.0,
              thickness: 2.0,
              color: ThemeColor,
              indent: 20.0,
              endIndent: 20.0,),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text("test 1",style: TextStyle(color: ThemeColor2)),
              onTap: () {

              },
            ),
            CustomDevider(
              height: 30.0,
              thickness: 2.0,
              color: ThemeColor,
              indent: 20.0,
              endIndent: 20.0,
            ),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text("AllProperties",style: TextStyle(color: ThemeColor2)),
              onTap: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllProperties()),// Settings()),
                );

              },
            ),
            CustomDevider(
              height: 30.0,
              thickness: 2.0,
              color: ThemeColor,
              indent: 20.0,
              endIndent: 20.0,
            ),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text("test 4",style: TextStyle(color:ThemeColor2),),
              onTap: () {
                /* Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NoteScreenTry()),// Settings()),NoteScreen
                );*/
              },
            ),

            CustomDevider(
              height: 30.0,
              thickness: 2.0,
              color: ThemeColor,
              indent: 20.0,
              endIndent: 20.0,
            ),*/
            ListTile(
              leading: Icon(Icons.logout,color: Colors.red,),
              title: logindata.getString('function_log_control')=="granted"?Text("Logout",style: TextStyle(color: Colors.red),):
              Text("Login",style: TextStyle(color: Colors.green),),
              onTap: () {
                logindata.setString("function_log_control","");

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );



              },
            ),

          ],
        ),
      ),
    );
  }
}
