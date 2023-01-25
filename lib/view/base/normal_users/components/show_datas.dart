import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ShowDatas extends StatelessWidget {
  ShowDatas({super.key, this.data});
  Map<String, dynamic>? data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(data!["YerAdi"]),
            Text(data!["YerBilgisi"]),
            Text(data!["Lat"]),
            Text(data!["Long"])
          ],
        ),
      ),
    );
  }
}
