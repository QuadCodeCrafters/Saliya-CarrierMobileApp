import 'package:adminmobileversion/screens/LoginScreen.dart';
import 'package:adminmobileversion/screens/addPassword.dart';
import 'package:adminmobileversion/screens/confirmation.dart';
import 'package:adminmobileversion/screens/createAccount.dart';
import 'package:flutter/material.dart';

class Confirmation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF1700A0), // Background color behind the image
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.5, // Control image transparency
              child: Image.asset(
                'assets/background_image.jpg', // Replace with your image path
                fit: BoxFit.cover, // Make the image cover the entire screen
              ),
            ),
          ),
          // Foreground UI elements
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 59), // Add some space at the top
                // "Let's create" and "an account" at the top center
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Text(
                        'Confirmation',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38.0,
                          fontWeight: FontWeight.bold, // Regular weight
                        ),
                      ),
                    ],
                  ),
                ),
                // Confirm Password Input Field
                SizedBox(height: 325.0),
                // Next Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00B7FF), // Button color
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Finish',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                // Cancel Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => passwords(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(10, 56),
                    backgroundColor: Color.fromARGB(226, 255, 30, 0), // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Previous',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 18),
                Center(
                  child: Text(
                    "Need any help?",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 255, 255, 255), // Change text color
                  ),
                  child: Column(
                    children: [
                      Text("Click here"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
