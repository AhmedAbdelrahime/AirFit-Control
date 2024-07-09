import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  final String contactEmail;

  PrivacyPolicyPage({Key? key, required this.contactEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true, // Center align the title horizontally
// Set back icon color to white
// Customize app bar color
      ),
      backgroundColor: Colors.black, // Background color
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Privacy Policy for AirFit App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Welcome to AirFit! This Privacy Policy explains how we collect, use, and protect your information when you use our app.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Information Collected',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            _buildSubsection(
              title: 'Device Information',
              description:
                  'We collect information about your device, such as device model, operating system version, and unique device identifiers.',
            ),
            _buildSubsection(
              title: 'Usage Information',
              description:
                  'We gather data on how you interact with our app, including feature usage and settings preferences.',
            ),
            _buildSubsection(
              title: 'Bluetooth Data',
              description:
                  'If you connect AirFit to Bluetooth-enabled devices for air suction, we collect data related to device connectivity and operation.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Data Usage',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We use the collected information for operational purposes, personalizing your experience, and facilitating Bluetooth communication with air suction devices.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Data Protection',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We are committed to protecting your data and employ security measures to safeguard it against unauthorized access or disclosure.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'User Rights',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'You have the right to access, update, or delete your personal information. You can also opt-out of certain data collection activities through app settings.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Changes to Privacy Policy',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We may update this Privacy Policy occasionally. We will notify you about significant changes through app notifications or email.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Contact Us',
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
            SizedBox(height: 16.0),
            Text(
              'Legal Compliance',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "Our Privacy Policy complies with relevant data protection laws, including but not limited to the General Data Protection Regulation (GDPR), California Consumer Privacy Act (CCPA), Personal Information Protection and Electronic Documents Act (PIPEDA), Children's Online Privacy Protection Act (COPPA), and Data Protection Act 2018.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubsection(
      {required String title, required String description}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          description,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 8.0),
      ],
    );
  }
}
