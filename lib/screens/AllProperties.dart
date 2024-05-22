import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';
import 'package:paynow/paynow.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smatprop/widgets/CustomButtton.dart';

import '../constants/global_constants.dart';
import '../widgets/DrawerClass.dart';
import 'fileupload_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import 'dart:io';



class AllProperties extends StatefulWidget {
  @override
   _AllPropertiesState createState() => _AllPropertiesState();


}

class _AllPropertiesState extends State<AllProperties> {
  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    print(formatted);
    return formatted;
  }

  List _dataList = [];
  List _filteredDataList = [];
  String getPollUrl="";
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  late SharedPreferences logindata;
  late String clientID;
   String trx_empty="";


  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {

    logindata = await SharedPreferences.getInstance();
   // clientID=logindata.getString('clientID')!;

    var url = Uri.parse('http://'+ip_address2+':93/gsam_clienttaku/api/report/trxn_requests');
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({'ClientID': 873});

    var response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      print("takupinda mu table viewing===AllProperties.dart");
      print(jsonData['Data']);
      setState(() {
        print("tipei status yacho tione for empt trx");
        print("iyo kk :: "+jsonData['Status']);
        print("check condition");
        print(jsonData['Status']=="Error");

        trx_empty= jsonData['Status'];
        if(jsonData['Status']=="Error"){

        }else{
          _dataList = jsonData['Data'];
          _filteredDataList = List.from(_dataList);
        }

      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void _filterDataList(String searchQuery) {
    setState(() {
      _filteredDataList = _dataList.where((data) {
        return data[2].toLowerCase().contains(searchQuery.toLowerCase()) || data[4].toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    });
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by amount',
                border: OutlineInputBorder(borderRadius:BorderRadius.circular(30.0),),
              ),
              onChanged: (value) {
                _filterDataList(value);
              },
            ),
          ),
          Expanded(
            child: Column(
              children: [
                trx_empty=="Error"?
                    Container(
                      margin: EdgeInsets.only(top: 60),
                      //color: Colors.black,
                      height: 20,
                      width: 200,
                      child: Text("There are no Properties to display",
                        style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
                     )
                    :
                    Expanded(
                  child: _filteredDataList.isEmpty
                      ?Center(child:AvatarGlow(
                    glowColor: Colors.blue,
                    endRadius: 90.0,
                    duration: Duration(milliseconds: 2000),
                    repeat: true,
                    showTwoGlows: true,
                    repeatPauseDuration: Duration(milliseconds: 100),
                    child: Material(
                      elevation: 8.0,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[100],
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 60,
                        ),
                        radius: 40.0,
                      ),
                    ),
                  ),
                  ) //Center(child: CircularProgressIndicator())

                      : ListView.builder(
                    itemCount: _filteredDataList.length,
                    itemBuilder: (context, index) {
                      final data = _filteredDataList[index];
                      return Container(
                     /*   decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.blue.shade100,
                            width: 2
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),*/
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue.shade100,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          leading:/*NetworkImage(data[1])!=null? CircleAvatar(
                            backgroundImage: NetworkImage(data[1]),
                          ):*/ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.asset(
                              'assets/images/1.png',
                              width: 80,
                              height: 220,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,

                         children: [

                           InkWell(
                             child: Icon(Icons.upload_file,color: Colors.blue,),
                             onTap: () {
                               showDialog(
                                 context: context,
                                 builder: (BuildContext context) {
                                   return FileUploadDialog(id:data[0].toString());
                                 },
                               );
                             },
                           ),
                           SizedBox(width: 10,),
                           ElevatedButton(
                               style: ElevatedButton.styleFrom(
                                   backgroundColor:ThemeColor,
                                   fixedSize: Size( MediaQuery.of(context).size.width * 0.20,MediaQuery.of(context).size.height / 120)// * 0.005 Set the button color here width, height
                               ),
                               onPressed:(){},
                               child: Text("Apply",
                                   style: TextStyle(fontSize:10,fontWeight: FontWeight.bold,color:Colors.black)
                               )
                           ),
                         ],
                          ),
                          title: Text(data[3],  style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black45,
                          ),),
                          subtitle: Text('\$ '+data[4],  style: TextStyle(
                          fontFamily: "Roboto",
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38,
                          )),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

        ],

      ),
    );
  }


}