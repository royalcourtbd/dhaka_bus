import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppbarIcContainer extends StatelessWidget {
  AppbarIcContainer({super.key, required this.assetPath});
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(30),
      ),
      child: SvgPicture.asset(
        assetPath,
        width: 24,
        height: 24,
        fit: BoxFit.scaleDown,
      ),
    );
  }
}
