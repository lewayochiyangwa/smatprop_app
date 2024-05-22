
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/global_constants.dart';

import '../screens/AllProperties.dart';
import 'CustomDevider.dart';





class DrawerClass extends StatefulWidget {
  DrawerClass({Key? key}) : super(key: key);

  @override
  State<DrawerClass> createState() => _DrawerClassState();
}

class _DrawerClassState extends State<DrawerClass> {

  @override
  void initState() {
    super.initState();


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
              accountEmail: Text("test email", style: TextStyle(color: ThemeColor2)),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/images/1024.png"),
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
            ListTile(
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
            ),
            ListTile(
              leading: Icon(Icons.logout,color: Colors.red,),
              title: Text("Logout",style: TextStyle(color: Colors.red),),
              onTap: () {


              },
            ),

          ],
        ),
      ),
    );
  }
}
