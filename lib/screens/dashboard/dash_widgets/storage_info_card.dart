import 'package:flutter/material.dart';

import '../../../constants/global_constants.dart';



class StorageInfoCard extends StatelessWidget {
  const StorageInfoCard({
    Key? key,
    required this.title,
   // required this.svgSrc,
    required this.amountOfFiles,
   // required this.numOfFiles,
    required this.color2,
  }) : super(key: key);

  final String title, amountOfFiles;
 // final int numOfFiles;
  final Color color2;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: defaultPadding),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 12,color:color2
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        //  SizedBox(width: 30,),
          Flexible(child: Text(amountOfFiles,
            style: TextStyle(
            fontSize: 12
          ),)),

        ],
      ),
    );
  }
}
