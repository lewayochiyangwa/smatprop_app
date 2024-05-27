
import 'package:flutter/material.dart';


import '../../../constants/global_constants.dart';
import 'MyFiles.dart';




class FileInfoCard extends StatelessWidget {
  const FileInfoCard({
    Key? key,
    required this.info,
  }) : super(key: key);

  final CloudStorageInfo info;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue.shade100, // set the border color here
          width: 2.0, // set the border width here
        ),
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Container(
            width: 60,
            height: 15,
            child: Text(
              info.title!,
              //maxLines: 1,
              //overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize:12,

              ),
            ),
          ),
          SizedBox(height: defaultPadding),
          Flexible(
            child: ProgressLine(
              color: info.color,
              percentage: info.percentage,
            ),
          ),
          SizedBox(height:7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                info.totalStorage!,
              style: TextStyle(
                fontSize:12,

              ),
              /**  style: Theme.of(context)
                    .textTheme
                    .caption!
                //.copyWith(color: Colors.white),
                    .copyWith(color: Colors.black),*/
              ),
              Text(
                "${info.numOfFiles!<1 &&info.totalStorage !=0?1:info.numOfFiles}"+"%",
                style: TextStyle(
                    fontSize: 12
                ),
               /** style: Theme.of(context)
                    .textTheme
                    .caption!
                  //  .copyWith(color: Colors.white70),
                    .copyWith(color: Colors.black),*/
              ),

            ],
          )
        ],
      ),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color? color;
  final int? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
