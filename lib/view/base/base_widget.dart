
import 'package:flutter/material.dart';

class BaseWidget extends StatelessWidget {
  BaseWidget({super.key, required this.child});
  Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          child,
        ],),
      ),
    );
  }
}