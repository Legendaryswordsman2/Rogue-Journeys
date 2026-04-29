import 'package:flutter/material.dart';

class CollapsibleBox extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CollapsibleBoxState();
}

class _CollapsibleBoxState extends State<CollapsibleBox>{
  bool expanded = false;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              expanded = !expanded;
            });
          },
          child: Text("Toggle"),
        ),
        AnimatedCrossFade(
          firstChild: Container(
            height: 0,
          ),
          secondChild: Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey.shade200,
            child: Text("Expanded content"),
          ),
          crossFadeState: expanded
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
          duration: Duration(seconds: 2),
        )
      ],
    );
  }
}