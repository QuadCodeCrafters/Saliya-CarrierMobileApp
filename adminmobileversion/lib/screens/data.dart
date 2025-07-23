import 'package:flutter/material.dart';

class StatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Grid UI Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage2(),
    );
  }
}

class HomePage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data handling",
              style: TextStyle(
              fontSize: 33,
              fontWeight: FontWeight.bold
            ),
            ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,  // Two tiles per row
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 1,  // Square tiles
          children: <Widget>[
            buildTile(context, "assets/Image2.png", Icons.book_outlined, "Reports"),
            buildTile(context, "assets/Image3.png", Icons.storage_rounded, "Databases"),
            buildTile(context, "assets/Image4.png", Icons.inventory_2, "Inventory"),
            buildTile(context, "assets/Image5.png", Icons.emoji_people, "Employee"),
            buildTile(context, "assets/Image6.png", Icons.monetization_on, "Financial"),
            buildTile(context, "assets/Image7.jpg", Icons.payments, "Payment requests"),
            
          ],
        ),
      ),
    );
  }

  Widget buildTile(BuildContext context, String imagePath, IconData icon, String label) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () {
          // Handle tile click
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label clicked')));
          var item = label;
          if(item == "Reports"){

          }
          else if(item == "Databases"){

          }
          else if(item == "Inventory"){

          }
          else if(item == "Employee"){

          }
          else if(item == "Financial"){

          }
          else if(item == "Payment requests"){

          }
          else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cannot proceed the opration')));
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
              image: AssetImage(imagePath),  // Load the background image
              fit: BoxFit.cover,  // Cover the entire tile with the image
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),  // Darken the image to make text more readable
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 50, color: Colors.white),  // White icon for better contrast
              SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,  // White text for contrast
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
