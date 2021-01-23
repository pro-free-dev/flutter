## 路由
### 路由定义

#### 一级入口 `namedRouters` 确定一级模块，模块下路由是业务方自定义

```dart
  Map<String, Map<Object, PageBuilder>> namedRouters = {};

  namedRouters["API / Components2"] = getTripExamplesRouters();

  namedRouters["基础框架"] = CommonEntry.getCommonRouters();

  namedRouters["租车入口"] = TripCarEntry.getRouters();
```

#### 二级入口 `routers` 业务方定义，继承自`PageConfigItem`
```dart
Map<PageConfigItem, PageBuilder> routers = {}

// PageConfigItem
class PageConfigItem {
  String desc;
  String routerPath;
  String url;
  PageConfigItemPressHandler onPress;

  PageConfigItem(this.desc, this.routerPath, {this.url = ""});

  PageConfigItem.onPress(this.desc, this.onPress);
}

// PageBuilder 最终返回的是 widget
typedef PageBuilder = Widget Function(BuildContext buildContext,
    String pageName, Map<String, dynamic> params, String uniqueId);

/// [PageBuilder] 实现方式
/// 
/// ## PageRouteObserverProvider 携程封装，继承自`InheritedWidget`
/// 
/// ## ChangeNotifierProvider
/// 
```

### 路由跳转

```dart
/// 一级入口跳转，由Common维护，使用 `URL.openURL` 的方式
/// 外链跳转 [ctrip://wireless]
await URL.openURL("/trip_flutter?flutterName=trip_flutter_debug_item_page&routerName=${entryRouter}");

/// [PageRouteObserverProvider]注册的路由获取参数
PageRouteObserverProvider.of(context).data['initPage'] ?? '/'

/// 业务内的页面跳转与回退使用[Navigator]
/// push
Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) {
                  return NewList.List();
                }));
/// or pushNamed               
Navigator.pushNamed(context, 'List', arguments: {'age': count})
/// pop
Navigator.of(context).pop();

/// 获取参数
dynamic args = ModalRoute.of(context).settings.arguments;
print(args['age']);
```

### 路由 QA
**Q** 哪些页面需要注册到二级入口，通过`PageRouteObserverProvider` 包裹起来?    
**A** 外部跳转到租车业务的页面需要注册，如有需要初始化状态的，跳转`Market`。不需要初始化`Car`状态的，可直接注册，供外部跳转。现在需要注册的有`flutter_car_home` `flutter_car_market` `flutter_car_image`。*`flutter_car`* 是租车模块固定前缀。

**Q** Car模块的路由是怎样的？   
**A**
```dart
/// lib/main.dart
namedRouters["租车入口"] = TripCarEntry.getRouters();

/// lib/car/tripcar.dart
class TripCarEntry {
  static Map<PageConfigItem, PageBuilder> getRouters() {
    Map<PageConfigItem, PageBuilder> routers = {
      PageConfigItem("租车首页", 'flutter_car_home'):
          (context, pageName, params, _) {
        return PageRouteObserverProvider(data: params, child: CarHome());
      },
      PageConfigItem("租车车型图页面", 'flutter_car_image'):
          (context, pageName, params, _) {
        return PageRouteObserverProvider(
            data: params,
            child: CarImagePage(
              params: params,
            ));
      },
    };
    return routers;
  }
}

/// lib/car/home.dart
class CarHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String initPage =
        PageRouteObserverProvider.of(context).data['initPage'] ?? '/';

    // 初始化
    // xxx
    // xxx
    return MaterialApp(
      initialRoute: initPage,
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
        'car_home': (BuildContext context) => _LifeCycle(),
        'car_list': (BuildContext context) => PageA(),
        'car_product': (BuildContext context) => CarTabBar(),
        'car_booking': (BuildContext context) => CarProviderTest(),
        'car_order_detail': (BuildContext context) => Layout(),
        'car_map': (BuildContext context) => KeyLayout(),
        'car_vendor_image': (BuildContext context) => NewList.List()
      },
    );
  }
}
```

## 概念

| Name                   | Type | Description |
| ---------------------- | ---- | ----------- |
| InheritedWidget        |      |             |
| ChangeNotifierProvider |      |             |
| Feature                |      |             |
