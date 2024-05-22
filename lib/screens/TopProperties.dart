import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MySlider3 extends StatelessWidget {
  const MySlider3({
    Key? key
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {

    late List<String> imgList = [
      'https://f99e-2c0f-f8f0-d348-0-d018-1143-f6ec-a987.ngrok-free.app/houses/1.jpg',
      'https://f99e-2c0f-f8f0-d348-0-d018-1143-f6ec-a987.ngrok-free.app/houses/2.jpg',
      'https://f99e-2c0f-f8f0-d348-0-d018-1143-f6ec-a987.ngrok-free.app/houses/3.jpg',
      'https://f99e-2c0f-f8f0-d348-0-d018-1143-f6ec-a987.ngrok-free.app/houses/4.jpg',
      'https://f99e-2c0f-f8f0-d348-0-d018-1143-f6ec-a987.ngrok-free.app/houses/5.jpg',

    ];



    late List<Widget> imageSliders = imgList
        .map((item) => Container(
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[
                Image.network(item, fit: BoxFit.cover, width: 1000.0),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child:/* Text(
                      'No. ${imgList.indexOf(item)} image',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),*/
                    Text(
                      '1233 4th Street, 5th Avenue, New York, USA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ),
                ),
              ],
            )),
      ),
    ))
        .toList();



    return  Container(
      height:MediaQuery.of(context).size.height/5,
      width:double.infinity,
// color: Colors.orange,
      child:Container(
        child: CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            height:MediaQuery.of(context).size.height/5,
            aspectRatio: 2.0,
            enlargeCenterPage: true,
            autoPlayCurve: Curves.fastOutSlowIn,
          ),
          items: imageSliders,
        ),
      ),
    );
  }
}