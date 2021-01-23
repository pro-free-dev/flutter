### Router

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

### 核心概念
#### InheritedWidget
#### ChangeNotifierProvider  
#### Feature

### 
 - `ChangeNotifierProvider` VS `InheritedWidget`, 什么场景下需要使用ChangeNotifierProvider而不使用PageRouteObserverProvider

