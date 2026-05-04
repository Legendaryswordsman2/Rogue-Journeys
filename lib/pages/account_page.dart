import 'package:flutter/material.dart';
import 'package:rogue_journeys/widgets/appbar_gradient_widget.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 200,
        centerTitle: true,
        title: Text(
          "Account",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        flexibleSpace: AppbarGradientContainer(),
      ),
      body: Center(
        child: Text("This is the Account page!"),
      ),
    );
  }
}