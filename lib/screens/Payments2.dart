import 'dart:typed_data';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:paynow/paynow.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smatprop/widgets/CustomButtton.dart';

import '../constants/global_constants.dart';
import '../widgets/DrawerClass.dart';
import 'PropertyApplication.dart';
import 'fileupload_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


import 'dart:io';



class Payments2 extends StatefulWidget {
  @override
   _Payments2State createState() => _Payments2State();


}

class _Payments2State extends State<Payments2> {
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
  late String mypollUrl="";

  late String email="";
  late String token="";
  late int userId=0;

  String dropdownvalue = 'Ecocash';
  String dropdownvalue2 = 'Rent';

  // List of items in our dropdown menu
  var items = [
    'Ecocash',
    'Inn Bucks',
    'One Wallet',
  ];

  var itemsType = [
    'Rent',
    'Property Maintanance',
    'Application Fee',

  ];


  TextEditingController _trxnTypeController = TextEditingController();
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _textAmountController = TextEditingController();




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
      userId = logindata.getInt('userId') ?? 0;
    });
    await Permission.storage.request();
  }

  Future<void> _getData() async {

    logindata = await SharedPreferences.getInstance();

    var url = Uri.parse(ip_address3+'api/v1/userz/get_user_payments');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var body = json.encode({
      'userId':userId,
    });

    print('my body');
    print(body);


      var response = await http.post(
          url, headers: headers, body: body);

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
          print(_filteredDataList);
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

  Future<void> downloadPdf2(Uint8List pdfBytes) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/downloaded_file.pdf');
    await file.writeAsBytes(pdfBytes);

    final url = file.path;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Handle the case where the PDF viewer could not be opened
      throw 'Could not launch $url';
    }
  }

  Future<void> downloadPdf(Uint8List pdfBytes) async {
    try {

      //=======================
      // To check whether permission is given for this app or not.
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        print('check if permission given');

      }else{
        print('taane acess');
        Directory _directory = Directory("");
        if (Platform.isAndroid) {
          // Redirects it to download folder in android
          print('Redirects it to download folder in android ');
          _directory = await getApplicationDocumentsDirectory();
          print(_directory);
          _directory = Directory("/Download");
        //  final file = File('${_directory.path}/downloaded_file.pdf');
        //  await file.writeAsBytes(pdfBytes);

          //******************************
          final file = File('/storage/emulated/0/Download/completes.pdf');

// Write the file to the internal storage
          await file.writeAsBytes(pdfBytes);

          //********************************

        } else {
          _directory = await getApplicationDocumentsDirectory();
        }
      }

      //=======================
  /*    print('getApplicationDocumentsDirectory');
      final dir = await getApplicationDocumentsDirectory();
      print('tipei directory racho');
      print(dir);
      final file = File('${dir.path}/downloaded_file.pdf');
      await file.writeAsBytes(pdfBytes);

      final url = file.path;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      } */
    } catch (e) {
      print('Error downloading PDF: $e');
    }
  }


  void pay(String phone,String amount,description)async{
    print("tapinda mu payment");
    //print(trxnType.toString());
    String  _phoneController = phone;
    Paynow paynow = Paynow(integrationKey: "960ad10a-fc0c-403b-af14-e9520a50fbf4", integrationId: "6054", returnUrl: "http://google.com", resultUrl: "http://google.co");
    Payment payment = paynow.createPayment("user", "leroy.chiyangwa1994@gmail.com");

    payment.add(description,double.parse(amount));


    // Initiate Mobile Payment
    //paynow.sendMobile(payment, _phoneController ?? "0784442662",)
    paynow.sendMobile(payment, _phoneController ?? "0783065525",)
        .then((InitResponse response)async{
      // display results
      print(response());
      print("ndaakuda");
      print('------------------');
      print(response.pollUrl);
      getPollUrl = response.pollUrl;
      setState(() {
        mypollUrl = response.pollUrl;
      });
      print('------------------');

      //=====================================

      print('my user id');
      print(userId);
      var url = Uri.parse(ip_address3+'api/v1/userz/payment');
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var body = json.encode({
        'id':0,
        'userId':userId,
        'receiptNumber':'',
        'description': dropdownvalue2,
        'call_back_url': mypollUrl,
        'amount': _textAmountController.text,
        'date':'',

      });

      print('my body');
      print(body);

      try {
        var response = await http.post(
            url, headers: headers, body: body);
        Navigator.of(context).pop();
        if(response.statusCode==200){
          _showSucessModal(context, 'Transaction Submitted Successfully');
        }
      } catch (error) {
        print(error);
      }

      //=======================================
     /* await Future.delayed(Duration(seconds: 20~/2));
      // Check Transaction status from pollUrl
      paynow.checkTransactionStatus(response.pollUrl)
          .then((StatusResponse status) async {

        print(status.paid);
      });*/
    });

  }

  void _showLoadingModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16.0),
                Text('Processing...'),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSucessModal(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'Payment Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.0),
                    // borderSide: BorderSide(color: Colors.blue, width: 1),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                ),

                // Initial Value
                value: dropdownvalue2,

                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),

                // Array list of items
                items: itemsType.map((String itemsType) {
                  return DropdownMenuItem(
                    value: itemsType,
                    child: Row(
                      children: [
                        Text(itemsType)
                      ],
                    ),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue2 = newValue!;
                    print("ma tora ipi pa drop down value"+dropdownvalue2);
                  });
                },

              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height:MediaQuery.of(context).size.height * 0.080,
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'Transaction Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.0),
                    // borderSide: BorderSide(color: Colors.blue, width: 1),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                ),

                // Initial Value
                value: dropdownvalue,

                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),

                // Array list of items
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Row(
                      children: [
                        Text(items),
                        const SizedBox(width: 20),
                        if (items == 'Inn Bucks')
                          Image.asset("assets/images/innbucks3.png", width: 50, height: 50)
                        else if (items == 'Ecocash')
                          Image.asset("assets/images/ecocash1.png", width: 50, height: 50)
                        else if (items == 'One Wallet')
                            Image.asset("assets/images/onewallet.png", width: 50, height: 50)
                      ],
                    ),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                    print("ma tora ipi pa drop down value"+dropdownvalue);
                  });
                },

              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height:MediaQuery.of(context).size.height * 0.080,
              child:TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration:  InputDecoration(
                  hintText: 'Amount',
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                    fontFamily: "Roboto",
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    //  borderSide: BorderSide(color: Colors.blue, width: 1)
                  ),
                  /**   focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1)),
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1)
                      ),*/
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                ),
                controller: _textAmountController,
                readOnly: false,
                onTap: () async {

                },
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  final int? intValue = int.tryParse(value);
                  if (intValue == null) {
                    return 'Please enter value';
                  }
                  return null;
                },

              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height:MediaQuery.of(context).size.height * 0.080,
              child:TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,

                decoration:  InputDecoration(
                  errorStyle: TextStyle(
                    color: Colors.red,
                  ),
                  labelStyle: TextStyle(
                    fontFamily: "OpenSans",
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.black,
                  ),

                  hintText: 'Phone  eg 0783065525',
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                    fontFamily: "Roboto",
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0)
                    //   borderSide: BorderSide(color: Colors.blue, width: 1)
                  ),
                  /**focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1)),
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1)
                      ),*/
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                ),
                controller: _textFieldController,
                readOnly: false,
                onTap: () async {
                },
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  final RegExp phoneRegex = RegExp(r'(0)7[7-8|1|3][0-9]{7}$'); // Define the regular expression
                  if (!phoneRegex.hasMatch(value)) { // Check if the phone number matches the pattern
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
            ),
          ),
          ElevatedButton(
            child: Text('Submit',
              style:  TextStyle(
                fontSize: 12.0,
                color: Colors.white,
                fontFamily: "Roboto",
              ),

            ),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(150,15),
              backgroundColor: Colors.blue,
              //  onPrimary: Colors.white,

              textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontStyle: FontStyle.normal),
            ),
            onPressed: () async{

              _showLoadingModal(context);

              pay(_textFieldController.text.toString(),_textAmountController.text.toString(),dropdownvalue2);





            },
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
                          leading:Column(
                            children: [
                              Text("Receipt No: #"+data['receiptNumber'].toString(),  style: TextStyle(
                                fontFamily:"OpenSans",
                                fontSize:MediaQuery.of(context).size.height * 0.015,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45,
                              ),),
                              Text(data['status'] == null ? "Status: Pending" : "Status: " + data['status'].toString(),  style: TextStyle(
                                fontFamily:"OpenSans",
                                fontSize:MediaQuery.of(context).size.height * 0.015,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45,
                              ),),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,

                         children: [
                           Column(
                             children: [
                               Text("Receipt"),
                              InkWell(
                                  child: Icon(Icons.download,color: Colors.blue,),
                                      onTap: () async {
                                        _showLoadingModal(context);
                                        print('this is the data');
                                        print(data['id']);
                                        logindata = await SharedPreferences.getInstance();
                                        print("this is the bool for login");
                                        // print(logindata.getBool('login'));
                                        // if(logindata.getBool('login')!){
                                        if(logindata.getString('function_log_control')=="granted"){

                                          print("tapinda mu pdf download");
                                          ////////////////////////////
                                          var url = Uri.parse(ip_address3+'api/v1/userz/reportBytes');
                                          var headers = {
                                            'Content-Type': 'application/json',
                                            'Authorization': 'Bearer $token'
                                          };
                                          var body = json.encode({
                                            'invoiceID':data['id'].toString(),
                                            'clientID':userId.toString(),
                                          });
                                          try {
                                            var response = await http.post(url, headers: headers, body: body);
                                            if(response.statusCode==200){
                                              print("test response");
                                              print(response.body);

                                              downloadPdf(response.bodyBytes);
                                              Navigator.of(context).pop();
                                            }
                                            _showSucessModal(context, 'Report Downloaded Successfully');

                                            setState(() {

                                            });

                                          } catch (error) {
                                            print(error);
                                          }

                                          ////////////////////////////

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

                        }
                              ),
                             ],
                           ),
                         ],
                          ),
                          title: Text(data['description'],  style: TextStyle(
                            fontFamily:"OpenSans",
                            fontSize:MediaQuery.of(context).size.height * 0.025,
                            fontWeight: FontWeight.bold,
                            color: Colors.black45,
                          ),),
                          subtitle: Text("\$"+data['amount'].toString(),  style: TextStyle(
                          fontFamily: "Roboto",
                            fontSize:MediaQuery.of(context).size.height * 0.020,
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