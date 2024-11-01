import 'package:flutter/material.dart';
import 'AccountPage.dart';
import 'FAQPage.dart';
import 'ContactUsPage.dart';
import 'MapPage.dart';

void main() {
  runApp(MaterialApp(
    home: UserHomePage(),
  )
  );
}

class UserHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PureFlow'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHomeWidget(
              context,
              title: 'Recent News',
              icon: Icons.article,
              onTap: () {
                // Navigate to News Page (implement separately)
              },
            ),
            _buildHomeWidget(
              context,
              title: 'Water Status',
              icon: Icons.water_damage,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapPage()),
                );
              },
            ),
            _buildHomeWidget(
              context,
              title: 'Contact Us',
              icon: Icons.contact_mail,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactUsPage()),
                );
              },
            ),
            _buildHomeWidget(
              context,
              title: 'FAQ',
              icon: Icons.help,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FAQPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeWidget(BuildContext context,
      {required String title,
      required IconData icon,
      required Function() onTap}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, size: 36.0),
        title: Text(title, style: TextStyle(fontSize: 18.0)),
        onTap: onTap,
      ),
    );
  }
}
