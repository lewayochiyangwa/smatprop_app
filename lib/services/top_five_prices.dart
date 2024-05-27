import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/global_constants.dart';



class TopPricesController extends GetxController {
  var top_prices_isLoading = true.obs;
  RxList<TopFivePrices> topprices_data2 = <TopFivePrices>[].obs;

  late SharedPreferences logindata;
   late String email = "";
  late String token = "";

  @override
  void onInit() {
    super.onInit();
    topFivePrices3();
  }




  Future<void> topFivePrices() async {
    logindata = await SharedPreferences.getInstance();
    final url = Uri.parse(ip_address3+'api/v1/admin/myproperty_stats');

    final headers = {'Content-Type': 'application/json'};
      print('tapinda muma prices');
      final response = await http.get(url, headers: headers);
      print('waiting response muma prices');
      if (response.statusCode == 200) {
        print("inside success");
        final jsonData = json.decode(response.body) as List<dynamic>;
        topprices_data2.assignAll(jsonData
            .map((item) => TopFivePrices.fromJson(item as Map<String, dynamic>)));
        top_prices_isLoading.value = false;
        update();
        print(topprices_data2);
      } else {
       // Get.snackbar('Error Loading data!',
       //     'Server responded: ${response.statusCode}:${response.reasonPhrase.toString()}');
      }

  }


  Future<void> topFivePrices3() async {
    logindata = await SharedPreferences.getInstance();
    email = logindata.getString('email') ?? '';
    token = logindata.getString('token') ?? '';
    print('this is the token'+token);
    print('this is the email'+email);
    final url = Uri.parse(ip_address3 + 'api/v1/admin/myproperty_stats');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = json.encode({
      "email":email,
    });

    print('Sending POST request for top five prices');
    final response = await http.post(url, headers: headers, body: body);

    print('Waiting for response');
    if (response.statusCode == 200) {
      print("Success");
      final jsonData = json.decode(response.body) as List<dynamic>;
      topprices_data2.assignAll(jsonData
          .map((item) => TopFivePrices.fromJson(item as Map<String, dynamic>)));
      top_prices_isLoading.value = false;
      update();
      for (final price in topprices_data2) {
        print('Address: ${price.address}');
        print('Amount: ${price.amount}');
        print('Fee Status: ${price.feestatus}');
        print('---');
      }

      print(topprices_data2);
    } else {
      print('table anetsa');
      print(response.body);
   //   Get.snackbar(
    //    'Error Loading data!',
     //   'Server responded: ${response.statusCode}:${response.reasonPhrase.toString()}',
    //  );
    }
  }


}

class TopFivePrices {
  final String address;
  final String amount;
  final String feestatus;
  final String property_id;

  TopFivePrices(
      {required this.address,
        required this.amount,
        required this.feestatus,
        required this.property_id});

  factory TopFivePrices.fromJson(Map<String, dynamic> json) {
    return TopFivePrices(
      address: json['address'] as String? ?? '',
      amount: json['amount'] as String? ?? '',
      feestatus: json['feestatus'] as String? ?? '',
      property_id: json['property_id'] as String? ?? '',
    );
  }
}