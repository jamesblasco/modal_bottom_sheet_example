


import 'package:flutter/widgets.dart';
import 'package:modal_bottom_sheet_example/routes_example.dart';

class SlideRoute<T> extends PageRoute<T> {
  SlideRoute({
    required this.effect,
    required this.builder,
    this.maintainState = false,
    RouteSettings? settings,
  }) : super(settings: settings);

  final TransitionEffect effect;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  final WidgetBuilder builder;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return effect.buildPreviousRouteTransition(
      context,
      secondaryAnimation,
      child,
    );
  }

  @override
  bool useNextRouteProxyTransition(Route<dynamic> nextRoute) {
    return nextRoute is PageRoute<T>;
  }

  @override
  Widget getNextRouteProxyTransition(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  ) {
    return effect.buildUpcomingRouteTransition(
      context,
      animation,
      child,
    );
  }

  @override
  final bool maintainState;

  @override
  Duration get transitionDuration => effect.duration;
}


class SlidePage<T> extends Page<T> {
  SlidePage({
    required this.effect,
    required this.child,
    LocalKey? key,
  }) : super(key: key);

  final TransitionEffect effect;

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    return SlideRoute<T>(
      effect: effect,
      builder: (BuildContext context) => child,
      settings: this,
    );
  }
}
