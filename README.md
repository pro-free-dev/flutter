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
            child: CarHomePage()),
      ),
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(primarySwatch: Colors.green),
      routes: {
        'car_home': (BuildContext context) => CarHomePage(),
        'car_list': (BuildContext context) => CarList(),
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

## 状态
### Provider
使用Provider进行状态管理，有三种状态`全局状态` `页面状态` `组件状态(模块状态)`。 `全局状态`跨页面共享，**RN**中的**时间**、**地点**、**用户状态**等是全局共享。
```dart
/// [Car]入口文件代码
/// * [全局状态] MultiProvider 构建全局共享状态
/// * [页面状态] 构建路由时，使`ChangeNotifierProvider.create`构建
/// * [组件状态] TODO
class CarIndex extends StatelessWidget {
  const CarIndex({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // PageRouteObserverProvider.of(context).data['initPage'] ?? '/'
    dynamic parameters;

    return MultiProvider(
        providers: [
          ChangeNotifierProvider<CarCommonDateModel>(
              create: (_) => CarCommonDateModel(context, urlParams: parameters))
        ],
        child: MaterialApp(
          initialRoute: 'car_home_page',
          routes: {
            'car_home_page': (BuildContext context) => ChangeNotifierProvider(
                  create: (_) =>
                      CarHomePageViewModel(context, urlParams: parameters),
                  child: CarPage(child: CarHomePage()),
                ),
            'car_list_page': (BuildContext context) => ChangeNotifierProvider(
                  create: (_) =>
                      CarListPageViewModel(context, urlParams: parameters),
                  child: CarPage(child: CarListPage()),
                )
          },
        ));
  }
}

/// 页面中使用 `Consumer` 获取对象
class CarHomePage extends StatelessWidget {
  const CarHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      floatingActionButton: Consumer<CarHomePageViewModel>(
        builder: (context, CarHomePageViewModel model, child) {
          return FloatingActionButton(
              onPressed: () => model.increment(), child: Icon(Icons.add));
        },
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [BodyWidget()]),
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
