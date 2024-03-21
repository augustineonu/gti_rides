import 'package:flutter/material.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:shimmer/shimmer.dart';

Widget boxShimmer({double? height}) {
  return Padding(
    // padding: EdgeInsets.symmetric(vertical: context.height * 0.1),
    padding: const EdgeInsets.symmetric(vertical: 10),
    // child: Center(child: centerLoadingIcon()),
    child: Shimmer.fromColors(
        baseColor: grey1.withOpacity(0.1),
        highlightColor: grey3.withOpacity(0.2),
        child: Container(
          height: height,
          decoration: const BoxDecoration(
            color: grey1,
          ),
        )),
  );
}

Widget driverCardShimmer({double? height}) {
  return Padding(
    // padding: EdgeInsets.symmetric(vertical: context.height * 0.1),
    padding: const EdgeInsets.symmetric(vertical: 8),
    // child: Center(child: centerLoadingIcon()),
    child: Shimmer.fromColors(
      baseColor: grey1.withOpacity(0.1),
      highlightColor: grey3.withOpacity(0.2),
      child: Container(
        padding: EdgeInsets.all(5),
        height: height,
        decoration: const BoxDecoration(
          color: grey1,
        ),
        
      ),
    ),
  );
}
