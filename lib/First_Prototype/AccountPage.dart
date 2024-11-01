import 'package:flutter/material.dart';
import 'ChangePasswordPage.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Full Name'),
              subtitle: Text('John Doe'), // Replace with actual data
            ),
            ListTile(
              title: Text('Email'),
              subtitle: Text('johndoe@example.com'), // Replace with actual data
            ),
            ListTile(
              title: Text('Password'),
              subtitle: Text('********'),
              trailing: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                  );
                },
                child: Text('Change Password'),
              ),
            ),
          ],
        ),
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
