/**import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';
import 'package:paynow/paynow.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/global_constants.dart';
import '../widgets/DrawerClass.dart';
import 'fileupload_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import 'dart:io';



class MyListView extends StatefulWidget {
  @override
   _MyListViewState createState() => _MyListViewState();


}

class _MyListViewState extends State<MyListView> {
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
    clientID=logindata.getString('clientID')!;

    var url = Uri.parse('http://'+ip_address+':93/gsam_clienttaku/api/report/trxn_requests');
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({'ClientID': clientID});

    var response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      print("takupinda mu table viewing===tutor_table.dart");
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

  Future<void> _postDeposit(double amount, String phoneNumber) async {
    pay("Deposit",amount.toString(),phoneNumber);
    var url = Uri.parse('http://'+ip_address+':93/gsam_clienttaku/api/deposit');
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      'Amount': amount,
      'Phonenumber': phoneNumber,
    });

    var response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
   //   print('Deposit successful.');
    } else {
      //print('Deposit failed with status: ${response.statusCode}.');
    }
  }

  void pay(String trxnType,String amount,String phone)async{
    print("tapinda mu payment");
    //print(trxnType.toString());
    String  _phoneController = phone;
    Paynow paynow = Paynow(integrationKey: "960ad10a-fc0c-403b-af14-e9520a50fbf4", integrationId: "6054", returnUrl: "http://google.com", resultUrl: "http://google.co");
    Payment payment = paynow.createPayment("user", "leroy.chiyangwa1994@gmail.com");

    payment.add(trxnType,double.parse(amount));


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
      print('------------------');
      await Future.delayed(Duration(seconds: 20~/2));
      // Check Transaction status from pollUrl
      paynow.checkTransactionStatus(response.pollUrl)
          .then((StatusResponse status) async {
        print("Before status paid");
        print("hatsvike");
        /**  var url = Uri.parse('http://192.168.100.32:8090/server/paynowMobile');
            //  final Uri = 'https://na57.salesforce.com/services/oauth2/token';
            var map = new Map<String, dynamic>();
            map['type'] = _textFieldController.text;
            map['amount'] = _trxnTypeController.text;
            map['clientID'] = '873';
            map['valueDate'] = 'example@mail.com.us';
            map['device'] = 'mobile';

            print("tomboona the json body request");
            print(map);

            http.Response postResponse = await http.post(
            url,
            headers: {"Content-Type": "application/json"},
            body: map,
            );*/



        print("before Uri");
        //  print(postResponse.body);
        print(status.paid);
      });
    });

  }

  void _showDepositDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Deposit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
            ),
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            child: Text('Cancel'),
            style: ElevatedButton.styleFrom(
              elevation: 8,
              backgroundColor: Colors.blue,
              textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontStyle: FontStyle.normal),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: Text('Deposit'),
            style: ElevatedButton.styleFrom(
              elevation: 8,
              backgroundColor: Colors.blue,
              textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontStyle: FontStyle.normal),
            ),
            onPressed: () {
              double amount = double.tryParse(_amountController.text) ?? 0.0;
              String phoneNumber = _phoneNumberController.text;
              _postDeposit(amount, phoneNumber);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      drawer: DrawerClass(),
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
                      child: Text("There are no Transactions",
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
                            width: 2
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          leading:  data[3]=="Deposit"?Icon(Icons.add_circle_sharp,color: Colors.green):Icon(Icons.remove_circle_sharp,color: Colors.red ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                         children: [
                           Text("Pending",),
                         Column(children: [
                           Text(convertDateTimeDisplay(data[2])),
                           SizedBox(height: 5,),
                          // Text("PendingC2"),
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
                         ],),

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
          Padding(
            padding: const EdgeInsets.only(left: 50,bottom: 10,right: 50),
            child: Row(
              children: [
                ElevatedButton(
                  child: Text('Withdraw'),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(100,10),
                    elevation: 10,
                    backgroundColor: Colors.blue,
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontStyle: FontStyle.normal),
                  ),
                  onPressed: () {},
                ),
               Container(width: 60,),
                ElevatedButton(
                  child: Text('Deposit'),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(100,10),
                    elevation: 10,
                    backgroundColor: Colors.blue,
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontStyle: FontStyle.normal),
                  ),
                  onPressed: () {
                    _showDepositDialog(context);
                  },
                ),
              ],
            ),
          )
        ],

      ),
    );
  }


}*/