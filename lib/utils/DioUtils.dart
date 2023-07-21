import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

import '../common/Api.dart';

Dio dio = new Dio(); // 使用默认配置
var cookieJar = CookieJar();

class DioUtils {
  static initDioOptions() {
    // 配置dio实例
    dio.options.connectTimeout = 10 * 1000; //10s
    dio.options.receiveTimeout = 99 * 1000;
    dio.interceptors.add(CookieManager(cookieJar));
  }

  static Future request(String url) async {
    print('url>>>>>>>>>>>>>>>>>' + url);
    try {
      return await dio.get(url);
    } catch (e) {
      print(e);
      return e;
    }
  }

  static Future post(String url, data) async {
    try {
      return await dio.post(url, data: data);
    } catch (e) {
      print(e);
      return e;
    }
  }

  static Future<Response> login() async {
    try {
      var getIndexHtml = await DioUtils.request(Api.baseUrl);
      var res = getIndexHtml.toString();
      var regScript =
          RegExp("(?<=var\\s+TOP_BODY+\\s*=)[\\s\\S]+?}").firstMatch(res);
      var regScriptStr = regScript?.group(0);
      var json = jsonDecode(regScriptStr!);
      return await DioUtils.post(Api.baseUrl + '/front/authenticate', {
        'username': 'xxx',
        'password': 'xxx',
        'token': json['token']
      });
    } catch (e) {
      print(e);
      return await login();
    }
  }

  static Future<List<Map>> getList(String url) async {
    print('url>>>>>>>>>>>>>>>>>' + url);
    List<Map> list = [];
    try {
      Response response = await dio.get(url);
      print('response>>>>>>>>' + response.toString());
      var document = parse(response.toString());
      if (!document.toString().contains("没有发现视频")) {
        List<Element> pcVideoListItems =
            document.querySelectorAll(".pcVideoListItem");
        pcVideoListItems.removeRange(0, 4);
        for (Element pcVideoListItem in pcVideoListItems) {
          Map map = Map();
          Element? urlItem = pcVideoListItem.querySelector(".videoPreviewBg");
          map['title'] = urlItem?.attributes['title'];
          map['url'] = urlItem?.attributes['href'];
          map['img'] = pcVideoListItem
              .querySelector("img:first-child")
              ?.attributes['src'];
          map['duration'] =
              pcVideoListItem.querySelector(".duration:first-child")?.text;
          map['views'] = pcVideoListItem
              .querySelector(".views")
              ?.text
              .replaceAll("次观看", '')
              .trim();
          map['value'] = pcVideoListItem.querySelector(".value")?.text;
          list.add(map);
        }
      }
      return list;
    } catch (e) {
      return [];
    }
  }
}
