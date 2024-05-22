import 'package:flutter/material.dart';
import 'package:paynow/paynow.dart';
import 'package:pricing_cards/pricing_cards.dart';

class PricingPlatform extends StatefulWidget {
  const PricingPlatform({Key? key}) : super(key: key);

  @override
  State<PricingPlatform> createState() => _PricingPlatformState();
}

class _PricingPlatformState extends State<PricingPlatform> {
  String getPollUrl="";
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  void pay(String phone,String amount,)async{
    print("tapinda mu payment");
    //print(trxnType.toString());
    String  _phoneController = phone;
    Paynow paynow = Paynow(integrationKey: "960ad10a-fc0c-403b-af14-e9520a50fbf4", integrationId: "6054", returnUrl: "http://google.com", resultUrl: "http://google.co");
    Payment payment = paynow.createPayment("user", "leroy.chiyangwa1994@gmail.com");

    payment.add("Premium",double.parse(amount));


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

        print(status.paid);
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium Upgrade'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PricingCards(
              pricingCards: [
                PricingCard(
                  title: 'Standard',
                  price: '\$ 1',
                  subPriceText: '\/mo',
                  billedText: 'Billed monthly',
                  onPress: () {
                    // make your business
                  },
                ),
                PricingCard(
                  title: 'Premium',
                  price: '\$ 3',
                  subPriceText: '\/mo',
                  billedText: 'Billed anually',
                  mainPricing: true,
                  mainPricingHighlightText: 'Save money',
                  onPress: () {
                    // make your business
                  },
                  cardColor: Colors.lightBlueAccent,
                  priceStyle: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  titleStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  billedTextStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  subPriceStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  cardBorder: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.green, width: 4.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                PricingCard(
                  title: 'Gold',
                  price: '\$ 5',
                  subPriceText: '\/mo',
                  billedText: 'Billed anually',
                  mainPricing: true,
                  mainPricingHighlightText: 'UnLimited',
                  onPress: () {
                    print("gold premium clicked");

                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Premium Upgrade'),
                            content:Container(
                              height:150,
                              width: 50,
                              child: Column(
                                children: [
                                Container(
                                  height:40,
                                  child: TextFormField(
                                    controller: _phoneNumberController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  decoration:  InputDecoration(
                                    labelText: 'Phone',
                                    hintText: 'Phone',
                                    hintStyle: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.grey,
                                      fontFamily: "Roboto",
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      //  borderSide: BorderSide(color: Colors.blue, width: 1)
                                    ),

                                    contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                                  ),
                              //  controller: _textAmountController,
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
                                SizedBox(height: 5,),
                                Container(
                                  height:40,
                                  child: TextFormField(
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    controller: _amountController,
                                    decoration:  InputDecoration(
                                      labelText: 'Amount',
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

                                      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                                    ),
                                    //  controller: _textAmountController,
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
                                  //Text('Send'),
                                  SizedBox(height:5,),
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

                                      pay(_phoneNumberController.text,_amountController.text);
                                    },
                                  )
                                ],
                              ),
                            ), //Text("Log In To Upload Your Work"),
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        }
                    );
                    // make your business
                  },
                  cardColor: Colors.orange,
                  priceStyle: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  titleStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  billedTextStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  subPriceStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  cardBorder: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.green, width: 4.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                )
              ],
            ),
           /* SizedBox(height: 30),
            PricingCards(
              pricingCards: [
                PricingCard(
                  title: 'Gold',
                  price: '\$ 5',
                  subPriceText: '\/mo',
                  billedText: 'Billed monthly',
                  onPress: () {
                    // make your business
                  },
                  cardColor: Colors.orange,
                  priceStyle: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  titleStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  billedTextStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  subPriceStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  cardBorder: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.red, width: 4.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                /** PricingCard(
                  title: 'Monthly',
                  price: '\$ 59.99',
                  subPriceText: '\/mo',
                  billedText: 'Billed anually',
                  mainPricing: true,
                  mainPricingHighlightText: 'Save money',
                  onPress: () {
                    // make your business
                  },
                  cardColor: Colors.blue,
                  priceStyle: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  titleStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  billedTextStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  subPriceStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  cardBorder: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.red, width: 4.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                )*/
              ],
            ),*/
          ],
        ),
      ),
    );
  }
}


