import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutterdemo/common/Api.dart';
import 'package:flutterdemo/pages/detail/list_view.dart';
import 'package:html/parser.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _categoryPageState();
}

class _categoryPageState extends State<CategoryPage>
    with AutomaticKeepAliveClientMixin {
  late EasyRefreshController _controller;
  List<Map> list = [];

  @override
  void initState() {
    // TODO: implement initState
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
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.4,
        ),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return listItemWidget(list[index]);
        },
      ),
    );
  }

  void onTap(item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListViewPage(
            showAppBar: true, title: item['title'], url: item['url']),
      ),
    );
  }

  Future<void> getData(bool isFirst) async {
    if (isFirst) {
      EasyLoading.show(status: '加载中...');
    }
    list = [];
    var response = await Dio().get(Api.baseUrl + "/categories");
    var document = parse(response.toString());
    var rotating = document.querySelectorAll(".relativeWrapper");
    for (var item in rotating) {
      item = item.children[0];
      var attributes = item.attributes;
      Map map = Map();
      map['title'] = attributes['alt'];
      map['url'] = attributes['href'];
      map['img'] = item.children[0]?.attributes["src"];
      list.add(map);
    }
    setState(() {
      list;
    });
    if (isFirst) {
      EasyLoading.dismiss();
    } else {
      _controller.finishRefresh();
    }
  }

  Widget listItemWidget(item) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 10),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          onTap(item);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                offset: const Offset(4, 4),
                blurRadius: 16,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            child: Column(
              children: <Widget>[
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 2,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: "${item['img']}",
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        item['title'],
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
