// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final worldPair = WordPair.random();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
            // child: Text(worldPair.asPascalCase),
            child: _LifeCycle()),
      ),
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(primarySwatch: Colors.green),
      routes: {
        'home': (BuildContext context) => _LifeCycle(),
        'PageA': (BuildContext context) => PageA(),
        'PageB': (BuildContext context) => CarTabBar(),
      },
    );
  }
}

class _LifeCycle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LifeCyclestate();
  }
}

class _LifeCyclestate extends State<_LifeCycle> {
  int count = 0;
  List<String> arrary = [];

  increment() {
    setState(() {
      count = count + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('Click counte:$count'),
      FlatButton(onPressed: () => this.increment(), child: Text('点我计数')),
      FlatButton(
          onPressed: () => {
                Navigator.pushNamed(context, 'PageA', arguments: {'age': count})
              },
          child: Text('跳转 A 页面')),
      FlatButton(
          onPressed: () => {
                Navigator.pushNamed(context, 'PageB', arguments: {'age': count})
              },
          child: Text('跳转 B 页面'))
    ]));
  }
}

class PageA extends StatelessWidget {
  int clickCount = 0;
  @override
  Widget build(BuildContext context) {
    dynamic _people = ModalRoute.of(context).settings.arguments;
    String counter = 'Total click count:$_people';
    print(_people['age']);
    // final worldPair = WordPair.random();
    return Scaffold(
        appBar: AppBar(
          title: Text('Page A'),
        ),
        body: Center(child: FlatButton(onPressed: null, child: Text(counter))));
  }
}

class PageB extends StatelessWidget {
  int clickCount = 0;
  @override
  Widget build(BuildContext context) {
    // final worldPair = WordPair.random();
    return Scaffold(
        // appBar: CarTabBar(),
        body: Center(
      child: FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('回退页面')),
    ));
  }
}

class FirstPage extends StatefulWidget {
  FirstPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _FirstPageState();
}

/// DefaultTabController (TabBar + TabBarView) 使用 (内部还是TabController实现)
class _FirstPageState extends State<FirstPage> {
  final List<Tab> myTabs = <Tab>[
    Tab(
      child: Container(
          // margin: Icons.brightness_1,
          child: Text('取车门店')),
    ),
    Tab(text: '还车门店')
  ];

  @override
  Widget build(BuildContext context) {
    // 1. 使用 DefaultTabController 作为外层控制器
    return DefaultTabController(
      length: myTabs.length, // 定义tab数量
      child: Scaffold(
        appBar: AppBar(
          // title: Text('定义TabWeight'),
          // 2. 使用 TabBar
          title: Center(
              child: TabBar(
                  indicatorColor: Colors.blue,
                  indicatorWeight: 4,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorPadding: EdgeInsets.fromLTRB(0, 0, 0, -2),
                  tabs: myTabs // 定义TabWeight,若数量和定义不一致会报错
                  )),
        ),

        // 3. 使用 TabBarViewrrr
        body: TabBarView(children: <Widget>[
          /// 全部订单
          Center(child: Text('全部订单e')),

          /// 已完成订单
          Center(child: Text('已完成')),
        ]),
      ),
    );
  }
}

class CarTabBar extends StatefulWidget {
  CarTabBar({Key key}) : super(key: key);

  @override
  _CarTabBarState createState() => _CarTabBarState();
}

class _CarTabBarState extends State<CarTabBar>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  static const List<Tab> _tabList = [
    Tab(text: '取车门店'),
    Tab(
      text: '还车门店',
    )
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabList.length, vsync: this);
    _tabController.addListener(() {
      print(_tabController.indexIsChanging);
      print(_tabController.animation.value);
      print(_tabController.previousIndex);
      print(_tabController.index);
      print('------------');
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    print('dispose');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: TabBar(
                indicatorWeight: 4,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: EdgeInsets.fromLTRB(0, 0, 0, -4),
                tabs: _tabList,
                controller: _tabController)),
        body: TabBarView(
          controller: _tabController,
          children: [
            Container(
              child: Text('AAA'),
            ),
            Container(child: Text('BBB'))
          ],
        ));
  }
}
