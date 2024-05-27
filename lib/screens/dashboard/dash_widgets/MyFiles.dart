
import 'package:flutter/material.dart';

import '../../../constants/global_constants.dart';



class CloudStorageInfo {
  final String?  title, totalStorage;
  Widget svgSrc;
  final int? numOfFiles;
  final int? percentage;
  final Color? color;

   CloudStorageInfo({
    required this.svgSrc,
    this.title,
    this.totalStorage,
    this.numOfFiles,
    this.percentage,
    this.color,
  });
}

List demoMyFiles = [
  CloudStorageInfo(
    title: "Equities",
    numOfFiles: 1328,
    //svgSrc: "assets/icons/google_drive.svg",
    svgSrc:Image.asset('assets/images/icons8-property-50.png'),
    totalStorage: "1.9GB",
    color: primaryColor,
    percentage: 35,
  ),
  CloudStorageInfo(
    title: "Cash",
    numOfFiles: 1328,
   // svgSrc: "assets/icons/google_drive.svg",
    svgSrc:Image.asset('assets/images/icons8-cash-64.png'),
    totalStorage: "2.9GB",
    color: Color(0xFFFFA113),
    percentage: 35,
  ),
  CloudStorageInfo(
    title: "Properties",
    numOfFiles: 1328,
    //svgSrc: "assets/icons/one_drive.svg",
    svgSrc:Image.asset('assets/images/icons8-property-50.png'),
    totalStorage: "1GB",
    color: Color(0xFFA4CDFF),
    percentage: 10,
  ),
  CloudStorageInfo(
    title: "Unit Trust",
    numOfFiles: 5328,
    //svgSrc: "assets/icons/drop_box.svg",
    svgSrc:Image.asset('assets/images/icons8-property-50.png'),
    totalStorage: "7.3GB",
    color: Color(0xFF007EE5),
    percentage: 78,
  ),
];
