import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'shimmer_widget.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.verticalSpace,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerWidget.rectangular(
                      width: 360.w,
                      height: 370.h,
                    ),
                    16.verticalSpace,
                    ShimmerWidget.rectangular(
                      height: 150.h,
                      width: 360.w,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // ShimmerWidget.rectangular(height: 144.h),
        ],
      ),
    );
  }
}