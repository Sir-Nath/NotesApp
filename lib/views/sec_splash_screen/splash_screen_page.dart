

import 'package:flutter/material.dart';

import '../../constants/strings_constants/miscellenious/ui_string_constants.dart';
import '../widgets/custom_button.dart';

class SplashScreenPage extends StatelessWidget {
  final int currentPage;
  final String? text1;
  final String? text2;
  const SplashScreenPage({
    Key? key,
    required this.text1,
    required this.text2,
    this.currentPage = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          height: height * 0.45,
          width: width,
          child: Image.asset(
            splashScreenBackground,
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          height: height * 0.02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
                (index) => buildDot(currentPage, index),
          ),
        ),
        SizedBox(
          height: height * 0.06,
        ),
        SizedBox(
          height: height * 0.2,
          child: Column(
            children: [
              Text(
                text1!,
                textAlign: TextAlign.center,
                style:
                const TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Text(
                text2!,
                textAlign: TextAlign.center,
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        SizedBox(
          height: height * 0.08,
        ),
        const CustomButton(
          buttonText: 'Get Started',
        ),
        SizedBox(
          height: height * 0.02,
        ),
        const Text(
          'Skip',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Container buildDot(int currentPage, index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: currentPage == index
              ? Colors.black
              : Colors.black.withOpacity(0.3)),
    );
  }
}