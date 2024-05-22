import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/global_constants.dart';



class TopPricesController extends GetxController {
  var top_prices_isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    topFivePrices();
  }

  RxList<TopFivePrices> topprices_data2 = <TopFivePrices>[].obs;

  late SharedPreferences logindata;

  Future<void> topFivePrices() async {
    logindata = await SharedPreferences.getInstance();
    final url = Uri.parse('http://'+ip_address2+':8090/server/getTopFive');
    final headers = {'Content-Type': 'application/json'};

   // try {
      print('tapinda muma prices');
      final response = await http.get(url, headers: headers);
      print('waiting response muma prices');
      if (response.statusCode == 200) {
        print('response success in Top Prices Equities');
        print(response.body);

        final jsonData = json.decode(response.body) as List<dynamic>;

        topprices_data2.assignAll(jsonData
            .map((item) => TopFivePrices.fromJson(item as Map<String, dynamic>)));

        top_prices_isLoading.value = false;
        update();

        print("lets print Top 5 Equities Prices");
        print(topprices_data2);
        print("After Top 5 Equities Prices");
      } else {
        Get.snackbar('Error Loading data!',
            'Server responded: ${response.statusCode}:${response.reasonPhrase.toString()}');
      }
   /* } catch (e) {
      Get.snackbar('Error Loading data!', 'Server responded: $e');
      // Handle the exception
      // ...
    }*/
  }
}

class TopFivePrices {
  final String icon;
  final String title;
  final double size;
  final String date;

  TopFivePrices(
      {required this.icon,
        required this.title,
        required this.size,
        required this.date});

  factory TopFivePrices.fromJson(Map<String, dynamic> json) {
    return TopFivePrices(
      icon: json['icon'] as String? ?? '',
      title: json['title'] as String? ?? '',
      size: (json['size'] as num?)?.toDouble() ?? 0.0,
      date: json['date'] as String? ?? '',
    );
  }
}