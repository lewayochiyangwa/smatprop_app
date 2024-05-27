import 'dart:convert';



import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:http/http.dart' as http;
import 'package:paynow/paynow.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/global_constants.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

class PropertyApplication extends StatefulWidget {
  final int id;
  const PropertyApplication({Key? key,required this.id}) : super(key: key);

  @override
  State<PropertyApplication> createState() => _PropertyApplicationState();
}

class _PropertyApplicationState extends State<PropertyApplication> {
  TextEditingController _trxnCurrentAddressController = TextEditingController();
  TextEditingController _textReasonController = TextEditingController();
  TextEditingController _textAmountController = TextEditingController();
 // TextEditingController _textAmountController = TextEditingController();

  final _textFeeController = TextEditingController(text: "50");
  String getPollUrl="";

  // Initial Selected Value
  String dropdownvalue = 'Ecocash';

  // List of items in our dropdown menu
  var items = [
    'Ecocash',
    'Inn Bucks',
    'One Wallet',
  ];

  late SharedPreferences logindata;
  late String username;
  late String clientID;
  late int userId;
  bool checkedValue = false;

  File? _selectedFile;
  bool _uploading = false;

  late String email="";
  late String token="";
  late String profilepicLink="";

  @override
  void initState() {
    super.initState();
    initial_state();
  }

