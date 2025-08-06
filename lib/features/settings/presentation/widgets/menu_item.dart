import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuItem extends StatelessWidget {
  MenuItem({super.key, required this.itemAssetPath, required this.itemTitle});
  final String itemAssetPath;
  final String itemTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 390,
      decoration: BoxDecoration(color: Colors.white60),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SvgPicture.asset(itemAssetPath, height: 22, width: 22),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              itemTitle,
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: SvgPicture.asset(
              'assets/svg/arrow_down.svg',
              height: 24,
              width: 24,
            ),
          ),
        ],
      ),
    );
  }
}
