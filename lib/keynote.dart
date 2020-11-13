import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet_example/routes_example.dart';
import 'package:modal_bottom_sheet_example/slide_page.dart';

class Keynote extends StatefulWidget {
  final List<Page<dynamic>> pages;

  const Keynote({Key? key, required this.pages}) : super(key: key);
  @override
  _KeynoteState createState() => _KeynoteState();
}

class _KeynoteState extends State<Keynote> {
  int _index = 0;

  final FocusNode _focusNode = FocusNode();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return KeynoteController(
      index: _index,
      length: widget.pages.length,
      navigateToIndex: (index) {
        updateToIndexIfPossible(index);
      },
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CloseButton(),
                    ...widget.pages.asMap().entries.map((entry) {
                      final index = entry.key;
                      final page = entry.value;
                      Widget child;
                      if (page is MaterialPage)
                        child = page.child;
                      else if (page is SlidePage)
                        child = page.child;
                      else if (page is PageWithTransitionEffect)
                        child = page.child;
                      else
                        child = Container(child: Text('${index + 1}'));
                      return SizedBox(
                        height: 100,
                        width: 150,
                        child: _SlidePreview(index: index, child: child),
                      );
                    })
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: RawKeyboardListener(
              onKey: _handleKeyEvent,
              focusNode: _focusNode,
              child: ClipRect(
                child: Navigator(
                  key: _navigatorKey,
                  pages: widget.pages.sublist(0, _index + 1),
                  onPopPage: (route, result) {
                    if (!route.didPop(result)) {
                      return false;
                    }
                    return true;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  updateToIndexIfPossible(int index) {
  
    if (index >= 0 && index < widget.pages.length) {
      setState(() {
        _index = index;
      });
    }
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event.runtimeType == RawKeyDownEvent) {
      int? index = {
        LogicalKeyboardKey.arrowRight: _index + 1,
        LogicalKeyboardKey.arrowLeft: _index - 1,
        LogicalKeyboardKey.arrowDown: _index + 1,
        LogicalKeyboardKey.arrowUp: _index - 1,
        LogicalKeyboardKey.digit0: 9,
        LogicalKeyboardKey.digit1: 0,
        LogicalKeyboardKey.digit2: 1,
        LogicalKeyboardKey.digit3: 2,
        LogicalKeyboardKey.digit4: 3,
        LogicalKeyboardKey.digit5: 4,
        LogicalKeyboardKey.digit6: 5,
        LogicalKeyboardKey.digit7: 6,
        LogicalKeyboardKey.digit8: 7,
        LogicalKeyboardKey.digit9: 8,
      }[event.logicalKey];

      if (index != null) {
        updateToIndexIfPossible(index);
      }
    }
  }
}

class KeynoteController extends InheritedWidget {
  final int index;
  final int length;
  final Function(int index) navigateToIndex;

  KeynoteController({
    required this.index,
    required this.length,
    required Widget child,
    required this.navigateToIndex,
  }) : super(child: child);

  bool get canNavigateNext => index < length - 1;
  bool get canNavigatePrevious => index > 0;

  void navigateNext() => navigateToIndex(index + 1);
  void navigatePrevious() => navigateToIndex(index - 1);

  static KeynoteController? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<KeynoteController>();

  @override
  bool updateShouldNotify(covariant KeynoteController oldWidget) {
    return index != oldWidget.index || length != oldWidget.length;
  }
}

class Slide extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;

  const Slide({Key? key, this.backgroundColor, required this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final controller = KeynoteController.of(context)!;
        if (controller.canNavigateNext) controller.navigateNext();
      },
      child: SizedBox.expand(
        child: Material(
          color: backgroundColor ?? Theme.of(context)!.backgroundColor,
          child: Align(
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _SlidePreview extends StatefulWidget {
  final Widget child;
  final int index;

  const _SlidePreview({Key? key, required this.index, required this.child})
      : super(key: key);

  @override
  __SlidePreviewState createState() => __SlidePreviewState();
}

class __SlidePreviewState extends State<_SlidePreview> {
  @override
  Widget build(BuildContext context) {
    final bool isSelected =
        this.isSelected ?? KeynoteController.of(context)!.index == widget.index;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
          border:
              isSelected ? Border.all(color: Colors.black, width: 2) : null),
      child: Stack(
        children: [
          IgnorePointer(
            child: widget.child,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            width: 20,
            height: 20,
            child: Container(
              alignment: Alignment.center,
              color: Colors.black,
              child: Text(
                '${widget.index + 1}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Positioned.fill(
              child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                KeynoteController.of(context)!.navigateToIndex(widget.index);
              },
            ),
          ))
        ],
      ),
    );
  }

  bool? isSelected;

  @override
  void didChangeDependencies() {
    final isSelected = KeynoteController.of(context)!.index == widget.index;
    if (this.isSelected != isSelected) {
      setState(() {
        this.isSelected = isSelected;
      });
    }
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant _SlidePreview oldWidget) {
    final isSelected = KeynoteController.of(context)!.index == widget.index;
    if (this.isSelected != isSelected) {
      setState(() {
        this.isSelected = isSelected;
      });
    }
    super.didUpdateWidget(oldWidget);
  }
}