  initial_state() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      //  token=logindata.getString('token')!;
      //  email=logindata.getString('email')!;
      token = logindata.getString('token') ?? '';
      email = logindata.getString('email') ?? '';
       userId = logindata.getInt('userId')!;
      userId = userId ?? 0; // Default to 0 if userId is null
    });
    ////////////////////////////
    var url = Uri.parse(ip_address3+'api/v1/auth/profilepic');
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      'email':email

    });
    try {
      var response = await http.post(url, headers: headers, body: body);
      print("test response");
      print(response.body);
      setState(() {
      //  profilepicLink="https://2d9b-2c0f-f8f0-d348-0-9d53-ff74-14ec-ffdc.ngrok-free.app/houses/"+json.decode(response.body);
        print("zvasetwa");
      //  print(profilepicLink);
      });

    } catch (error) {
      print(error);
    }
    print(profilepicLink);
    ////////////////////////////

  }
  void _showFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.all(15),
                    child:TextFormField(
                      maxLines:2,
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

                        hintText: 'Current Address',
                        hintStyle: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                          fontFamily: "Roboto",
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)

                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                      ),
                      controller: _trxnCurrentAddressController,
                      readOnly: false,
                      onTap: () async {
                      },
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child:TextFormField(
                      maxLines:3,
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

                        hintText: 'Reason For leaving ',
                        hintStyle: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                          fontFamily: "Roboto",
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)

                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                      ),
                      controller: _textReasonController,
                      readOnly: false,
                      onTap: () async {
                      },
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child:Text("Attach Proof of Employment Or Bank Statement")
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child:Row(
                      children: [
                        _selectedFile != null
                            ? Wrap(
                          children: [
                            Container(
                              width: 200,
                              child: Text(
                                'Selected file: ${_selectedFile!.path}',
                                maxLines: 4,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                ),
                                //  overflow: TextOverflow.ellipsis, // Display an ellipsis when text is too long
                              ),
                            ),
                          ],
                          spacing: 8.0,
                          runSpacing: 4.0,
                        )/*Container(
                            child: Text('Selected file: ${_selectedFile!.path}',
                              softWrap: true,
                                overflow: TextOverflow.ellipsis
                            )
                        )*/
                            : Text('No file selected'),
                        // SizedBox(height: 10),
                        ElevatedButton(
                          child: Text('Select File'),
                          style: ElevatedButton.styleFrom(
                            // fixedSize: const Size(100,10),
                            elevation: 10,
                            backgroundColor: Colors.green,
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontStyle: FontStyle.normal),
                          ),
                          onPressed: _showFilePicker,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child:CheckboxListTile(
                      title: Text("Pay Application Fee"),
                      value: checkedValue,
                      onChanged: (newValue) {
                        setState(() {
                          checkedValue = newValue!;
                          if (checkedValue) {
                            print("Checkbox is checked");
                          } else {
                            print("Checkbox is unchecked");
                          }
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                    ),
                  ),
                  checkedValue?Padding(
                    padding: EdgeInsets.all(15),
                    child:DropdownButtonFormField(
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
                  ):Container(),
                  checkedValue?Padding(
                    padding: EdgeInsets.all(15),
                    child:TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          color: Colors.red,
                        ),
                        labelStyle: TextStyle(
                          fontFamily: "OpenSans",
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                       // hintText: '\$50.00',
                        hintStyle: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                          fontFamily: "Roboto",
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                      ),
                      controller: _textFeeController,
                      enabled: false, // Set the field to disabled
                      style: TextStyle(
                        color: Colors.black, // Set the text color to black
                      ),
                      onTap: () async {
                        // No action needed since the field is disabled
                      },
                      keyboardType: TextInputType.text,
                    ),
                  ):Container(),

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
                    onPressed: () async {
                      _showLoadingModal(context);
                      print('my diouble');
                      print(_textFeeController.text);
                      final file = File(_selectedFile!.path);
                      final bytes = await file.readAsBytes();
                      print("the image now");
                      print(base64Encode(bytes));
                      print(ip_address3+'api/v1/userz/property_application');

                      var url = Uri.parse(ip_address3+'api/v1/userz/property_application');
                      var headers = {
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer $token'
                      };
                      var body = json.encode({
                        'id':userId,
                        'user_id':userId,
                        'current_address': _trxnCurrentAddressController.text,
                        'reason_for_leaving': _textReasonController.text,
                        'fee_amount':_textFeeController.text,
                        'fee_payment_status': checkedValue,
                        'fee_payment_type': 1,
                        'property_id':widget.id,
                        'attachment': base64Encode(bytes).toString(),
                      });

                      print('my body');
                      print(body);

                      try{
                        var response = await http.post(
                            url, headers: headers, body: body);
                        Navigator.of(context).pop();
                        print(response.statusCode == 200);
                        print(response.statusCode);
                        if (response.statusCode == 200) {
                          print('Success Every');
                          _trxnCurrentAddressController.clear();
                          _textReasonController.clear();
                          _textFeeController.clear();
                          setState(() {
                            _selectedFile = null;
                            checkedValue = false;
                          });
                          _showSucessModal(context, 'Application Submitted Successfully');
                          if(checkedValue){
                            //   pay(dropdownvalue.toString(),_textAmountController.text.toString(),'ff');
                          }

                        }else{
                          print(response.body);

                        }
                      }catch (e) {

                     //   _showErrorModal(context, 'An error occurred: $e');
                      }

                      // Handle the response

                    }
                  )
                ],
              )
          ),
        )
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

  void _showErrorModal(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
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
                Text('Loading...'),
              ],
            ),
          ),
        );
      },
    );
  }


  void pay(String trxnType,String amount,String phone)async{
    print("tapinda mu payment");
    print("trn Type"+trxnType.toString());
    print("amount"+trxnType.toString());
    print("phone number"+trxnType.toString());
    String  _phoneController = phone;

    if(trxnType=="Deposit"){
      Paynow paynow = Paynow(integrationKey: "960ad10a-fc0c-403b-af14-e9520a50fbf4", integrationId: "6054", returnUrl: "http://google.com", resultUrl: "http://google.co");
      Payment payment = paynow.createPayment("user", "leroy.chiyangwa1994@gmail.com");

      payment.add(trxnType,double.parse(amount));


      // Initiate Mobile Payment
      //paynow.sendMobile(payment, _phoneController ?? "0784442662",)
      paynow.sendMobile(payment, _phoneController ?? phone,)
          .then((InitResponse response)async{
        // display results
        print(response());
        print("ndaakuda");
        print('------------------');
        print(response.pollUrl);
        getPollUrl = response.pollUrl;

        var url = Uri.parse('http://'+ip_address2+':8091/server/paynowMobile');

        Map data = {
          'type' : trxnType,
          'amount' : amount,
          'clientID' : clientID,
          'valueDate' :username,
          'device' : 'mobile',
          'callback':getPollUrl
        };
        //encode Map to JSON
        var body = json.encode(data);

        print("this is the body"+body);

        var response1 = await http.post(url,
            headers: {"Content-Type": "application/json"},
            body: body
        );
        print("${response1.statusCode}");
        print("${response1.body}");
        //   return response;
        //  }

        print('------------------');
        await Future.delayed(Duration(seconds: 20~/2));
        // Check Transaction status from pollUrl
        paynow.checkTransactionStatus(response.pollUrl)
            .then((StatusResponse status) async {
          print("Before status paid");
          print("hatsvike");
          print("before Uri");
          //  print(postResponse.body);
          print(status.paid);
        });
      });
    }
    else if(trxnType=="Withdraw"){
      var url = Uri.parse('http://'+ip_address+':8091/server/paynowMobile');

      Map data = {
        'type' : trxnType,
        'amount' : amount,
        'clientID' : clientID,
        'valueDate' :username,
        'device' : 'mobile',
        'callback':''
      };
      //encode Map to JSON
      var body = json.encode(data);

      print("this is the body"+body);

      var response1 = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: body
      );
    }


  }
}



