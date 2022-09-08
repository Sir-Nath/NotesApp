import 'package:flutter/material.dart';
import 'package:notes/constants/strings_constants/miscellenious/ui_string_constants.dart';
import 'package:notes/views/sec_splash_screen/splash_screen_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
          width: double.infinity,
          height: height,
          child: PageView(
            onPageChanged: (value) {
              setState(() {
                currentPage = value;
              });
            },
            scrollDirection: Axis.horizontal,
            children: List.generate(
                pageDetails.length,
                (index) => SplashScreenPage(
                      text1: pageDetails[index]['text1'],
                      text2: pageDetails[index]['text2'],
                      currentPage: currentPage,
                    )),
          )),
    );
  }
}


