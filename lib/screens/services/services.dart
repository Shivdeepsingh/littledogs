import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Services extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ServicesState();
  }
}

class ServicesState extends State<Services> {
  List<Widget> _sliderImages() {
    List<Widget> _image = [];

    _image.add(Container(
      child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Services()),
            );
          },
          child: Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5)),
            child: Column(
              children: [
                Container(
                    child: Image.asset(
                      "assets/grooming.png",
                      width: MediaQuery.of(context).size.width,
                   height:  400,
                )),
                Container(
                  child: Text(
                    "Grooming",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          )),
    ));
    _image.add(Container(
      child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Services()),
            );
          },
          child: Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5)),
            child: Column(
              children: [
                Container(
                    child: Image.asset(
                      "assets/vet.jpg",
                      width: MediaQuery.of(context).size.width,
                      height:  400,
                    )),
                Container(
                  child: Text(
                    "Online Vet",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          )),
    ));
    _image.add(Container(
      child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Services()),
            );
          },
          child: Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5)),
            child: Column(
              children: [
                Container(
                    child: Image.asset(
                      "assets/training.png",
                      width: MediaQuery.of(context).size.width,
                      height:  400,
                    )),
                Container(
                  child: Text(
                    "Training",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          )),
    ));

    return _image;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white10,
        title: Text(
          "Services",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 0.99,
                autoPlay: true,  autoPlayInterval: Duration(seconds: 8
              ),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.slowMiddle,
                enlargeCenterPage: true,),
              items: _sliderImages()
            )
          ],
        ),
      ),
    );
  }
}
