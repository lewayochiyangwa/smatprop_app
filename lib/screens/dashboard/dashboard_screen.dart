
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/global_constants.dart';
import '../Login/responsive.dart';
import 'dash_widgets/file_info_card.dart';
import 'dash_widgets/myfile.dart';
import 'dash_widgets/starage_details.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:intl/intl.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  late SharedPreferences logindata;
  late String clientID;
  String trx_empty="";

late String total_registrations="";
  late String total_payments="";
  late String email="";
  late String token="";
  @override
  void initState() {
    super.initState();
    initial_state();
    _getTotalreg();
    _getTotalPayments();
  }
  initial_state() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      //  token=logindata.getString('token')!;
      //  email=logindata.getString('email')!;
      token = logindata.getString('token') ?? '';
      email = logindata.getString('email') ?? '';
    });
  }

  Future<void> _getTotalreg() async {

    logindata = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.parse(ip_address3+'api/v1/admin/get_registrations'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print("takupinda mu table viewing===AllProperties.dart");
      setState(() {
        total_registrations = response.body;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
  Future<void> _getTotalPayments() async {

    logindata = await SharedPreferences.getInstance();
    print("total payments before get");
    final response = await http.get(
      Uri.parse(ip_address3+'api/v1/admin/get_payments'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    print("total payments after get");
    print(response.body);
    if (response.statusCode == 200) {
      print("takupinda mu table viewing===AllProperties.dart");
      setState(() {
        total_payments = response.body;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:  Container(
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                //Header(),
                // SizedBox(height: defaultPadding),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                        Container(
                          height: 100,
                          width: 150,
                          child: Card(
                          elevation: 1.0,
                         /* shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: Colors.blue.shade100,
                              width: 2.0,
                            ),
                          ),*/
                          color:Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(defaultPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Registrations',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(height: defaultPadding),
                                Flexible(
                                  child: ProgressLine(
                                    color: Colors.green,
                                    percentage: 98,
                                  ),
                                ),
                                SizedBox(height: 7),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      total_registrations,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    Icon(Icons.trending_up_sharp,size:15,),
                                  ],
                                ),
                              ],
                            ),
                          ),
                                                ),
                        ),
                      Container(
                        height: 100,
                        width: 150,
                        child: Card(
                          elevation: 1.0,
                          /* shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: Colors.blue.shade100,
                              width: 2.0,
                            ),
                          ),*/
                          color:Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(defaultPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Payments',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(height: defaultPadding),
                                Flexible(
                                  child: ProgressLine(
                                    color: Colors.green,
                                    percentage: 98,
                                  ),
                                ),
                                SizedBox(height: 7),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      total_payments,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                            Icon(Icons.payment,size:15,),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                            ],
                          ),

                      //    MyFiles(),
                          SizedBox(height: defaultPadding),
                          if (Responsive.isMobile(context))
                            SizedBox(height: defaultPadding),
                          if (Responsive.isMobile(context)) StarageDetails(),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      SizedBox(width: defaultPadding),
                    // On Mobile means if the screen is less than 850 we dont want to show it
                    if (!Responsive.isMobile(context))
                      Expanded(
                        flex: 2,
                        child: StarageDetails(),
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