import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet_example/examples/cupertino_share/cupertino_share.dart';
import 'package:modal_bottom_sheet_example/modals/avatar_sheet.dart';

import 'modals/bar_sheet.dart';
import 'modals/floating_sheet.dart';
import 'examples/modal_complex_all.dart';
import 'examples/modal_fit.dart';
import 'examples/modal_inside_modal.dart';
import 'examples/modal_will_scope.dart';
import 'examples/modal_with_navigator.dart';
import 'examples/modal_with_nested_scroll.dart';
import 'examples/modal_with_scroll.dart';
import 'examples/modal_with_page_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(platform: TargetPlatform.iOS),
      title: 'BottomSheet Modals',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: CupertinoPageScaffold(
          backgroundColor: Colors.white,
          child: SizedBox.expand(
            child: SingleChildScrollView(
              primary: true,
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                        title: Text('Cupertino Photo Share Example'),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => CupertinoSharePage()))),
                    SectionTitle('STYLES'),
                    ListTile(
                      title: Text('Material fit'),
                      onTap: () => Navigator.of(context).push(
                        MaterialSheetRoute(
                          expand: false,
                          builder: (context) => ModalFit(),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text('Bar Modal'),
                      onTap: () => Navigator.of(context).push(
                        BarSheetRoute(
                          expand: false,
                          builder: (context) => ModalInsideModal(),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text('Avatar Modal'),
                      onTap: () {
                        Navigator.of(context).push(
                          AvatarSheetRoute(
                            builder: (context) => ModalInsideModal(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: Text('Float Modal'),
                      onTap: () {
                        Navigator.of(context).push(
                          FloatingSheetRoute(
                            builder: (context) => ModalFit(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: Text('Cupertino Modal fit'),
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoSheetRoute(
                            expanded: false,
                            builder: (context) => ModalFit(),
                          ),
                        );
                      },
                    ),
                    SectionTitle('COMPLEX CASES'),
                    ListTile(
                      title: Text('Cupertino Small Modal forced to expand'),
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoSheetRoute(
                            builder: (context) => ModalFit(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: Text('Reverse list'),
                      onTap: () => Navigator.of(context).push(
                        BarSheetRoute(
                          expand: false,
                          builder: (context) => ModalInsideModal(reverse: true),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text('Cupertino Modal inside modal'),
                      onTap: () => Navigator.of(context).push(
                        CupertinoSheetRoute(
                          builder: (context) => ModalInsideModal(),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text('Cupertino Modal with inside navigation'),
                      onTap: () => Navigator.of(context).push(
                        CupertinoSheetRoute(
                          builder: (context) => ModalWithNavigator(),
                        ),
                      ),
                    ),
                    ListTile(
                      title:
                          Text('Cupertino Navigator + Scroll + WillPopScope'),
                      onTap: () => Navigator.of(context).push(
                        CupertinoSheetRoute(
                          builder: (context) => ComplexModal(),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text('Modal with WillPopScope'),
                      onTap: () => Navigator.of(context).push(
                        CupertinoSheetRoute(
                          builder: (context) => ModalWillScope(),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text('Modal with Nested Scroll'),
                      onTap: () => Navigator.of(context).push(
                        CupertinoSheetRoute(
                          builder: (context) => NestedScrollModal(),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text('Modal with PageView'),
                      onTap: () => Navigator.of(context).push(
                        CupertinoSheetRoute(
                          builder: (context) => ModalWithPageView(),
                        ),
                      ),
                    ),
                    SizedBox(height: 60)
                  ],
                ),
              ),
            ),
          ),
          navigationBar: CupertinoNavigationBar(
            transitionBetweenRoutes: false,
            middle: Text('iOS13 Modal Presentation'),
            trailing: GestureDetector(
              child: Icon(Icons.arrow_forward),
              onTap: () =>
                  Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                return Scaffold(
                  body: Builder(
                    builder: (context) => CupertinoPageScaffold(
                      backgroundColor: Colors.white,
                      navigationBar: CupertinoNavigationBar(
                        transitionBetweenRoutes: false,
                        middle: Text('Normal Navigation Presentation'),
                        trailing: GestureDetector(
                          child: Icon(Icons.arrow_upward),
                          onTap: () {
                            Navigator.of(context).push(
                              CupertinoSheetRoute(
                                isDismissible: false,
                                builder: (context) => Stack(
                                  children: <Widget>[
                                    ModalWithScroll(),
                                    Positioned(
                                      height: 40,
                                      left: 40,
                                      right: 40,
                                      bottom: 20,
                                      child: MaterialButton(
                                        onPressed: () => Navigator.of(context)
                                            .popUntil((route) =>
                                                route.settings.name == '/'),
                                        child: Text('Pop back home'),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      child: Center(child: Container()),
                    ),
                  ),
                );
              })),
            ),
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(
    this.title, {
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }
}
