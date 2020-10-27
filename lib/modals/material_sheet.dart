import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class MaterialSheetRoute extends SheetRoute {

  MaterialSheetRoute({
    @required WidgetBuilder builder,
    Color backgroundColor,
    double elevation,
    ShapeBorder shape,
    Clip clipBehavior,
    Color barrierColor = Colors.black87,
    bool expand = false,
    Curve animationCurve,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    List<double> stops,
    double initialStop = 1,
    Duration duration,
  }) : super(
          builder: (context) => Material(
            child: Builder(
              builder: builder,
            ),
            color: backgroundColor,
            clipBehavior: clipBehavior ?? Clip.none,
            shape: shape,
            elevation: elevation ?? 1,
          ),
          stops: stops,
          initialStop: initialStop,
          expanded: expand,
          barrierDismissible: isDismissible,
          barrierColor: barrierColor,
          draggable: enableDrag,
          animationCurve: animationCurve,
          duration: duration,
        );
}
