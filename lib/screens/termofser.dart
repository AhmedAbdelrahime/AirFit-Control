import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  final String contactEmail;

  TermsOfServicePage({Key? key, required this.contactEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms of Service',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true, // Center align the title horizontally
      ),
      backgroundColor: Colors.black, // Background color
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Terms of Service for AirFit App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '1. Introduction',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Welcome to AirFit! These Terms of Service govern your use of the AirFit app. By accessing or using the app, you agree to these terms and conditions.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '2. Use of the App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'You agree to use the AirFit app only for lawful purposes and in accordance with these Terms of Service. You must not use the app in any way that causes, or may cause, damage to the app or impairment of the availability or accessibility of the app.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '3. Modifications',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We reserve the right to modify or replace these Terms of Service at any time. Changes will be effective immediately upon posting on this page. You are responsible for regularly reviewing these terms for updates and changes.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '4. Limitation of Liability',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'In no event shall AirFit or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the app, even if AirFit or a AirFit authorized representative has been notified orally or in writing of the possibility of such damage.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '5. Governing Law',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'These Terms of Service are governed by and construed in accordance with the laws of Egypt, without regard to its conflict of law provisions.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '6. Contact Us',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              label: Text(
                'Contact us at $contactEmail',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
