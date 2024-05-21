

import 'package:flutter/material.dart';



class CustomDevider extends StatelessWidget {
 // const Footer({Key? key}) : super(key: key);
  const CustomDevider({
    Key? key,
   required this.height,
    required this.thickness,
    required this.color,
    required this.indent,
    required this.endIndent,


  }) : super(key: key);

  final double height;
  final double thickness;

  final Color color;
  final double indent;
  final double endIndent;




  @override
  Widget build(BuildContext context) {
    return  Divider(
      height:height,
      thickness: thickness,
      color: color,
      indent: indent,
      endIndent: endIndent,
    );
  }
}