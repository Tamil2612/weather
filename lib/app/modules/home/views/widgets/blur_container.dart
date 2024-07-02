import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlurContainer extends StatelessWidget {
  final double height;
  final double? width;
  final Color color;
  final Widget child;

  final double radius;

  const BlurContainer({super.key, required this.height, this.width, required this.color, required this.child, this.radius = 35});

  @override
  Widget build(BuildContext context) {
    return  ClipRRect(
      borderRadius: BorderRadius.circular(radius.r),
      child: Container(
        height: height,
        width: width,
        color:
        color,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: child,
        ),
      ),
    );
  }
}
