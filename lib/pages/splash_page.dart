import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutterdemo/pages/home.dart';
import 'package:flutterdemo/utils/DioUtils.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    login();
  }

  void login() {
    var today = DateTime.now();
    DateTime endexpireDate = DateTime.parse("2024-06-14");
    if (!today.isBefore(endexpireDate)) {
      SystemNavigator.pop();
    }
    EasyLoading.show(status: "登录中...");
    DioUtils.login().then((value) {
      EasyLoading.dismiss();
      if (value.data['success'] == 1) {
        EasyLoading.showSuccess("登录成功");
      } else {
        EasyLoading.showError("登录失败");
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
