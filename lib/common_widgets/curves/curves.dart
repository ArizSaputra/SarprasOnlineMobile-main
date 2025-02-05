import 'package:flutter/material.dart';

class CustomCurves extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);

    final firstCurve = Offset(0, size.height - 20);
    final secondCurve = Offset(30, size.height - 20);
    path.quadraticBezierTo(firstCurve.dx, firstCurve.dy, secondCurve.dx, secondCurve.dy);
    // final firstCurve = Offset(0, size.height - 0);
    // final secondCurve = Offset(0, size.height - 100);
    // path.quadraticBezierTo(firstCurve.dx, firstCurve.dy, secondCurve.dx, secondCurve.dy);

    final secondFirstCurve = Offset(0, size.height-20);
    final secondSecondCurve = Offset(size.width-30, size.height-20);
    path.quadraticBezierTo(secondFirstCurve.dx, secondFirstCurve.dy, secondSecondCurve.dx, secondSecondCurve.dy);
    // final secondFirstCurve = Offset(0, size.height-0);
    // final secondSecondCurve = Offset(size.width-100, size.height-20);
    // path.quadraticBezierTo(secondFirstCurve.dx, secondFirstCurve.dy, secondSecondCurve.dx, secondSecondCurve.dy);

    final thirdFirstCurve = Offset(size.width, size.height-20);
    final thirdSecondCurve = Offset(size.width, size.height);
    path.quadraticBezierTo(thirdFirstCurve.dx, thirdFirstCurve.dy, thirdSecondCurve.dx, thirdSecondCurve.dy);
    // final thirdFirstCurve = Offset(size.width, size.height-20);
    // final thirdSecondCurve = Offset(size.width, size.height-100);
    // path.quadraticBezierTo(thirdFirstCurve.dx, thirdFirstCurve.dy, thirdSecondCurve.dx, thirdSecondCurve.dy);
    
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
