import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:paynow/paynow.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Payments extends StatefulWidget {
  const Payments({Key? key}) : super(key: key);



  @override
  State<Payments> createState() => _PaymentsState();



}

class _PaymentsState extends State<Payments> {
  int newIndex = 0;
  //SharedPreferences logindata = await SharedPreferences.getInstance();
@override
  void initState() {
    // TODO: implement initState
    super.initState();

   /* setState(() {
      username = logindata.getString('username')!;
      username1 = logindata.getString('username1')!
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        drawer: DrawerClass(),
        bottomNavigationBar: BottomNavyBar(
          itemCornerRadius: 10,
          selectedIndex: newIndex,
          items: AppData.bottomNavyBarItems
              .map(
                (item) => BottomNavyBarItem(
                  icon: item.icon,
                  title: Text(item.title),
                 //activeColor: item.activeColor,
                  activeColor:Colors.black,
                  inactiveColor: item.inActiveColor,
                 // inactiveColor: item.inActiveColor,
                ),
              )
              .toList(),
          onItemSelected: (currentIndex) {
            newIndex = currentIndex;
            setState(() {});
          },
        ),
        body:PageTransitionSwitcher(
          duration: const Duration(seconds: 1),
          transitionBuilder: (
            Widget child,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,

            );

          },
          child: Payments.screens[newIndex],
        ),
      ),
    );
  }
}

class DialogExample extends StatelessWidget {
  //final TextEditingController _textFieldController = TextEditingController();
  const DialogExample({super.key});
  //  DialogExample(_textFieldController);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Transaction'),
      content: const Text('AlertDialog description'),
     /* content: TextField(

        controller: _textFieldController,

        decoration: InputDecoration(hintText: "Enter Text"),

      ), */

      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    );
  }
}


class PaymentHome extends StatefulWidget {
  const PaymentHome({Key? key}) : super(key: key);

  @override
  State<PaymentHome> createState() => _PaymentHomeState();
}

class _PaymentHomeState extends State<PaymentHome> {
  TextEditingController _trxnTypeController = TextEditingController();
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _textAmountController = TextEditingController();
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

  @override
  void initState() {
    super.initState();
    initial_state();
  }
  initial_state() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username=logindata.getString('username')!;
      clientID=logindata.getString('clientID')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter TextField Example'),
        ),
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
                          child: Text(items),
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

                      pay(dropdownvalue.toString(),_textAmountController.text.toString(),_textFieldController.text.toString());
                    },
                  )
                ],
              )
          ),
        )
    );
  }



}



