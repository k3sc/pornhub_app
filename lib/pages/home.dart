import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutterdemo/pages/detail/list_view.dart';
import 'package:flutterdemo/pages/tab_page/category_page.dart';
import 'package:flutterdemo/pages/tab_page/index_page.dart';

class HomePage extends StatefulWidget {
  @override
  createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  int _curIndex = 0;
  late DateTime lastPopTime;
  late PageController _controller;
  var _pageList = [
    new IndexPage(),
    new ListViewPage(
      showAppBar: false,
      title: '推荐',
      url: '/recommended',
    ),
    new CategoryPage(),
  ];
  List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.home,
        color: Colors.black12,
      ),
      activeIcon: Icon(
        Icons.home,
        color: Colors.blueAccent,
      ),
      label: '首页',
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.recommend,
        color: Colors.black12,
      ),
      activeIcon: Icon(
        Icons.recommend,
        color: Colors.blueAccent,
      ),
      label: '推荐',
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.star_border,
        color: Colors.black12,
      ),
      activeIcon: Icon(
        Icons.star_border,
        color: Colors.blueAccent,
      ),
      label: '分类',
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _curIndex = 0;
    _controller = PageController(initialPage: 0);
  }

  void _pageChange(int index) {
    if (index != _curIndex) {
      setState(() {
        _curIndex = index;
      });
    }
  }

  void onTap(int index) {
    _controller.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(items[_curIndex].label!),
        ),
        body: PageView.builder(
          physics: NeverScrollableScrollPhysics(),
          //viewPage禁止左右滑动
          onPageChanged: _pageChange,
          controller: _controller,
          itemCount: _pageList.length,
          itemBuilder: (ctx, index) {
            return _pageList[index];
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _curIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          items: items,
        ),
      ),
      onWillPop: () async {
        if (lastPopTime == null ||
            DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
          lastPopTime = DateTime.now();
          EasyLoading.showInfo("再按一次退出");
          return false;
        } else {
          lastPopTime = DateTime.now();
          // 退出app
          await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          return true;
        }
      },
    );
  }
}
