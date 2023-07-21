import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutterdemo/pages/splash_page.dart';
import 'package:flutterdemo/utils/DioUtils.dart';

void main() {
  DioUtils.initDioOptions();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
      builder: EasyLoading.init(),
    );
  }
}
