import 'dart:convert'; //pac 2

import 'package:adminmobileversion/screens/createAccount.dart';
import 'package:adminmobileversion/screens/driverLogIn.dart';
import 'package:adminmobileversion/screens/lockScreen.dart';
import 'package:adminmobileversion/screens/mainMenu.dart';
import 'package:flutter/material.dart';
import 'package:mssql_connection/mssql_connection.dart'; //pac 1
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF1C2731), // Background color similar to the image
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Logo
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.dashboard_outlined,
                    size: 100.0,
                    color: Colors.white, // DashPress logo placeholder
                  ),
                  SizedBox(height: 10),
                  Text(
                    'AutoPlus Mobile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50.0),
            // Email Input Field
            TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF2A3B48), // Dark input background
                hintText: 'User name',
                hintStyle: TextStyle(color: Colors.white60),
                prefixIcon: Icon(Icons.account_box_rounded, color: Colors.white),
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
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF2A3B48), // Dark input background
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.white60),
                prefixIcon: Icon(Icons.lock, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 30.0),
            // Sign In Button
            ElevatedButton(
              onPressed: () async {
                 
                 try{
                  //List items = [];
                  MssqlConnection mssqlConnection = MssqlConnection.getInstance();
                  bool isConnected = await mssqlConnection.connect(
  ip: '192.168.204.42',
  port: '1433',
  databaseName: 'webEditorData',
  username: 'saliyaAdmin001',
  password: 'saliya007#',
  timeoutInSeconds: 15,
);
      if (!isConnected) {
        throw Exception('Failed to connect to the database');
      }else{
                           ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('passed')),
                      );
                      String query = "SELECT * FROM cusReview";
                      String result = await mssqlConnection.getData(query);
                      List<dynamic> reviews = jsonDecode(result);

  // Iterate over the List
  for (var review in reviews) {
   /* print('Customer Name: ${review['cusName']}');
    print('Review: ${review['review']}');
    print('Rating: ${review['rating']}');
    print('-------------------------');*/
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Customer Name: ${review['cusName']}\n Review: ${review['review']}\nRating: ${review['rating']}')),
                      );
  }
      }
   
                      
                 }catch(e){
                        ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                 }
                 /*
                 Navigator.push(context,MaterialPageRoute(
                //builder: (context)=>HomeScreen(),
                builder: (context)=>Recoveryscreen(),
                 ));
                  */
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00B7FF), // Button color
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Log In',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                 Navigator.push(context,MaterialPageRoute(
                //builder: (context)=>HomeScreen(),
                builder: (context)=>Driverlogin(),
                 ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00B7FF), // Button color
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Driver',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 30.0),
            // Add DashPress to Your Site Text
            Center(
              child: Text(
                "Haven't got an account?",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16.0,
                ),
              ),
            ),
            TextButton(
               onPressed: () {
    // Your onPressed code here
                Navigator.push(context,MaterialPageRoute(
                builder: (context)=>Createaccount(),
                ));
            },
            style: TextButton.styleFrom(
            foregroundColor: const Color.fromARGB(255, 255, 255, 255), // Change text color
            ),
            child: Column(
            children: [
              Text("Sign In"),
            ],
          ),
          )
          
          ],
        ),
      ),
    );
  }
}
