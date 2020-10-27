/* import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;


const Curve _decelerateEasing = Cubic(0.0, 0.0, 0.2, 1.0);

class DraggablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DraggableScrollableSheet'),
      ),
      body: SizedBox.expand(
        child: SnapSheet(
          stops: [0.25, 0.5, 0.75, 1],
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              padding: EdgeInsets.all(20),
              color: Colors.blue[100],
              child: ListView.builder(
                controller: scrollController,
                itemCount: 25,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(title: Text('Item $index'));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

/// The signature of a method that provides a [BuildContext] and
/// [ScrollController] for building a widget that may overflow the draggable
/// [Axis] of the containing [Sheet].
///
/// Users should apply the [scrollController] to a [ScrollView] subclass, such
/// as a [SingleChildScrollView], [ListView] or [GridView], to have the whole
/// sheet be draggable.
typedef ScrollableWidgetBuilder = Widget Function(
  BuildContext context,
  ScrollController scrollController,
);

/// A container for a [Scrollable] that responds to drag gestures by resizing
/// the scrollable until a limit is reached, and then scrolling.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=Hgw819mL_78}
///
/// This widget can be dragged along the vertical axis between its
/// [minChildSize], which defaults to `0.25` and [maxChildSize], which defaults
/// to `1.0`. These sizes are percentages of the height of the parent container.
///
/// The widget coordinates resizing and scrolling of the widget returned by
/// builder as the user drags along the horizontal axis.
///
/// The widget will initially be displayed at its initialChildSize which
/// defaults to `0.5`, meaning half the height of its parent. Dragging will work
/// between the range of minChildSize and maxChildSize (as percentages of the
/// parent container's height) as long as the builder creates a widget which
/// uses the provided [ScrollController]. If the widget created by the
/// [ScrollableWidgetBuilder] does not use the provided [ScrollController], the
/// sheet will remain at the initialChildSize.
///
/// By default, the widget will expand its non-occupied area to fill available
/// space in the parent. If this is not desired, e.g. because the parent wants
/// to position sheet based on the space it is taking, the [expand] property
/// may be set to false.
///
/// {@tool snippet}
///
/// This is a sample widget which shows a [ListView] that has 25 [ListTile]s.
/// It starts out as taking up half the body of the [Scaffold], and can be
/// dragged up to the full height of the scaffold or down to 25% of the height
/// of the scaffold. Upon reaching full height, the list contents will be
/// scrolled up or down, until they reach the top of the list again and the user
/// drags the sheet back down.
///
/// ```dart
/// class HomePage extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(
///         title: const Text('DraggableScrollableSheet'),
///       ),
///       body: SizedBox.expand(
///         child: DraggableScrollableSheet(
///           builder: (BuildContext context, ScrollController scrollController) {
///             return Container(
///               color: Colors.blue[100],
///               child: ListView.builder(
///                 controller: scrollController,
///                 itemCount: 25,
///                 itemBuilder: (BuildContext context, int index) {
///                   return ListTile(title: Text('Item $index'));
///                 },
///               ),
///             );
///           },
///         ),
///       ),
///     );
///   }
/// }
/// ```
/// {@end-tool}
class SnapSheet extends StatefulWidget {
  final SnapSheetController controller;

  /// Creates a widget that can be dragged and scrolled in a single gesture.
  ///
  /// The [builder], [initialChildSize], [minChildSize], [maxChildSize] and
  /// [expand] parameters must not be null.
  const SnapSheet({
    Key key,
    this.initialChildSize = 0.5,
    this.stops = const [0.25, 1],
    this.expand = true,
    this.controller,
    @required this.builder,
  })  : assert(initialChildSize != null),
        assert(expand != null),
        assert(builder != null),
        super(key: key);

  /// The initial fractional value of the parent container's height to use when
  /// displaying the widget.
  ///
  /// The default value is `0.5`.
  final double initialChildSize;

  final List<double> stops;

  /// Whether the widget should expand to fill the available space in its parent
  /// or not.
  ///
  /// In most cases, this should be true. However, in the case of a parent
  /// widget that will position this one based on its desired size (such as a
  /// [Center]), this should be set to false.
  ///
  /// The default value is true.
  final bool expand;

  /// The builder that creates a child to display in this widget, which will
  /// use the provided [ScrollController] to enable dragging and scrolling
  /// of the contents.
  final ScrollableWidgetBuilder builder;

  @override
  _SheetState createState() => _SheetState();
}

/// A [Notification] related to the extent, which is the size, and scroll
/// offset, which is the position of the child list, of the
/// [Sheet].
///
/// [Sheet] widgets notify their ancestors when the size of
/// the sheet changes. When the extent of the sheet changes via a drag,
/// this notification bubbles up through the tree, which means a given
/// [NotificationListener] will receive notifications for all descendant
/// [Sheet] widgets. To focus on notifications from the
/// nearest [Sheet] descendant, check that the [depth]
/// property of the notification is zero.
///
/// When an extent notification is received by a [NotificationListener], the
/// listener will already have completed build and layout, and it is therefore
/// too late for that widget to call [State.setState]. Any attempt to adjust the
/// build or layout based on an extent notification would result in a layout
/// that lagged one frame behind, which is a poor user experience. Extent
/// notifications are used primarily to drive animations. The [Scaffold] widget
/// listens for extent notifications and responds by driving animations for the
/// [FloatingActionButton] as the bottom sheet scrolls up.
class SnapSheetNotification extends Notification
    with ViewportNotificationMixin {
  /// Creates a notification that the extent of a [Sheet] has
  /// changed.
  ///
  /// All parameters are required. The [minExtent] must be >= 0.  The [maxExtent]
  /// must be <= 1.0.  The [extent] must be between [minExtent] and [maxExtent].
  SnapSheetNotification({
    @required this.extent,
    @required this.minExtent,
    @required this.maxExtent,
    @required this.initialExtent,
    @required this.context,
  })  : assert(extent != null),
        assert(initialExtent != null),
        assert(minExtent != null),
        assert(maxExtent != null),
        assert(0.0 <= minExtent),
        assert(maxExtent <= 1.0),
        assert(minExtent <= extent),
        assert(minExtent <= initialExtent),
        assert(extent <= maxExtent),
        assert(initialExtent <= maxExtent),
        assert(context != null);

  /// The current value of the extent, between [minExtent] and [maxExtent].
  final double extent;

  /// The minimum value of [extent], which is >= 0.
  final double minExtent;

  /// The maximum value of [extent].
  final double maxExtent;

  /// The initially requested value for [extent].
  final double initialExtent;

  /// The build context of the widget that fired this notification.
  ///
  /// This can be used to find the sheet's render objects to determine the size
  /// of the viewport, for instance. A listener can only assume this context
  /// is live when it first gets the notification.
  final BuildContext context;

  @override
  void debugFillDescription(List<String> description) {
    super.debugFillDescription(description);
    description.add(
        'minExtent: $minExtent, extent: $extent, maxExtent: $maxExtent, initialExtent: $initialExtent');
  }
}

/// Manages state between [_SheetState],
/// [_SheetScrollController], and
/// [_SheetScrollPosition].
class SnapSheetController extends ChangeNotifier {
  _SheetScrollController _scrollController;
  final AnimationController _animationController;

  double get minExtent => _stops.first;
  double get maxExtent => _stops.last;
  final double initialExtent;

  double availablePixels = double.infinity;

  bool get isAtMin => minExtent >= _animationController.value;
  bool get isAtMax => maxExtent <= _animationController.value;
  bool get isAtStop => _stops.contains(_animationController.value);

  set currentExtent(double value) {
    assert(value != null);
    
    _animationController.value = value.clamp(minExtent, maxExtent) as double;
    notifyListeners();
  }

  double get currentExtent => _animationController.value;

  double get additionalMinExtent => isAtMin ? 0.0 : 1.0;
  double get additionalMaxExtent => isAtMax ? 0.0 : 1.0;

  /// The values in the [stops] list must be in ascending order. If a value in
  /// the [stops] list is less than an earlier value in the list, then its value
  /// is assumed to equal the previous value.
  List<double> _stops;

  bool snap;

  final bool _shouldDisposeAnimation;

  SnapSheetController({
    this.initialExtent = 0.5,
    List<double> stops,
    this.snap = true,
    TickerProvider vsync,
  })  : _shouldDisposeAnimation = true,
        this._stops = stops ?? [initialExtent],
        assert(initialExtent != null),
        assert(stops == null || stops.isNotEmpty, 'Stops can not be empty'),
        assert(stops == null || stops.first >= 0.0),
        assert(stops == null || stops.last <= 1.0),
        assert(stops == null || stops.first <= initialExtent),
        assert(stops == null || initialExtent <= stops.last),
        _animationController =
            AnimationController(vsync: vsync, value: initialExtent) {
    _scrollController = _SheetScrollController(controller: this);
  }

  SnapSheetController.withAnimationController({
    AnimationController controller,
    List<double> stops,
    this.snap = true,
  })  : _shouldDisposeAnimation = false,
        this._stops = stops ?? [controller.value],
        initialExtent = controller.value,
        assert(stops == null || stops.isNotEmpty, 'Stops can not be empty'),
        assert(stops == null || stops.first >= 0.0),
        assert(stops == null || stops.last <= 1.0),
        assert(controller != null),
        _animationController = controller {
    _scrollController = _SheetScrollController(controller: this);
  }

  @override
  void dispose() {
    if (_shouldDisposeAnimation) {
      _animationController.dispose();
    }

    _scrollController.dispose();
    super.dispose();
  }

  double closestStop(double extent) {
    return _stops.reduce((prev, curr) {
      return (curr - extent).abs() < (prev - extent).abs() ? curr : prev;
    });
  }

  int closestStopIndex(double extent) {
    return _stops.asMap().entries.toList().reduce((prev, curr) {
      return (curr.value - extent).abs() < (prev.value - extent).abs()
          ? curr
          : prev;
    }).key;
  }

  reset() {
      // jumpTo can result in trying to replace semantics during build.
      // Just animate really fast.
      // Avoid doing it at all if the offset is already 0.0.
      if (_scrollController.offset != 0.0) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 1),
          curve: Curves.linear,
        );
      }
      currentExtent = initialExtent;
  }
}

class _SheetState extends State<SnapSheet> with TickerProviderStateMixin {
  SnapSheetController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        SnapSheetController(
          stops: widget.stops,
          initialExtent: widget.initialChildSize,
          vsync: this,
        );
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_InheritedResetNotifier.shouldReset(context)) {
      _controller.reset();
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        _controller.availablePixels =
            widget.stops.last * constraints.biggest.height;
        final Widget page = AnimatedBuilder(
          animation: _controller._animationController,
          child: widget.builder(context, _controller._scrollController),
          builder: (context, child) {
            return child;
            /*  return FractionallySizedBox(
              heightFactor: _controller.currentExtent,
              child: child,
              alignment: Alignment.bottomCenter,
            ); */
          },
        );
        return widget.expand ? SizedBox.expand(child: page) : page;
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SnapSheet oldWidget) {
    if (oldWidget.stops != widget.stops) {
      _controller._stops = widget.stops;
    }
    super.didUpdateWidget(oldWidget);
  }
}

