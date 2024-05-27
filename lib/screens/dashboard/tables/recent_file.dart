
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/global_constants.dart';
import '../../../services/top_five_prices.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';



class RecentFiles extends StatefulWidget {
  const RecentFiles({
    Key? key,
  }) : super(key: key);

  @override
  State<RecentFiles> createState() => _RecentFilesState();
}

class _RecentFilesState extends State<RecentFiles> {


  final results=[
    {
      "icon": "assets/images/cbz.png",
      "title": "Borrowdale",
      "grade": "Denied",
      "size":"20USD",
      "date": "Pending"
    },
    {
      "icon": "assets/images/cbz.png",
      "title": "Borrowdale",
      "grade": "Paid",
      "size":"20USD",
      "date": "Done"
    },
    {
      "icon": "assets/images/cbz.png",
      "title": "Greendale",
      "grade": "Paid",
      "size":"40USD",
      "date": "Denied"
    }
  ];

  late SharedPreferences logindata;
  late String email = "";
  late String token = "";
  late String proLink = "";
  bool top_prices_isLoading = true;
  List<TopFivePrices> topprices_data2 = <TopFivePrices>[];

  @override
  void initState() {
    super.initState();
    initial_state();
  }

  void initial_state() async {
    logindata = await SharedPreferences.getInstance();
    email = logindata.getString('email') ?? '';
    token = logindata.getString('token') ?? '';
    print('this is the token $token');
    print('this is the email $email');
    final url = Uri.parse(ip_address3 + 'api/v1/userz/myproperty_stats');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = json.encode({
      "email": email,
    });

    print('Sending POST request for top five prices');
    final response = await http.post(url, headers: headers, body: body);

    print('Waiting for response');
    if (response.statusCode == 200) {
      print("Success");
      final jsonData = json.decode(response.body) as List<dynamic>;
      topprices_data2.assignAll(jsonData
          .map((item) => TopFivePrices.fromJson(item as Map<String, dynamic>)));
      setState(() {
        top_prices_isLoading = false;
      });
    }
  }


  @override
  @override
  Widget build(BuildContext context) {
    return top_prices_isLoading
        ? Center(
      child: AvatarGlow(
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
    )
        : Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "My Applications",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              SizedBox(width: 100),
              Expanded(
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        "See All",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.green.shade700,
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Icon(Icons.send, color: Colors.blue),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              horizontalMargin: 0,
              columnSpacing: defaultPadding,
              columns: [
                DataColumn(
                  label: Text(
                    "Location",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.015,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Application \n Status",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.015,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Fee \n Amount",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.015,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Fee Status",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.015,
                    ),
                  ),
                ),
              ],
              rows: List.generate(
                topprices_data2.length,
                    (index) => recentFileDataRow(topprices_data2[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//DataRow recentFileDataRow(RecentFile fileInfo) {
  DataRow recentFileDataRow(TopFivePrices fileInfo) {
    print('regai tipedzerane');
  print(fileInfo);
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(fileInfo.address,style: TextStyle(
                  fontSize: 10
              ),overflow: TextOverflow.ellipsis, maxLines: 2),
            ),

          ],
        ),
      ),
    //  DataCell(Text(fileInfo.size!)),
      DataCell(
          Text(
            'Pending',
            style: TextStyle(fontSize: 10),
          )

      ),
      DataCell(Text(fileInfo.amount,style: TextStyle(fontSize: 10),)),
      DataCell(Text("Pending",style: TextStyle(fontSize: 10),)),

    ],
  );
}

DataRow recentFileDataRow2(Map<String, dynamic> fileInfo) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(
                fileInfo['title'],
                style: TextStyle(fontSize: 10),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
      DataCell(
        Text(
          fileInfo['grade'],
          style: TextStyle(fontSize: 10),
        ),
      ),
      DataCell(
        Text(
          fileInfo['size'],
          style: TextStyle(fontSize: 10),
        ),
      ),
      DataCell(
        Text(
          fileInfo['date'],
          style: TextStyle(fontSize: 10),
        ),
      ),
    ],
  );
}
