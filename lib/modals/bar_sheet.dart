import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Radius _default_bar_top_radius = Radius.circular(15);

class BarBottomSheet extends StatelessWidget {
  final Widget child;
  final Widget control;
  final Clip clipBehavior;
  final double elevation;
  final ShapeBorder shape;

  const BarBottomSheet(
      {Key key,
      this.child,
      this.control,
      this.clipBehavior,
      this.shape,
      this.elevation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 12),
            SafeArea(
              bottom: false,
              child: control ??
                  Container(
                    height: 6,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)),
                  ),
            ),
            SizedBox(height: 8),
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: Material(
                shape: shape ??
                    RoundedRectangleBorder(
                      side: BorderSide(),
                      borderRadius: BorderRadius.only(
                          topLeft: _default_bar_top_radius,
                          topRight: _default_bar_top_radius),
                    ),
                clipBehavior: clipBehavior ?? Clip.hardEdge,
                elevation: elevation ?? 2,
                child: SizedBox(
                  width: double.infinity,
                  child: MediaQuery.removePadding(
                      context: context, removeTop: true, child: child),
                ),
              ),
            ),
          ]),
    );
  }
}

class BarSheetRoute extends SheetRoute {


  BarSheetRoute({
    @required WidgetBuilder builder,
    Color backgroundColor,
    double elevation,
    ShapeBorder shape,
    double closeProgressThreshold,
    Clip clipBehavior,
    Color barrierColor = Colors.black87,
    bool bounce = true,
    bool expand = false,
    AnimationController secondAnimation,
    Curve animationCurve,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    Widget topControl,
    Duration duration,
  }) : super(
          builder: (context) => BarBottomSheet(
            child: Builder(
              builder: builder,
            ),
            control: topControl,
            clipBehavior: clipBehavior,
            shape: shape,
            elevation: elevation,
          ),
          bounce: bounce,
          closeProgressThreshold: closeProgressThreshold,
          secondAnimationController: secondAnimation,
          expanded: expand,
          isDismissible: isDismissible,
          modalBarrierColor: barrierColor,
          enableDrag: enableDrag,
          animationCurve: animationCurve,
          duration: duration,
        );
}
