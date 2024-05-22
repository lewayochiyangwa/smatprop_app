
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../constants/global_constants.dart';
import '../../../services/top_five_prices.dart';





class RecentFiles extends StatelessWidget {
  const RecentFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

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


  final dashcard_controller =  Get.put<TopPricesController>(TopPricesController());
    return Obx(() => dashcard_controller.top_prices_isLoading.value

        ?  Center(child:AvatarGlow(
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
    )):Container(
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
              SizedBox(width: 100,),
              Expanded(
                child: InkWell(
                  onTap: () {
                  /*  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  PricesNavy()),

                    );*/
                    // handle tap event
                  },
                  child: Row(
                    children: [
                      Text(
                        "See All",
                       // style: Theme.of(context).textTheme.subtitle1,
                        style: TextStyle(fontStyle: FontStyle.italic,color: Colors.green.shade700),
                      ),
                      SizedBox(width: 8.0),
                      Icon(Icons.send,color: Colors.blue),
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
                  label: Text("Location",style: TextStyle(
                    fontSize:MediaQuery.of(context).size.height * 0.015,
                  ),),
                ),
                DataColumn(
                  label: Text("Application \n Status",style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.015,
                  ),),
                ),
                DataColumn(
                  label: Text("Fee \n Amount",style: TextStyle(
                    fontSize:MediaQuery.of(context).size.height * 0.015,
                  ),),
                ),
                DataColumn(
                  label: Text("Fee Status",style: TextStyle(
                    fontSize:MediaQuery.of(context).size.height * 0.015,
                  ),),
                ),

              ],
              rows: List.generate(
             //   demoRecentFiles.length,
   // dashcard_controller.topprices_data2.length,
               results.length,
                   // (index) => recentFileDataRow(dashcard_controller.topprices_data2[index]),
                    (index) => recentFileDataRow2(results[index]),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

//DataRow recentFileDataRow(RecentFile fileInfo) {
  DataRow recentFileDataRow(TopFivePrices fileInfo) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(defaultPadding * 0.75),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
               // color: info.color!.withOpacity(0.1),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
           //   child:Image.network("http://192.168.100.3:93/zam_live/assets/img/top/econet_mobile_525090174.png")
    child:Image.asset(fileInfo.icon!)
              //Text(fileInfo.icon!)
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(fileInfo.title!,style: TextStyle(
                fontSize: 10
              ),overflow: TextOverflow.ellipsis, maxLines: 2),
            ),
          ],
        ),
      ),
    //  DataCell(Text(fileInfo.size!)),
      DataCell(
          Text(
              double.parse(fileInfo.size!.toString()).toStringAsFixed(2),
            style: TextStyle(fontSize: 10),
          )

      ),
      DataCell(Text(fileInfo.date!,style: TextStyle(fontSize: 10),)),

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
