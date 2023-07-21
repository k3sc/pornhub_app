import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:flutterdemo/common/Api.dart';
import 'package:flutterdemo/utils/OpeUtil.dart';

import '../../utils/DioUtils.dart';
import '../../widget/ListViewItem.dart';

class ListViewPage extends StatefulWidget {
  final String url;
  final String title;
  final bool showAppBar;

  const ListViewPage({
    Key? key,
    required this.url,
    required this.title,
    required this.showAppBar,
  }) : super(key: key);

  @override
  State<ListViewPage> createState() => _categoryPageState();
}

class _categoryPageState extends State<ListViewPage>
    with AutomaticKeepAliveClientMixin {
  late EasyRefreshController _controller;
  List<Map> list = [];
  final JavascriptRuntime javascriptRuntime = getJavascriptRuntime();
  var curPageIndex = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(true);
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = EasyRefresh(
        controller: _controller,
        header: const ClassicHeader(),
        footer: const ClassicFooter(),
        onRefresh: () {
          getData(false);
        },
        onLoad: () async {
          loadData();
        },
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.25,
          ),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return ListViewItem(list[index], context);
          },
        )
        // ListView.builder(
        //   itemBuilder: (context, index) {
        //     return ListViewItem(list[index], context);
        //   },
        //   itemCount: list.length,
        // ),
        );
    if (widget.showAppBar) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: body,
      );
    } else {
      return body;
    }
  }

  Future<void> loadData() async {
    setState(() {
      curPageIndex++;
    });
    var url = Api.baseUrl + widget.url + "&page=${curPageIndex}";
    if (!widget.url.contains('?')) {
      url = url.replaceAll('&page', '?page');
    }
    DioUtils.getList(url).then((value) {
      setState(() {
        if (value.length > 0) {
          list.addAll(value);
          _controller.finishLoad(IndicatorResult.success);
        } else {
          _controller.finishLoad(IndicatorResult.noMore);
        }
      });
    });
  }

  Future<void> getData(bool isFirst) async {
    if (isFirst) {
      EasyLoading.show(status: '加载中...');
    }
    list = [];
    setState(() {
      curPageIndex = 1;
    });
    var url = Api.baseUrl + widget.url + "&page=${curPageIndex}";
    if (!widget.url.contains('?')) {
      url = url.replaceAll('&page', '?page');
    }
    DioUtils.getList(url).then((value) {
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
