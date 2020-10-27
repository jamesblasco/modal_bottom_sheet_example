import 'dart:math';

import 'package:flutter/material.dart';

class AdvancedSnapSheetPageExample extends StatefulWidget {
  @override
  _AdvancedSnapSheetPageExampleState createState() =>
      _AdvancedSnapSheetPageExampleState();
}

class _AdvancedSnapSheetPageExampleState
    extends State<AdvancedSnapSheetPageExample> with TickerProviderStateMixin {
  SheetController controller;

  @override
  void initState() {
    controller =
        SheetController(vsync: this, initialExtent: 0.3, stops: [0, 0.1, 0.3, 1]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AnimatedBuilder(
          animation: controller.animation,
          builder: (context, child) {
            return AnimatedTheme(
              data: controller.animation.value != 1
                  ? ThemeData(accentColor: Colors.grey[200])
                  : ThemeData.dark(),
              child: child,
            );
          },
          child: AppBar(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          controller.animateTo(0.1);
        },
        items: [
          BottomNavigationBarItem(
              label: 'Option 1', icon: Icon(Icons.location_city)),
          BottomNavigationBarItem(
              label: 'Option 2', icon: Icon(Icons.location_city)),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedBuilder(
                  animation: controller.animation,
                  builder: (context, child) {
                    return Positioned(
                        right: 0,
                        bottom: constraints.biggest.height *
                            min(0.3, controller.animation.value),
                        child: Container(
                          margin: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              FloatingActionButton(
                                key: Key('value'),
                                heroTag: 'ggg',
                                onPressed: null,
                              ),
                              SizedBox(height: 8),
                              FloatingActionButton(
                                onPressed: null,
                              ),
                            ],
                          ),
                        ));
                  }),
              SnapSheet(
                controller: controller,
                child: Material(
                  elevation: 4,
                  color: Colors.white,
                  child: ListView(
                    shrinkWrap: true,
                    controller: controller.scrollController,
                    physics: BouncingScrollPhysics(),
                    children: ListTile.divideTiles(
                        context: context,
                        tiles: List.generate(100, (index) {
                          if (index == 0) {
                            return Container(
                              child: Text('Location', style: Theme.of(context).textTheme.headline6,),
                              padding: EdgeInsets.all(20),
                              alignment: Alignment.center,
                            );
                          }
                          return ListTile(
                            title: Text('Item $index'),
                          );
                        })).toList(),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
