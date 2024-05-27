import 'dart:convert';


import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../constants/global_constants.dart';
import '../screens/dashboard/dash_widgets/MyFiles.dart';



class DashBoardCardsController extends GetxController {
  //var userList = <UserModel>[].obs;
  var dash_isLoading = true.obs;
  var equity_port_isLoading = true.obs;
  final cloudstore_info = <CloudStorageInfo>[].obs;
  //List  cloudstore_info=[].obs;
  List _assetTypes = [];
  List dash_colors =[primaryColor,Color(0xFFFFA113),Color(0xFFA4CDFF),Color(0xFF007EE5)];
  List dashboard_icons = [Image.asset('assets/images/icons8-property-50.png'),Image.asset('assets/images/icons8-cash-64.png'),
    Image.asset('assets/images/icons8-property-50.png'),Image.asset('assets/images/icons8-property-50.png')];

  late SharedPreferences logindata;
  late String clientID;
  late String strData;

  @override
  void onInit() {
    super.onInit();
    _getAssetTypes();
  }

  /* Future<void> getUsers() async {
    const String userUrl = "https://reqres.in/api/users?page=2";
    final response = await http.get(Uri.parse(userUrl));
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body)['data'];
      userList.value = result.map((e) => UserModel.fromJson(e)).toList();
      isLoading.value = false;
      update();
    } else {
      Get.snackbar('Error Loading data!',
          'Sever responded: ${response.statusCode}:${response.reasonPhrase.toString()}');
    }
  }*/

  Future<void> _getAssetTypes() async {

    logindata = await SharedPreferences.getInstance();

    DateTime today = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(today);

    //  setState(() {
    //clientID=logindata.getString('clientID')!;
    // });
    print("zvobuda here pa session mu dash manage state");
    print("check top dashboard cards are they even firing");
    final response = await http.post(
      Uri.parse(ip_address+':8090/server/consolidated'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'clientNo':873,'valuedate':formattedDate.toString(),'currency':'0'}),
    //  body: jsonEncode(<String, dynamic>{'clientNo':logindata.getString('clientID'),'valuedate':formattedDate.toString(),'currency':'0'}),
    );
//22738 873
    if (response.statusCode == 200) {
     // print("tapinda mu dashboard for equities");
      final json = jsonDecode(response.body);
     // setState(() {
        _assetTypes = json['assetType'];
       // print("lets print the given array");
       // print(_assetTypes);
        List totalList = _assetTypes;
        double totalValue = totalList.fold(0, (sum, item) => sum + item['totalvalue']);
       // print("amhenho kuti ndizvo here"+totalValue.toString());
        for (int i = 0; i < _assetTypes.length; i++) {
         // print("lets simulate percentages"+"---"+_assetTypes[i]['totalvalue'].toString()+"---/---"+totalValue.toString()+"----"+((_assetTypes[i]['totalvalue']/totalValue)).toString());
          if(_assetTypes[i]['totalvalue']<1){
            continue;
          }
          cloudstore_info.add(CloudStorageInfo(
            title: _assetTypes[i]['assetname'],
            numOfFiles:  ((_assetTypes[i]['totalvalue']/totalValue)*100).toInt(),
            //svgSrc: "assets/icons/google_drive.svg",
            svgSrc:dashboard_icons[i],
            totalStorage: _assetTypes[i]['totalvalue'].toStringAsFixed(2),
            color: dash_colors[i],
            percentage: ((_assetTypes[i]['totalvalue']/totalValue)*100).toInt(),
          ));


         // print("${_assetTypes[i]['assetname']}: ${_assetTypes[i]['totalvalue']}");
        }
     // });
      dash_isLoading.value=false;
        update();
    } else {
      throw Exception('Failed to load asset types');
    }


  }
}
