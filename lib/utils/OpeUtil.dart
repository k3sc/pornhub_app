import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:flutterdemo/common/Api.dart';

import '../pages/detail/VideoScreen.dart';
import '../pages/detail/video_play1.dart';
import 'DioUtils.dart';

class OpeUtil {
  static final JavascriptRuntime javascriptRuntime = getJavascriptRuntime();

  static Future<void> toVideoPage(context, item) async {
    EasyLoading.show(status: '加载中...');
    try {
      var response = await DioUtils.request(Api.baseUrl + item['url']);
      var res = response.toString();
      print(res);
      var regScript = RegExp(
              "var\\s+flashvars_\\d+\\s*=[\\s\\S]+?(?=var\\s+nextVideoPlaylistObject)")
          .firstMatch(res);
      print(regScript);
      var regScriptStr = regScript?.group(0);
      JsEvalResult jsResult = javascriptRuntime.evaluate(regScriptStr!);
      Response result = await DioUtils.request(jsResult.stringResult);
      var videoUrl = result.data[result.data.length-1]['videoUrl'];
      EasyLoading.dismiss();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoScreen(
            url: videoUrl,
          ),
        ),
      );
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
      EasyLoading.showError("加载错误");
    }
  }
}
