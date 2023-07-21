import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:flutterdemo/common/Api.dart';

import '../../utils/DioUtils.dart';
import '../../widget/ListViewItem.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage>
    with AutomaticKeepAliveClientMixin {
  late EasyRefreshController _controller;
  List<Map> list = [];
  final JavascriptRuntime javascriptRuntime = getJavascriptRuntime();

  @override
  void initState() {
    super.initState();
    getData(true);
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      controller: _controller,
      header: const ClassicHeader(),
      footer: const ClassicFooter(),
      onRefresh: () {
        getData(false);
      },
      // onLoad: () async {
      //   await Future.delayed(const Duration(seconds: 1));
      //   if (!mounted) {
      //     return;
      //   }
      //   _controller.finishLoad(IndicatorResult.success);
      //   // setState(() {
      //   //   _count += 5;
      //   // });
      //   // _controller.finishLoad(
      //   //     _count >= 20 ? IndicatorResult.noMore : IndicatorResult.success);
      // },
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.25,
        ),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return ListViewItem(list[index], context);
        },
      ),
    );
  }

  Future<void> getData(bool isFirst) async {
    if (isFirst) {
      EasyLoading.show(status: '加载中...');
    }
    list = [];
    DioUtils.getList(Api.baseUrl).then((value) {
      setState(() {
        list = value;
      });
      if (isFirst) {
        EasyLoading.dismiss();
      } else {
        _controller.finishRefresh();
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
