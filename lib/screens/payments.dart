import 'dart:convert';
import 'dart:io';



import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:paynow/paynow.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/global_constants.dart';
import 'PropertyApplication.dart';










class Payments extends StatefulWidget {
  const Payments({Key? key}) : super(key: key);

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  TextEditingController _trxnTypeController = TextEditingController();
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _textAmountController = TextEditingController();
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

  List _filteredDataList = [];
  List _dataList = [];



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
      token = logindata.getString('token') ?? '';
      email = logindata.getString('email') ?? '';
    });
  }


  Future<void> _getData() async {

    logindata = await SharedPreferences.getInstance();
    var my = ip_address3+'/api/v1/admin/property';
    print('vvvv'+my);
    final response = await http.get(
      Uri.parse(ip_address3+'api/v1/admin/property'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    print("this is the response");
print(response.statusCode);
    //  var response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      print("takupinda mu table viewing===AllProperties.dart");
      print(jsonData['Data']);
      setState(() {
        print("tipei status yacho tione for empt trx");

      //  trx_empty= jsonData['status'];
        if(jsonData['status']=="Error"){

        }else{
          _dataList = jsonData['data'];
       //   _filteredDataList = List.from(_dataList);
        }

      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Padding(
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
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
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
                  Padding(
                    padding: EdgeInsets.all(15),
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
                      print("value from amount"+_textAmountController.text.toString());
                      print("value from drop down"+_trxnTypeController.text.toString());

                     // pay(dropdownvalue.toString(),_textAmountController.text.toString(),_textFieldController.text.toString());
                    },
                  ),
                  Container(
                    height: 500,
                    color: Colors.black,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child:ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: _filteredDataList.length,
                        itemBuilder: (context, index) {
                          print("this is the data"+_filteredDataList[index]);
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
                            child: Container(
                              width: double.infinity,
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

                                    // SizedBox(width: 10,),
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
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              )
          ),
        )
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



