import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModalInsideModal extends StatelessWidget {
  final bool reverse;

  const ModalInsideModal({Key key, this.reverse = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          leading: Container(), middle: Text('Modal Page')),
      child: SafeArea(
        bottom: false,
        child: ListView(
          reverse: reverse,
          shrinkWrap: true,
          controller: DefaultSheetController.of(context).scrollController,
          physics: BouncingScrollPhysics(),
          children: ListTile.divideTiles(
              context: context,
              tiles: List.generate(
                100,
                (index) => ListTile(
                  title: Text('Item $index'),
                  onTap: () => Navigator.of(context).push(
                    CupertinoSheetRoute(
                      builder: (context) => ModalInsideModal(reverse: reverse),
                    ),
                  ),
                ),
              )).toList(),
        ),
      ),
    ));
  }
}
