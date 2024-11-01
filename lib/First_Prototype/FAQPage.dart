import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FAQ')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text('What is PureFlow?'),
            subtitle: Text('PureFlow is a platform for monitoring water quality.'),
          ),
          ListTile(
            title: Text('How can I report a water issue?'),
            subtitle: Text('Use the Contact Us page to submit your concerns.'),
          ),
          // Add more FAQs as needed
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}
