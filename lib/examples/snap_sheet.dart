import 'package:flutter/material.dart';

class SnapSheetPageExample extends StatefulWidget {
  @override
  _SnapSheetPageExampleState createState() => _SnapSheetPageExampleState();
}

class _SnapSheetPageExampleState extends State<SnapSheetPageExample> {

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          SnapSheet(
            resized: true,
            child: Material(
              elevation: 4,
              color: Colors.red,
              child: Center(
                child: Text('hello'),
              ),
            ),
          
          )
        ],
      ),
    );
  }
}
