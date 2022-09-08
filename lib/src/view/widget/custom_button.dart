import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? press;
  const CustomButton({super.key, required this.buttonText, this.press});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: press,
      child: Container(
        width: width * 0.9,
        height: height * 0.06,
        decoration: BoxDecoration(
            color: const Color(0xff3454CC),
          borderRadius: BorderRadius.circular(8)
        ),
        child: Center(
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}
