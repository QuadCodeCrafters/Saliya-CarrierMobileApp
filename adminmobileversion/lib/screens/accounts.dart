import 'package:adminmobileversion/screens/AboutPage.dart';
import 'package:adminmobileversion/screens/HelpPage.dart';
import 'package:adminmobileversion/screens/driverLogIn.dart';
import 'package:adminmobileversion/screens/personalInfoViewer.dart';
import 'package:adminmobileversion/sqflite_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilePage extends StatefulWidget {
   final Map<String, dynamic> passValue;
   ProfilePage(this.passValue);
     @override
  _ProfilePageWorkState createState() => _ProfilePageWorkState();
}
class _ProfilePageWorkState extends State<ProfilePage> {
  SqfliteHelper helper = SqfliteHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  automaticallyImplyLeading: false, // Removes the back arrow
  title: Text(
    'Settings',
    style: TextStyle(
      fontSize: 33, // Increases the font size
    ),
  ),
),
      body: ListView(
        children: [
          SettingsItem(
            icon: Icons.account_box,
            title: 'Personal info',
            subtitle: 'View your personal information',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmployeeProfilePage(widget.passValue)),
              );
            },
          ),
          SettingsItem(
            icon: Icons.logout_outlined,
            title: 'Log Out',
            subtitle: 'Log out from the application',
            onTap: () {
               showDialog(
    context: context,
    builder: (BuildContext context) {
      return  AlertDialog(
      title: Text('confirmation'),
      content: Text('Are you sure you want to Log out'),
      actions: <Widget>[
            ElevatedButton(
              onPressed: () => {
                Navigator.pop(context, 'Cancel')
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
               // Navigator.pop(context, 'OK')
                try{
                helper.updateLocalAccDetails("null","null",1);
              helper.updateSettings(1,0);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Driverlogin()),
              );
              }catch(e){
                print(e.toString());
              }
              },
              child: const Text('OK'),
            ),
          ],
    );
    },
   );
             
            },
          ),
          SettingsItem(
            icon: Icons.help_outline_outlined,
            title: 'Help',
            subtitle: 'Have questions? Feel free to ask',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpPage()),
              );
            },
          ),
          SettingsItem(
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'About the application',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
          ),
          SettingsItem(
            icon: Icons.data_object_rounded,
            title: 'Reset local data',
            subtitle:
                'Reset the local data of the application permanently',
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirmation'),
                    content: Text(
                        'Are you sure you want to reset the local app data? This erases the local data of your app permanently. This includes your saved event information.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          helper.deleteAppData();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Driverlogin()),
                          );
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          SettingsItem(
            icon: Icons.exit_to_app_outlined,
            title: 'Exit',
            subtitle: 'Exits the application',
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirmation'),
                    content: Text(
                        'Are you sure you want to exit this application?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => SystemNavigator.pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // Helper function to show a snackbar
  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.blueAccent),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle),
          onTap: onTap, // Make the item clickable
        ),
        Divider(),
      ],
    );
  }
}
