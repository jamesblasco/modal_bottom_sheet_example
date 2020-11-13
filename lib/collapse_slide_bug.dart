import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_bottom_sheet_example/keynote.dart';
import 'package:modal_bottom_sheet_example/routes_example.dart';

class CollapseSlideBug extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Keynote(pages: [
      MaterialPage(
        child: HalfSlide(
          leftColor: Colors.green.withOpacity(0.5),
          left: Text('Change fast from top to bottom'),
        ),
      ),
      PageWithTransitionEffect(
        effect: TranslateTransitionEffect(
          duration: Duration(milliseconds: 2000),
          direction: TranslateTransitionDirection.bottomToTop,
        ),
        child: HalfSlide(
          rightColor: Colors.blue.withOpacity(0.5),
          right: Text('Slide 2'),
        ),
      ),
    ]);
  }
}

class HalfSlide extends StatelessWidget {
  final Widget? left;

  final Widget? right;

  final Color? leftColor;
  final Color? rightColor;

  const HalfSlide(
      {Key? key, this.left, this.right, this.leftColor, this.rightColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Slide(
      backgroundColor: Colors.transparent,
      child: Row(children: [
          Expanded(
            child: SizedBox.expand(
              child: Container(
                color: leftColor,
                alignment: Alignment.center,
                child: left,
              ),
            ),
          ),
       Expanded(
            child: SizedBox.expand(
              child: Container(
                color: rightColor,
                alignment: Alignment.center,
                child: right,
              ),
            ),
          )
      ]),
    );
  }
}
