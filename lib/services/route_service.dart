import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logger.dart';

RouteService get routeService => Get.find();

class RouteService extends NavigatorObserver {
  Logger logger = Logger('RouteService');
  RouteObserver<Route> routeObserver = RouteObserver<Route>();

  static final RouteService _cache = RouteService._internal();
  Route? currentRoute;

  factory RouteService() {
    return _cache;
  }

  RouteService._internal() {
    init();
  }

  void init() {
    logger.log('intialiazing route service...');
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    String name = route.settings.name ?? "";
    logger.log('route pushed: $name');
    currentRoute = route;
    // listStore.navRoutes.add(name);
    // inspect(listStore.navRoutes);
  }

  // @override
  // void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
  //   logger.log('route replaced...');
  // }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    logger.log('route removed...');
    // listStore.navRoutes.remove(route.settings.name);
    // inspect(listStore.navRoutes);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    logger.log('route popped...');
    // listStore.navRoutes.remove(route.settings.name);
    // inspect(listStore.navRoutes);
  }

  void goBack({Map<String, Object?>? result}) {
    Future.delayed(Duration.zero, () {
      Get.back(result: result);
    });
  }

  Future<dynamic>? gotoRoute(String route, {Object? arguments}) {
    logger.log('navigating to $route');
    return Get.toNamed(route, arguments: arguments);
  }

  Future<dynamic>? offAllNamed(String route, {Object? arguments}) {
    logger.log('getting off all routes and navigating to $route');
    return Get.offAllNamed(route, arguments: arguments);
  }

  Future<dynamic>? openScreen(Widget page,
      {bool fullscreenDialog = false,
      dynamic arguments,
      Transition? transition,
      Duration? duration}) {
    logger.log('opening screen');
    return Get.to(() => page,
        fullscreenDialog: fullscreenDialog,
        arguments: arguments,
        transition: transition,
        duration: duration);
  }

  Future<dynamic>? openScreenWithNavigator(
      Route<Object?> page, BuildContext context) {
    logger.log('opening screen with navigator.push');
    return Navigator.of(context).push(page);
  }

  void subscribe(RouteAware routeAware) {
    logger.log('subscribing to RouteAware...');
    if (currentRoute != null) {
      routeObserver.subscribe(routeAware, currentRoute as Route);
    }
  }

  bool willPopTo(String route) {
    // int secondToLastIndex = listStore.navRoutes.length - 2;
    // // if(currentRoute.isFirst)
    // if (listStore.navRoutes.length < 2 || secondToLastIndex.isNegative)
    //   return false;
    // return listStore.navRoutes.elementAt(secondToLastIndex) == route;

    return true;
  }

  void popOrGoto(String route, {Object? arguments}) {
    // if (listStore.navRoutes.contains(route)) {
    //   int stackSize = listStore.navRoutes.length;
    //   int stackPosition = listStore.navRoutes.lastIndexOf(route);
    //   int times = stackSize - (stackPosition + 1);
    //   logger.log(
    //       'popping to existing route in deeper nav stack... ${stackSize}, ${stackPosition}, ${times}');
    //   Get.close(times);
    // } else {
    //   logger.log('loading new route...');
    //   gotoRoute(route, arguments: arguments);
    // }
  }

  void unsubscribe(RouteAware routeAware) {
    routeObserver.unsubscribe(routeAware);
  }
}
