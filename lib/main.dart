import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet_example/routes_example.dart';
import 'package:modal_bottom_sheet_example/slide_page.dart';
import 'collapse_slide_bug.dart';
import 'keynote.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.grey),
        title: 'Keynote',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Transitions'),
          ),
          body: GridView.custom(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 600, childAspectRatio: 3),
            childrenDelegate: SliverChildListDelegate.fixed(
              [
                Tile(
                    title: 'Material Transition',
                    builder: (context) => MaterialTransition()),
                Tile(
                    title: 'Transition Defined By \nUpcoming Route',
                    builder: (context) => TransitionDefinedByUpcomingRoute()),
                Tile(
                    title: 'CurrentRouteDefinesUpcomingRouteTransition',
                    builder: (context) =>
                        CurrentRouteDefinesUpcomingRouteTransition()),
                Tile(
                    title: 'UpcomingRouteDefinesCurrentRouteTransition',
                    builder: (context) =>
                        UpcomingRouteDefinesCurrentRouteTransition()),
                Tile(
                    title: 'CollapseSlideBug',
                    builder: (context) => CollapseSlideBug())
              ],
            ),
          ),
        ));
  }
}

class Tile extends StatelessWidget {
  final String title;
  final WidgetBuilder builder;

  const Tile({Key? key, required this.title, required this.builder})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.of(context)!.push(MaterialPageRoute(builder: builder));
        },
        child: Container(
          alignment: Alignment.center,
          child: Text('$title ▶️'),
        ),
      ),
    );
  }
}

/// Simple transition with MaterialPageRoute
class MaterialTransition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Keynote(pages: [
      MaterialPage(
        key: ValueKey('Slide 1'),
        child: Slide(
          child: Text('Slide 1'),
        ),
      ),
      MaterialPage(
        key: ValueKey('Slide 2'),
        child: Slide(
          backgroundColor: Colors.black,
          child: Text(
            'Slide 2',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    ]);
  }
}

class TransitionDefinedByUpcomingRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Keynote(pages: [
      MaterialPage(
        child: Slide(
          backgroundColor: Colors.green[200],
          child: Text('Slide 1'),
        ),
      ),
      PageWithTransitionEffect(
        effect: TranslateTransitionEffect(
          duration: Duration(milliseconds: 300),
          direction: TranslateTransitionDirection.bottomToTop,
        ),
        child: Slide(
          backgroundColor: Colors.blue[200],
          child: Text('Slide 2'),
        ),
      ),
    ]);
  }
}

class CurrentRouteDefinesUpcomingRouteTransition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Keynote(pages: [
      MaterialPage(
        key: ValueKey('Slide 12'),
        child: Slide(
          child: Text('Slide 1'),
        ),
      ),
      SlidePage(
        effect: FadeInTransitionEffect(duration: Duration(seconds: 1)),
        key: ValueKey('Slide 1'),
        child: Slide(
          child: Text('Slide 1'),
        ),
      ),
      SlidePage(
        effect: TranslateTransitionEffect(
          duration: Duration(seconds: 1),
          direction: TranslateTransitionDirection.bottomToTop,
        ),
        key: ValueKey('Slide 2'),
        child: Slide(
          backgroundColor: Colors.redAccent[200],
          child: Text('Slide 2'),
        ),
      ),
      SlidePage(
        effect: TranslateTransitionEffect(
          duration: Duration(seconds: 2),
          direction: TranslateTransitionDirection.rightToLeft,
        ),
        key: ValueKey('Slide 3'),
        child: Slide(
          backgroundColor: Colors.blueAccent[200],
          child: Text('Slide 3'),
        ),
      ),
      MaterialPage(
        key: ValueKey('Slide 4'),
        child: Slide(
          backgroundColor: Colors.green[200],
          child: Text('Slide 4'),
        ),
      ),
    ]);
  }
}

class UpcomingRouteDefinesCurrentRouteTransition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Keynote(pages: [
      MaterialPage(
        key: ValueKey('Slide 1'),
        child: Slide(
          child: Text('Slide 1'),
        ),
      ),
      PageWithTransitionEffect(
        effect: FadeInTransitionEffect(duration: Duration(seconds: 1)),
        key: ValueKey('Slide 2'),
        child: Slide(
          backgroundColor: Colors.redAccent[200],
          child: Text('Slide 2'),
        ),
      ),
      PageWithTransitionEffect(
        effect: TranslateTransitionEffect(
          duration: Duration(seconds: 1),
          direction: TranslateTransitionDirection.bottomToTop,
        ),
        key: ValueKey('Slide 3'),
        child: Slide(
          backgroundColor: Colors.blueAccent[200],
          child: Text('Slide 3'),
        ),
      ),
      PageWithTransitionEffect(
        key: ValueKey('Slide 4'),
        effect: TranslateTransitionEffect(
          duration: Duration(seconds: 2),
          direction: TranslateTransitionDirection.rightToLeft,
        ),
        child: Slide(
          backgroundColor: Colors.green[200],
          child: Text('Slide 4'),
        ),
      ),
    ]);
  }
}
