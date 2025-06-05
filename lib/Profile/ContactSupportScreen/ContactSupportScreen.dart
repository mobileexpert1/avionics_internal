import 'package:avionics_internal/Constants/OnboardingTexts.dart';
import 'package:flutter/material.dart';

class ContactSupportScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          OnboardingTexts.contactSupport,
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
      ),
      body: Padding(padding: EdgeInsets.all(50), child: Container(

      )),
    );
  }
}
