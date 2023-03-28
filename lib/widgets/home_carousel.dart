import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final List _statements = [
    {
      "title": "Vision",
      "image_icon": 'assets/vision_icon.png',
      "desc":
          "A global leader in standards based solutions for trade and sustainable development",
    },
    {
      "title": "Mission",
      "image_icon": "assets/mission_icon.png",
      "desc":
          "To provide Standardization, Metrology and Conformity Assessment Services that safeguard customers and facilitate trade for a sustainable future"
    },
    {
      "title": "Motto",
      "image_icon": "assets/motto_icon.png",
      "desc": "Standards for Quality Life"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        // height: 100,
        child: CarouselSlider(
      options: CarouselOptions(
        viewportFraction: 0.9,
        height: 150,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
      ),
      items: _statements.map((i) {
        return Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 2.0,
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    color: Colors.white,
                    width: 50,
                    image: AssetImage(i['image_icon']),
                  ),
                  const Gap(5),
                  Text(
                    i['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const Gap(5),
                  Flexible(
                    child: Text(
                      i['desc'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          );
        });
      }).toList(),
    ));
  }
}
