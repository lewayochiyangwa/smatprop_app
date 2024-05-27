import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



import '../../../constants/global_constants.dart';
import 'chart.dart';
import 'storage_info_card.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class StarageDetails extends StatefulWidget {
  const StarageDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<StarageDetails> createState() => _StarageDetailsState();
}

class _StarageDetailsState extends State<StarageDetails> {


  late SharedPreferences logindata;
  late String clientID;
  String trx_empty="";

  late String total_positive="";
  late String total_neutral="";
  late String total_negative="";
  late String email="";
  late String token="";
  @override
  void initState() {
    super.initState();
    initial_state();
    _getPositive();
    _getNeutral();
    _getNegative();

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

  Future<void> _getPositive() async {

    logindata = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.parse(ip_address3+'api/v1/admin/get_positive'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print("takupinda mu table viewing===AllProperties.dart");
      setState(() {
        total_positive = response.body;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> _getNeutral() async {

    logindata = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.parse(ip_address3+'api/v1/admin/get_neutral'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print("takupinda mu table viewing===AllProperties.dart");
      setState(() {
        total_neutral = response.body;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> _getNegative() async {

    logindata = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.parse(ip_address3+'api/v1/admin/get_negative'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print("takupinda mu table viewing===AllProperties.dart");
      setState(() {
        total_negative = response.body;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue.shade100, // set the border color here
          width: 2.0, // set the border width here
        ),
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sentiment Analysis",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
          //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Happy'+'😊', style: TextStyle(fontSize: 12.0,color: Colors.green)),
              SizedBox(width: 10,),
              Text('Neutral'+'😐', style: TextStyle(fontSize: 12.0,color: Colors.blue)),
              SizedBox(width: 10,),
              Text('Angry :'+'😠', style: TextStyle(fontSize:12.0,color: Colors.red)),

            ],
          ),
          //SizedBox(height: defaultPadding),
          SizedBox(height: defaultPadding),
          Chart(),
          StorageInfoCard(
           // svgSrc: "assets/icons/Documents.svg",
            title: "Neutral",
            amountOfFiles: total_neutral,
            //numOfFiles: 1328,
            color2: Color(0xFF2697FF),
          ),

          StorageInfoCard(
           // svgSrc: "assets/icons/folder.svg",
            title: "Positive",
            amountOfFiles:total_positive,
            //numOfFiles: 1328,
            color2:Color(0xFF90EE90),
          ),
          StorageInfoCard(
         //   svgSrc: "assets/icons/unknown.svg",
            title: "Negative",
            amountOfFiles: total_negative,
            //numOfFiles: 140,
            color2: Color(0xFFEE2727),
          ),
        ],
      ),
    );
  }
}