/// A [ScrollController] suitable for use in a [ScrollableWidgetBuilder] created
/// by a [Sheet].
///
/// If a [Sheet] contains content that is exceeds the height
/// of its container, this controller will allow the sheet to both be dragged to
/// fill the container and then scroll the child content.
///
/// See also:
///
///  * [_SheetScrollPosition], which manages the positioning logic for
///    this controller.
///  * [PrimaryScrollController], which can be used to establish a
///    [_DraggableScrollableSheetScrollController] as the primary controller for
///    descendants.
class _SheetScrollController extends ScrollController {
  _SheetScrollController({
    double initialScrollOffset = 0.0,
    String debugLabel,
    @required this.controller,
  })  : assert(controller != null),
        super(
          debugLabel: debugLabel,
          initialScrollOffset: initialScrollOffset,
        );

  final SnapSheetController controller;

  @override
  _SheetScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition oldPosition,
  ) {
    return _SheetScrollPosition(
        physics: physics,
        context: context,
        oldPosition: oldPosition,
        controller: controller);
  }

  @override
  void debugFillDescription(List<String> description) {
    super.debugFillDescription(description);
    description.add('controller: $controller');
  }
}

/// A scroll position that manages scroll activities for
/// [_SheetScrollController].
///
/// This class is a concrete subclass of [ScrollPosition] logic that handles a
/// single [ScrollContext], such as a [Scrollable]. An instance of this class
/// manages [ScrollActivity] instances, which changes the
/// [_DraggableSheetExtent.currentExtent] or visible content offset in the
/// [Scrollable]'s [Viewport]
///
/// See also:
///
///  * [_SheetScrollController], which uses this as its [ScrollPosition].
class _SheetScrollPosition extends ScrollPositionWithSingleContext {
  _SheetScrollPosition({
    @required ScrollPhysics physics,
    @required ScrollContext context,
    double initialPixels = 0.0,
    bool keepScrollOffset = true,
    ScrollPosition oldPosition,
    String debugLabel,
    @required this.controller,
  })  : assert(controller != null),
        super(
          physics: physics,
          context: context,
          initialPixels: initialPixels,
          keepScrollOffset: keepScrollOffset,
          oldPosition: oldPosition,
          debugLabel: debugLabel,
        );

