import 'package:adminmobileversion/screens/LoginScreen.dart';
import 'package:adminmobileversion/screens/confirmation.dart';
import 'package:adminmobileversion/screens/createAccount.dart';
import 'package:flutter/material.dart';

class passwords extends StatelessWidget {
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
                        'Add your',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38.0,
                          fontWeight: FontWeight.bold, // Regular weight
                        ),
                      ),
                      Text(
                        'password',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38.0,
                          fontWeight: FontWeight.bold, // Regular weight
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 35.0), // Add space after the header
                // Username Input Field
                TextField(
                  obscureText: true,
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 255, 255, 255), // White input background
                    hintText: 'Password',
                    hintStyle: TextStyle(color: const Color.fromARGB(153, 0, 0, 0)),
                    prefixIcon: Icon(Icons.key, color: const Color.fromARGB(255, 75, 75, 75)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                // Password Input Field
                TextField(
                  obscureText: true,
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 255, 255, 255), // White input background
                    hintText: 'Confirm password',
                    hintStyle: TextStyle(color: const Color.fromARGB(153, 0, 0, 0)),
                    prefixIcon: Icon(Icons.vpn_key_outlined, color: const Color.fromARGB(255, 75, 75, 75)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                // Confirm Password Input Field
                
                // Next Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Confirmation(),
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
                    'Next',
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
                        builder: (context) => Createaccount(),
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
