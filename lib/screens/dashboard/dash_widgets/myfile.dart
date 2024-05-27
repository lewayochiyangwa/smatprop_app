import 'dart:convert';


import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/global_constants.dart';
import '../../../services/dashboard_cards_controller.dart';
import '../../Login/responsive.dart';
import 'MyFiles.dart';

import 'package:http/http.dart' as http;
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';

import 'file_info_card.dart';

class MyFiles extends StatefulWidget {
  const MyFiles({
    Key? key,
  }) : super(key: key);

  @override
  State<MyFiles> createState() => _MyFilesState();
}

class _MyFilesState extends State<MyFiles> {




  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [

        SizedBox(height: defaultPadding),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 ? 1.3 : 1,
          ),
          tablet: FileInfoCardGridView(),
          desktop: FileInfoCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatefulWidget {
  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  State<FileInfoCardGridView> createState() => _FileInfoCardGridViewState();
}

class _FileInfoCardGridViewState extends State<FileInfoCardGridView> {
  List  cloudstore_info=[];
  List _assetTypes = [];
  List dash_colors =[primaryColor,Color(0xFFFFA113),Color(0xFFA4CDFF),Color(0xFF007EE5)];
  List dashboard_icons = [Image.asset('assets/images/icons8-property-50.png'),Image.asset('assets/images/icons8-cash-64.png'),
  Image.asset('assets/images/icons8-property-50.png'),Image.asset('assets/images/icons8-property-50.png')];

  late SharedPreferences logindata;
  late String clientID;
  late String strData;


  @override
  Widget build(BuildContext context) {
    final dashcard_controller =  Get.put<DashBoardCardsController>(DashBoardCardsController());
    return  Obx(() => dashcard_controller.dash_isLoading.value
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
    ))
        : GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: dashcard_controller.cloudstore_info.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: widget.childAspectRatio,
      ),
      //itemBuilder: (context, index) => FileInfoCard(info: demoMyFiles[index]),
       // itemBuilder: (context, index) => FileInfoCard(info:cloudstore_info[index]),
      itemBuilder: (context, index) {
       // if (dashcard_controller.cloudstore_info.isEmpty) {
        //  return CircularProgressIndicator(); // or any other placeholder widget
       // } else {

          return FileInfoCard(info: dashcard_controller.cloudstore_info[index]);
       // }
      },
    ));
  }
}
