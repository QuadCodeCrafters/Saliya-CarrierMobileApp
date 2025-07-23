import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue.shade900, Colors.blue.shade700],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.string(
                      '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g data-name="27.Question"><path d="M12 24a12 12 0 1 1 12-12 12.013 12.013 0 0 1-12 12zm0-22a10 10 0 1 0 10 10A10.011 10.011 0 0 0 12 2z"/><path d="M13 16h-2v-4h1a3 3 0 1 0-3-3H7a5 5 0 1 1 6 4.9zM11 18h2v2h-2z"/></g></svg>''',
                      height: 120,
                      color: Colors.white,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Help and support',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [const Color.fromARGB(255, 250, 250, 250), Color.fromARGB(255, 250, 250, 250)],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildFAQSection(context),
                    SizedBox(height: 24),
                    _buildContactSupport(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection(BuildContext context) {
    final faqs = [
      {
        'question': 'Inability to get the current location',
        'answer':
            'Having trouble finding your location? Make sure location services are turned on for this app in your device settings.',
      },
      {
        'question': 'Could not see the data after reseting the application',
        'answer':
            'The app may be having trouble retrieving data from our servers after the reset.You may need to re-login to the app to re-establish your connection and access your data.',
      },
      {
        'question': 'Sometimes the current location is not accurate',
        'answer':
            'Yes, Move to an area with better GPS reception (outdoors, open space).',
      },
      {
        'question': 'Location services does not work. Even when I turn on the device location',
        'answer':
            'Location permission denied: If you deny location permission to an app, it will not be able to access your location information.Incorrect permission level: Some apps may require precise location access, while others can function with approximate location. Granting the appropriate permission level is crucial.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frequently Asked Questions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color:Colors.blue.shade900,
          ),
        ),
       SizedBox(height: 16),
        ...faqs.map((faq) {
          return Card(
  margin: EdgeInsets.only(bottom: 16),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),
  ),
  child: Theme(
    data: Theme.of(context).copyWith(
      dividerColor: Colors.transparent, // Removes the line
    ),
    child: ExpansionTile(
      title: Text(
        faq['question']!,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade900,
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            faq['answer']!,
            style: TextStyle(color: Colors.blue.shade900),
          ),
        ),
      ],
    ),
  ),
);

        }).toList(),
      ],
    );
  }

  Widget _buildContactSupport() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Still need help?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
            ),
            SizedBox(height: 16),
            _buildContactOption(
              icon: Icons.email,
              title: 'Email Support',
              subtitle: 'support@example.com',
              onTap: () => _launchURL('mailto:support@example.com'),
            ),
            Divider(),
            _buildContactOption(
              icon: Icons.phone,
              title: 'Phone Support',
              subtitle: '+1 (555) 123-4567',
              onTap: () => _launchURL('tel:+15551234567'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade700),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }
}
