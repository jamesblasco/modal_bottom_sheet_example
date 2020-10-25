import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FloatingModal extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;

  const FloatingModal({Key key, this.child, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child:  Material(
          color: backgroundColor,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(12),
          child: child,
        
      ),
    );
  }
}

class FloatingSheetRoute extends SheetRoute {
  FloatingSheetRoute({
    @required WidgetBuilder builder,
  }) : super(
          builder: (context) => FloatingModal(
            child: Builder(
              builder: builder,
            ),
          ),
          expanded: false,
        );
}
