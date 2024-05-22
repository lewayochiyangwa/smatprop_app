

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smatprop/screens/dashboard/tables/recent_file.dart';
import '../../constants/global_constants.dart';
import '../../widgets/CustomButtton.dart';
import '../TopProperties.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
 // final database = MetersDatabase();

  late SharedPreferences logindata;
  late SharedPreferences logindata2;
  late int userId;




  @override
  void initState() {
    super.initState();
    initial_state();

  }

 // late VideoPlayerController _controller;


  initial_state() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      userId=logindata.getInt('id')!;
      //clientID=logindata.getString('clientID')!;
    });
  }




  @override
  Widget build(BuildContext context) {
   // final params_controller =  Get.put<ParamsController>(ParamsController());


    return Scaffold(
     // backgroundColor: Colors.grey.shade900,
      body:  Container(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(0.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                        /*  Container(
                          margin: const EdgeInsets.all(8.0),
                          //padding: const EdgeInsets.all(10.0),
                            height: 100,
                            width:500,
                           // color: ThemeColor,
                            child:HomeWorkBanner(
                              color: ThemeColor,
                              title: "Home Work",
                              value: "10",
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height/4,
                            ),
                          ),*/
                      //    SizedBox(height:5),

                          Container(
                          //  color: Colors.grey.shade200,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30.0,right: 30.0),
                              child: Row(
                                children: [
                                  CustomButton(
                                    onPressed:() async {

                                      logindata = await SharedPreferences.getInstance();
                                      print("this is the bool for login");
                                      print(logindata.getBool('login'));
                                      if(logindata.getBool('login')!){


                                        //  print("hmm andisi kuziva");
                                      }else{


                                      }

                                    },
                                    text: "Rental Pay", color:ThemeColor,
                                    textColor:ThemeColor2,
                                    width:MediaQuery.of(context).size.width/2.5,
                                    height: 30,

                                  ),
                                Spacer(),
                                  CustomButton(
                                    onPressed:() async {

                                      logindata = await SharedPreferences.getInstance();
                                      print("this is the bool for login");
                                      print(logindata.getBool('login'));
                                      if(logindata.getBool('login')!){

                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Message'),
                                                content: Text("Login To Submit Prayer Request"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('OK'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            }
                                        );
                                        //  print("hmm andisi kuziva");
                                      }else{


                                      }

                                    },
                                    text: "Log Issue", color:ThemeColor,
                                    textColor:ThemeColor2,
                                    width: MediaQuery.of(context).size.width/2.5,
                                    height: 30,

                                  ),
                              ],),
                            ),
                          ),
                          SizedBox(height:12),
                          Text("Top 5 List Properties",style: TextStyle(fontSize:14,fontWeight: FontWeight.bold),),
                          MySlider3(),
                       //   Text("My Property Applications",style: TextStyle(fontSize:14,fontWeight: FontWeight.bold),),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),

                            ),
                            width: MediaQuery.of(context).size.width * 0.95,
                            child: RecentFiles(),
                          ),


                        ],
                      ),
                    ),

                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }













}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 24,
          child: Icon(Icons.check),
        ),
        SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            color: Colors.grey,
            value: 1,
          ),
        ),
        SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            color: Colors.blue,
            value: .3, // Change this value to update the progress
          ),
        ),
      ],
    );
  }
}