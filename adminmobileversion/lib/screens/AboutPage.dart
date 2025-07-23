import 'dart:convert';
import 'package:adminmobileversion/mssqlDB.dart';
import 'package:flutter/material.dart';
import 'package:mssql_connection/mssql_connection.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  List<dynamic> reviews = [];
  List<dynamic>org = [];
  List<dynamic>social = [];
  List<dynamic>socialArr = [];
  bool isLoading22 = true;
  Future<void> dbProcess1() async {
    try {
      dbConn d1 = dbConn(); // Object of DB class
      MssqlConnection conn = await d1.connection(); // Get the MS SQL DB connection
      String query = "SELECT orgName,address,phone,mail,fax FROM orgInfo";
      String query2 = "SELECT link FROM socialLinks";
      String result = await conn.getData(query); // Fetch data
      String result2 = await conn.getData(query2); // Fetch data
      reviews = jsonDecode(result);
      social = jsonDecode(result2);
      if(result.isEmpty){
         setState(() => isLoading22= false);
         return;
      }
      for(var reviewHolder in reviews){
        org.add('${reviewHolder['orgName']}');
        org.add('${reviewHolder['address']}'); 
        org.add('${reviewHolder['phone']}');
        org.add('${reviewHolder['mail']}');
        org.add('${reviewHolder['fax']}');
      }
      for(var socialHolder in social){
        socialArr.add('${socialHolder['link']}');
      }
      //print(social);
      setState(() => isLoading22 = false);
    } catch (e) {
      //TODO: show the errors properly
      print(e.toString() + 'Org data obtaining');
      throw Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
    try{
      dbProcess1();
    }catch(e){
      print(e.toString());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        colors: [
          Colors.blue.shade900,
          Colors.blue.shade700,
        ],
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FadeTransition(
          opacity: _animation,
          child: Image.asset(
        'assets/AutoPlus.jpg', // Replace with your image path
        width: 160.0,
        height: 160.0,
      ),
        ),
        SizedBox(height: 10), // Space between the logo and text
        Text(
          'About Us ',
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
            child: isLoading22
        ? Center(child: CircularProgressIndicator())
        : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeCard(),
                  SizedBox(height: 24),
                  _buildSectionTitle('App Features'),
                  SizedBox(height: 16),
                  _buildFeatureCard(
                    icon: Icons.car_repair,
                    title: 'Easy Navigation',
                    description: 'Find your customer with just a few taps',
                  ),
                  _buildFeatureCard(
                    icon: Icons.notifications_active,
                    title: 'Register customer',
                    description: 'Register your customer on the go',
                  ),
                  _buildFeatureCard(
                    icon: Icons.history,
                    title: 'Pic up History',
                    description: 'Keep track of all your pic up records',
                  ),
                  SizedBox(height: 24),
                  _buildSectionTitle('Contact information'),
                  SizedBox(height: 16),
                  _buildInfoCard(
                    title:  org[0],
                    address: org[1],
                    phone: org[2],
                    email: org[3],
                    website: org[4],
                  ),
                  SizedBox(height: 24),
                  _buildSectionTitle('Connect With Us'),
                  SizedBox(height: 16),
                  _buildSocialButtons(),
                  SizedBox(height: 24),
                  _buildSectionTitle('Developed By'),
                  SizedBox(height: 16),
                  _buildInfoCard(
                    title: 'QuadCodeCrafters (Pvt) Ltd',
                    address: '20 Plam Grove, Colombo 03, Colpety, Waze',
                    phone: '+1 (555) 987-6543',
                    email: 'QuadCodeCrafters51@outlook.com',
                    website: 'www.QuadCodeCrafters.lk',
                  ),
                  SizedBox(height: 24),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return FadeTransition(
      opacity: _animation,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to Saliya Auto Care Driver App',
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
  'Your trusted companion for all your customer vehicle pic ups. We strive to provide the best experience for our drivers, ensuring the customer data are accurate.',
  style: GoogleFonts.roboto(
    textStyle: TextStyle(
      fontSize: 16,
      color: const Color.fromARGB(221, 26, 26, 26),
    ),
  ),
  textAlign: TextAlign.justify, // This aligns the text with justification
)

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.roboto(
        textStyle: TextStyle(
          color: Colors.blue.shade900,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.blue.shade900,
            size: 30,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
              fontSize: 18,
            ),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            description,
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String address,
    required String phone,
    required String email,
    required String website,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 8),
            _buildInfoRow(Icons.location_on, address),
            _buildInfoRow(Icons.phone, phone),
            _buildInfoRow(Icons.email, email),
            _buildInfoRow(Icons.language, website),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue.shade700),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
              onPressed: (){
                try{
                   launch(socialArr[0]);
                }catch(e){
                  print(e.toString());
                }
              },
              style: ElevatedButton.styleFrom(
                iconColor: Colors.white,
                shape: CircleBorder(),
                padding: EdgeInsets.all(12),
              ),
              child: Icon(
                FontAwesomeIcons.facebook,
                color: Colors.blue,
                size: 24,
              ),
            ),
            ElevatedButton(
              onPressed: () => launch(socialArr[1]),
              style: ElevatedButton.styleFrom(
                iconColor: Colors.white,
                shape: CircleBorder(),
                padding: EdgeInsets.all(12),
              ),
              child: Icon(
                FontAwesomeIcons.xTwitter,
                color: Colors.blue.shade400,
                size: 24,
              ),
            ),
            ElevatedButton(
              onPressed: () => launch(socialArr[2]),
              style: ElevatedButton.styleFrom(
                iconColor: Colors.white,
                shape: CircleBorder(),
                padding: EdgeInsets.all(12),
              ),
              child: Icon(
                FontAwesomeIcons.linkedin,
                color: Colors.blue.shade700,
                size: 24,
              ),
            ),
            ElevatedButton(
              onPressed: () => launch(socialArr[3]),
              style: ElevatedButton.styleFrom(
                iconColor: Colors.white,
                shape: CircleBorder(),
                padding: EdgeInsets.all(12),
              ),
              child: Icon(
                FontAwesomeIcons.instagram,
                color: Colors.blue.shade700,
                size: 24,
              ),
            ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String url,
    required Color color,
  }) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: FaIcon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          Text(
            'Version 1.0.0',
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '© 2024 Saliya Auto Care',
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

