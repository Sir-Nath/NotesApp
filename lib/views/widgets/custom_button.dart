import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? press;
  const CustomButton({Key? key, required this.buttonText, this.press}) : super(key: key);

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
            color: Color(0xff3454CC),
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
