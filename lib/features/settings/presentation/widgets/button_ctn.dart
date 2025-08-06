import 'package:flutter/material.dart';

class VisitPortfolio extends StatelessWidget {
  const VisitPortfolio({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: 360,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: Text(
          'Visit Our Portfolio',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