  VoidCallback _dragCancelCallback;
  final SnapSheetController controller;
  bool get listShouldScroll => pixels > 0.0;

  @override
  bool applyContentDimensions(double minScrollExtent, double maxScrollExtent) {
    // We need to provide some extra extent if we haven't yet reached the max or
    // min extents. Otherwise, a list with fewer children than the extent of
    // the available space will get stuck.
    return super.applyContentDimensions(
      minScrollExtent - controller.additionalMinExtent,
      maxScrollExtent + controller.additionalMaxExtent,
    );
  }

  @override
  void applyUserOffset(double delta) {
    if (!listShouldScroll &&
        (!(controller.isAtMin || controller.isAtMax) ||
            (controller.isAtMin && delta < 0) ||
            (controller.isAtMax && delta > 0))) {
      addPixelDelta(-delta, context.notificationContext);
    } else {
      super.applyUserOffset(delta);
    }
  }

  @override
  void goBallistic(double velocity) {
    if (velocity == 0.0 && controller.isAtStop ||
        (velocity < 0.0 && listShouldScroll) ||
        (velocity > 0.0 && controller.isAtMax)) {
      super.goBallistic(velocity);
      return;
    }
    // Scrollable expects that we will dispose of its current _dragCancelCallback
    _dragCancelCallback?.call();
    _dragCancelCallback = null;

    if (controller.snap) {
      if (velocity <= 0.0 && controller.isAtStop) {
        super.goBallistic(velocity);
      }

      if (controller.availablePixels == 0) {
        return;
      }

      int index = controller.closestStopIndex(controller.currentExtent);

      double stop;

      if (velocity > 0 && index != controller._stops.length - 1) {
        stop = controller._stops[index + 1];
      } else if (velocity < 0 && index > 0) {
        stop = controller._stops[index - 1];
      } else {
        stop = controller._stops[index];
      }

      void _tick() {
        if ((velocity > 0 && controller.isAtMax) ||
            (velocity < 0 && controller.isAtMin)) {
          // Make sure we pass along enough velocity to keep scrolling - otherwise
          // we just "bounce" off the top making it look like the list doesn't
          // have more to scroll.
          velocity = controller._animationController.velocity +
              (physics.tolerance.velocity *
                  controller._animationController.velocity.sign);
          super.goBallistic(velocity);
          controller._animationController.stop();
        } else if (controller._animationController.isCompleted) {
          super.goBallistic(0);
        }
      }

      controller._animationController
        ..addListener(_tick)
        ..animateTo(stop, duration: Duration(milliseconds: 300))
            .whenCompleteOrCancel(
          () => controller._animationController.removeListener(_tick),
        );
    } else {
      final ScrollPhysics physics = ClampingScrollPhysics();
      final newMetrics = copyWith(pixels: controller.currentExtent);

      // The iOS bouncing simulation just isn't right here - once we delegate
      // the ballistic back to the ScrollView, it will use the right simulation.
      final Simulation simulation =
          physics.createBallisticSimulation(newMetrics, velocity);

      if (simulation == null) {
        super.goBallistic(velocity);
      } else {
        final AnimationController ballisticController =
            AnimationController.unbounded(
          debugLabel:
              objectRuntimeType(this, '_DraggableScrollableSheetPosition'),
          vsync: context.vsync,
        );
        double lastDelta = 0;
        void _tick() {
          final double delta = ballisticController.value - lastDelta;
          lastDelta = ballisticController.value;
          addPixelDelta(delta, context.notificationContext);
          if ((velocity > 0 && controller.isAtMax) ||
              (velocity < 0 && controller.isAtMin)) {
            // Make sure we pass along enough velocity to keep scrolling - otherwise
            // we just "bounce" off the top making it look like the list doesn't
            // have more to scroll.
            velocity = ballisticController.velocity +
                (physics.tolerance.velocity *
                    ballisticController.velocity.sign);
            super.goBallistic(velocity);
            ballisticController.stop();
          } else if (ballisticController.isCompleted) {
            super.goBallistic(0);
          }
        }

        ballisticController
          ..addListener(_tick)
          ..animateWith(simulation).whenCompleteOrCancel(
            ballisticController.dispose,
          );
      }
    }
  }

