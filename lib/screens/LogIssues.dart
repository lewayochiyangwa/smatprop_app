import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:paynow/paynow.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/global_constants.dart';
import '../widgets/LoadingModal.dart';
import '../widgets/SuccessModal.dart';





class LogIssues extends StatefulWidget {
  const LogIssues({Key? key}) : super(key: key);

  @override
  State<LogIssues> createState() => _LogIssuesState();
}

class _LogIssuesState extends State<LogIssues> {
  TextEditingController _textFieldController = TextEditingController();

  String getPollUrl="";

  // Initial Selected Value
  String dropdownvalue = 'Deposit';

  // List of items in our dropdown menu
  var items = [
    'Deposit',
    'Withdraw',
  ];

  late SharedPreferences logindata;
  late String username;
  late String clientID;
  late int userId=0;
  late String token="";

  @override
  void initState() {
    super.initState();
    initial_state();
  }
  initial_state() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      token = logindata.getString('token') ?? '';
      userId = logindata.getInt('userId') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child:Image.asset("assets/images/hours24.png",
                      width: 200,
                      height: 200,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child:Text("Hour Response",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontFamily: "OpenSans",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child:TextFormField(
                      maxLines: 4,
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

                        hintText: 'Tell Us Your Issue',
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
                      keyboardType: TextInputType.text,

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
                      backgroundColor: ThemeColor,
                      //  onPrimary: Colors.white,

                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontStyle: FontStyle.normal),
                    ),
                    onPressed: () async{
                      LoadingModal.showLoadingModal(context);
                      var url = Uri.parse(ip_address3+'api/v1/userz/message');

                           // var url = Uri.parse(ip_address3+'api/v1/admin/payment');
                            var headers = {
                            'Content-Type': 'application/json',
                            'Authorization': 'Bearer $token'
                            };

                          var body = json.encode({
                                'id':0,
                                'message':_textFieldController.text,
                                'user_id':userId,
                                'smstime':'2001-05-26T15:43:47.927Z',

                          });

                          print('my body');
                          print(body);


                          var response = await http.post(
                          url, headers: headers, body: body);
                      Navigator.of(context).pop();

                      if(response.statusCode==200){
                        _textFieldController.clear();
                        SuccessModal.showSuccessModal(context,'Issue Posted successfully!');
                      }


                    },
                  )
                ],
              )
          ),
        )
    );
  }



}



