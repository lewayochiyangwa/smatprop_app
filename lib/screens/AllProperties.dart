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
import 'PropertyApplication.dart';
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


  late String email="";
  late String token="";


  @override
  void initState() {
    super.initState();
    initial_state();
    _getData();
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

  Future<void> _getData() async {

    logindata = await SharedPreferences.getInstance();

var my = ip_address3+'/api/v1/userz/property';
print('vvvv'+my);
    final response = await http.get(
      Uri.parse(ip_address3+'api/v1/userz/property'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

  //  var response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      print("takupinda mu table viewing===AllProperties.dart");
      print(jsonData['Data']);
      setState(() {
        print("tipei status yacho tione for empt trx");
      //  print("iyo kk :: "+jsonData['Status']);
      //  print("check condition");
      //  print(jsonData['Status']=="Error");

        trx_empty= jsonData['status'];
        if(jsonData['status']=="Error"){

        }else{
          _dataList = jsonData['data'];
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
            child: Container(
              height:MediaQuery.of(context).size.height * 0.080,
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
                      print(data['id']);
                      print(data['id'].runtimeType);
                      return Card(
                        margin: EdgeInsets.all(12.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ExpansionTile(
                            backgroundColor: Colors.white,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text('Mabvuku'),
                                    Spacer(),
                                    Row(
                                      children: [
                                        Text("Expand"),
                                        Icon(Icons.arrow_drop_down),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(data['description1']),
                                Row(
                                  children: <Widget>[
                                    Text("12 USD/Month"),
                                    Spacer(),
                                    ElevatedButton(
                                      child: Text("Apply",
                                          style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.014,fontWeight: FontWeight.bold,color:Colors.white)
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:ThemeColor,
                                          fixedSize: Size( MediaQuery.of(context).size.width * 0.20,MediaQuery.of(context).size.height / 120)// * 0.005 Set the button color here width, height
                                      ),
                                      onPressed:()async{
                                        print('this is the data');

                                        logindata = await SharedPreferences.getInstance();
                                        print("this is the bool for login");
                                        // print(logindata.getBool('login'));
                                        // if(logindata.getBool('login')!){
                                        if(logindata.getString('function_log_control')=="granted"){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => PropertyApplication(id:data['id'],)),// Settings()),
                                          );

                                          //  print("hmm andisi kuziva");
                                        }else{
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text("Login First To Apply"),
                                              duration: Duration(seconds: 4),
                                              behavior: SnackBarBehavior.floating,
                                              backgroundColor:ThemeColor,
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(color: Colors.red, width: 2),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                          );

                                        }
                                      },

                                    ),

                                  ],
                                ),
                              ],
                            ),
                            trailing: SizedBox(),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                Row(
                                //  mainAxisAlignment:MainAxisAlignment.spaceAround,
                                  children: [

                                    ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)
                                      ),
                                      child: Container(
                                        
                                        height: 120,
                                        width: 120,
                                      
                                        child: Image.asset(
                                          'assets/images/1.png',
                                          height: 120,
                                          width: 120,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20,),

                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.bed_sharp),
                                                Text("3",style: TextStyle(fontSize: 12),),
                                                Text("Bedrooms",style: TextStyle(fontSize: 12),),
                                              ],
                                            ),
                                            SizedBox(width: 10,),
                                            Row(
                                              children: [
                                                Icon(Icons.bathtub_outlined),
                                                Text("3",style: TextStyle(fontSize: 12),),
                                                Text("Bedrooms",style: TextStyle(fontSize: 12),),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(Icons.landscape_outlined),
                                                Text("1000",style: TextStyle(fontSize: 12),),
                                                Text("m        ",style: TextStyle(fontSize: 12),),
                                              ],
                                            ),
                                            SizedBox(width: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(Icons.bathtub_outlined),
                                                Text("2",style: TextStyle(fontSize: 12),),
                                                Text("Acres      ",style: TextStyle(fontSize: 12),),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text("Description",style: TextStyle(fontSize: 12),),
                                            Container(
                                              height: 50,
                                              width: 200,
                                              child: Text("Presenting a captivating house for sale nestled in the serene region of Christon Bank",
                                                style: TextStyle(fontSize: 12,

                                                ),
                                                softWrap: true,

                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),



                                  ],
                                ),
                                 //   Spacer(),
                                 //   Icon(Icons.check),
                                  ],
                                ),
                              ),
                            /*  Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Text("chiyaz"),
                                    Spacer(),
                                    Icon(Icons.check),
                                  ],
                                ),
                              )*/
                            ],
                          ),
                        ),
                      );/*Container(
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
                        child: ExpansionTile(
                          leading:ClipRRect(
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
                           ElevatedButton(
                          child: Text("Apply",
                              style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.014,fontWeight: FontWeight.bold,color:Colors.white)
                          ),
                               style: ElevatedButton.styleFrom(
                                   backgroundColor:ThemeColor,
                                   fixedSize: Size( MediaQuery.of(context).size.width * 0.20,MediaQuery.of(context).size.height / 120)// * 0.005 Set the button color here width, height
                               ),
                               onPressed:()async{
                                 print('this is the data');
                                 print(data['id']);
                                 logindata = await SharedPreferences.getInstance();
                                 print("this is the bool for login");
                                 // print(logindata.getBool('login'));
                                 // if(logindata.getBool('login')!){
                                 if(logindata.getString('function_log_control')=="granted"){
                                   Navigator.push(
                                     context,
                                     MaterialPageRoute(builder: (context) => PropertyApplication(id:data['id'] ,)),// Settings()),
                                   );

                                   //  print("hmm andisi kuziva");
                                 }else{
                                   ScaffoldMessenger.of(context).showSnackBar(
                                     SnackBar(
                                       content: Text("Login First To Apply"),
                                       duration: Duration(seconds: 4),
                                       behavior: SnackBarBehavior.floating,
                                       backgroundColor:ThemeColor,
                                       shape: RoundedRectangleBorder(
                                         side: BorderSide(color: Colors.red, width: 2),
                                         borderRadius: BorderRadius.circular(10),
                                       ),
                                     ),
                                   );

                                 }
                               },

                           ),
                         ],
                          ),
                          title: Text(data['description1'],  style: TextStyle(
                            fontFamily:"OpenSans",
                            fontSize:MediaQuery.of(context).size.height * 0.025,
                            fontWeight: FontWeight.bold,
                            color: Colors.black45,
                          ),),
                          subtitle: Text(data['amount'].toString(),  style: TextStyle(
                          fontFamily: "Roboto",
                            fontSize:MediaQuery.of(context).size.height * 0.020,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38,
                          )),
                        ),
                      );*/
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

  Widget _buildTitle(Map<int, dynamic>? data) {
    int myid=data as int;
    print('muchaitasei nezvinhu zvacho');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text("Mabvuku"),
            Spacer(),
            Row(
              children: [
                Text("Expand"),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ],
        ),
        Text("Rental"),
        Row(
          children: <Widget>[
            Text("12 USD/Month"),
            Spacer(),
    ElevatedButton(
    child: Text("Apply",
    style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.014,fontWeight: FontWeight.bold,color:Colors.white)
    ),
    style: ElevatedButton.styleFrom(
    backgroundColor:ThemeColor,
    fixedSize: Size( MediaQuery.of(context).size.width * 0.20,MediaQuery.of(context).size.height / 120)// * 0.005 Set the button color here width, height
    ),
    onPressed:()async{
    print('this is the data');
    print(myid);
    logindata = await SharedPreferences.getInstance();
    print("this is the bool for login");
    // print(logindata.getBool('login'));
    // if(logindata.getBool('login')!){
    if(logindata.getString('function_log_control')=="granted"){
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => PropertyApplication(id:myid ,)),// Settings()),
    );

    //  print("hmm andisi kuziva");
    }else{
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text("Login First To Apply"),
    duration: Duration(seconds: 4),
    behavior: SnackBarBehavior.floating,
    backgroundColor:ThemeColor,
    shape: RoundedRectangleBorder(
    side: BorderSide(color: Colors.red, width: 2),
    borderRadius: BorderRadius.circular(10),
    ),
    ),
    );

    }
    },

    ),

          ],
        ),
      ],
    );
  }


}