  @override
  Drag drag(DragStartDetails details, VoidCallback dragCancelCallback) {
    controller._animationController.stop();
    // Save this so we can call it later if we have to [goBallistic] on our own.
    _dragCancelCallback = dragCancelCallback;
    return super.drag(details, dragCancelCallback);
  }

  /// The scroll position gets inputs in terms of pixels, but the extent is
  /// expected to be expressed as a number between 0..1.
  void addPixelDelta(double delta, BuildContext context) {
    if (controller.availablePixels == 0) {
      return;
    }
    controller.currentExtent +=
        delta / controller.availablePixels * controller.maxExtent;

    SnapSheetNotification(
      minExtent: controller.minExtent,
      maxExtent: controller.maxExtent,
      extent: controller.currentExtent,
      initialExtent: controller.initialExtent,
      context: context,
    ).dispatch(context);
  }
}

/// A widget that can notify a descendent [Sheet] that it
/// should reset its position to the initial state.
///
/// The [Scaffold] uses this widget to notify a persistent bottom sheet that
/// the user has tapped back if the sheet has started to cover more of the body
/// than when at its initial position. This is important for users of assistive
/// technology, where dragging may be difficult to communicate.
class DraggableScrollableActuator extends StatelessWidget {
  /// Creates a widget that can notify descendent [Sheet]s
  /// to reset to their initial position.
  ///
  /// The [child] parameter is required.
  DraggableScrollableActuator({
    Key key,
    @required this.child,
  }) : super(key: key);

