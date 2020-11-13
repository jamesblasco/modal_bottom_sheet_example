import 'package:flutter/material.dart';

class FadeInTransitionEffect extends TransitionEffect {
  FadeInTransitionEffect({
    required this.duration,
  });

  @override
  final Duration duration;

  @override
  Widget buildPreviousRouteTransition(BuildContext context,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: ReverseAnimation(secondaryAnimation),
      child: child,
    );
  }

  @override
  Widget buildUpcomingRouteTransition(
      BuildContext context, Animation<double> animation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

enum TranslateTransitionDirection {
  topToBottom,
  bottomToTop,
  leftToRight,
  rightToLeft,
}

class TranslateTransitionEffect extends TransitionEffect {
  TranslateTransitionEffect({
    required this.duration,
    required this.direction,
  });

  @override
  final Duration duration;

  final TranslateTransitionDirection direction;

  @override
  Widget buildPreviousRouteTransition(BuildContext context,
      Animation<double> secondaryAnimation, Widget child) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return AnimatedBuilder(
          animation: secondaryAnimation,
          child: child,
          builder: (BuildContext context, Widget? child) {
            final Offset relativeOffset =
                _relativeOffset * secondaryAnimation.value;
            final Offset offset = Offset(
              -relativeOffset.dx * constraints.biggest.width,
              -relativeOffset.dy * constraints.biggest.height,
            );
            return Transform.translate(
              offset: offset,
              child: child,
            );
          },
        );
      },
    );
  }

  @override
  Widget buildUpcomingRouteTransition(
      BuildContext context, Animation<double> animation, Widget child) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return AnimatedBuilder(
          animation: animation,
          child: child,
          builder: (BuildContext context, Widget? child) {
            final Offset relativeOffset =
                _relativeOffset * (1 - animation.value);
            final Offset offset = Offset(
              relativeOffset.dx * constraints.biggest.width,
              relativeOffset.dy * constraints.biggest.height,
            );
            return Transform.translate(
              offset: offset,
              child: child,
            );
          },
        );
      },
    );
  }

  Offset get _relativeOffset {
    switch (direction) {
      case TranslateTransitionDirection.topToBottom:
        return const Offset(0, -1);
      case TranslateTransitionDirection.bottomToTop:
        return const Offset(0, 1);
      case TranslateTransitionDirection.leftToRight:
        return const Offset(-1, 0);
      case TranslateTransitionDirection.rightToLeft:
        return const Offset(1, 0);
    }
  }
}

abstract class TransitionEffect {
  Duration get duration;

  Widget buildUpcomingRouteTransition(
      BuildContext context, Animation<double> animation, Widget child);

  Widget buildPreviousRouteTransition(
      BuildContext context, Animation<double> secondaryAnimation, Widget child);
}

class RouteWithTransitionEffect<T> extends PageRoute<T> {
  RouteWithTransitionEffect({
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
    return effect.buildUpcomingRouteTransition(context, animation, child);
  }

  @override
  bool handleSecondaryAnimationTransitionForPreviousRoute(Route previousRoute) {
    return previousRoute is PageRoute<T>;
  }

  @override
  Widget buildSecondaryAnimationTransitionForPreviousRoute(
    BuildContext context,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return effect.buildPreviousRouteTransition(
        context, secondaryAnimation, child);
  }

  @override
  final bool maintainState;

  @override
  Duration get transitionDuration => effect.duration;
}

class PageWithTransitionEffect<T> extends Page<T> {
  PageWithTransitionEffect({
    required this.effect,
    required this.child,
    LocalKey? key,
  }) : super(key: key);

  final TransitionEffect effect;

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    return RouteWithTransitionEffect<T>(
      effect: effect,
      builder: (BuildContext context) => child,
      settings: this,
    );
  }
}
