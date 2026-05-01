import 'package:flutter/widgets.dart';

class AppbarGradientContainer extends StatelessWidget{
  const AppbarGradientContainer({super.key});


@override
  Widget build(BuildContext context) {
    return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xff0032c4),
                Color(0xff004cda),
                Color(0xff0032c4),
              ],
            ),
          ),
        );
  }
}