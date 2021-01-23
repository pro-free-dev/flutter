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

## 路由跳转

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


### 核心概念
#### InheritedWidget
#### ChangeNotifierProvider  
#### Feature

### 
 - `ChangeNotifierProvider` VS `InheritedWidget`, 什么场景下需要使用ChangeNotifierProvider而不使用PageRouteObserverProvider

