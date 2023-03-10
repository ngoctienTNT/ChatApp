import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget loadingImage(
    {required double width, required double height, double radius = 5}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
  );
}
