import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';


class LottieFiles {
  Widget winsplash() {
    return Center(
      child: Lottie.asset('assets/jsons/winsplash.json', width: double.infinity, fit: BoxFit.fitWidth,repeat: false,animate: true ),
    );
  }
}