  /// This child's [Sheet] descendant will be reset when the
  /// [reset] method is applied to a context that includes it.
  ///
  /// Must not be null.
  final Widget child;

  final _ResetNotifier _notifier = _ResetNotifier();

  /// Notifies any descendant [Sheet] that it should reset
  /// to its initial position.
  ///
  /// Returns `true` if a [DraggableScrollableActuator] is available and
  /// some [Sheet] is listening for updates, `false`
  /// otherwise.
  static bool reset(BuildContext context) {
    final _InheritedResetNotifier notifier =
        context.dependOnInheritedWidgetOfExactType<_InheritedResetNotifier>();
    if (notifier == null) {
      return false;
    }
    return notifier._sendReset();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedResetNotifier(child: child, notifier: _notifier);
  }
}

/// A [ChangeNotifier] to use with [InheritedResetNotifier] to notify
/// descendants that they should reset to initial state.
class _ResetNotifier extends ChangeNotifier {
  /// Whether someone called [sendReset] or not.
  ///
  /// This flag should be reset after checking it.
  bool _shouldReset = false;

  /// Fires a reset notification to descendants.
  ///
  /// Returns false if there are no listeners.
  bool sendReset() {
    if (!hasListeners) {
      return false;
    }
    _shouldReset = true;
    notifyListeners();
    return true;
  }
}

class _InheritedResetNotifier extends InheritedNotifier<_ResetNotifier> {
  /// Creates an [InheritedNotifier] that the [Sheet] will
  /// listen to for an indication that it should change its extent.
  ///
  /// The [child] and [notifier] properties must not be null.
  const _InheritedResetNotifier({
    Key key,
    @required Widget child,
    @required _ResetNotifier notifier,
  }) : super(key: key, child: child, notifier: notifier);

  bool _sendReset() => notifier.sendReset();

  /// Specifies whether the [Sheet] should reset to its
  /// initial position.
  ///
  /// Returns true if the notifier requested a reset, false otherwise.
  static bool shouldReset(BuildContext context) {
    final InheritedWidget widget =
        context.dependOnInheritedWidgetOfExactType<_InheritedResetNotifier>();
    if (widget == null) {
      return false;
    }
    assert(widget is _InheritedResetNotifier);
    final _InheritedResetNotifier inheritedNotifier =
        widget as _InheritedResetNotifier;
    final bool wasCalled = inheritedNotifier.notifier._shouldReset;
    inheritedNotifier.notifier._shouldReset = false;
    return wasCalled;
  }
}
 */