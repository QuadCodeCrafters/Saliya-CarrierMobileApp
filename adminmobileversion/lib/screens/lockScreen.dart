import 'package:adminmobileversion/screens/mainMenu.dart';
import 'package:flutter/material.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';
class Recoveryscreen extends StatefulWidget{
  @override
  State<Recoveryscreen> createState() => _RecoveryscreenState();
}

class _RecoveryscreenState extends State<Recoveryscreen> {
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Theme.of(context).primaryColor),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('')),
        body: Container(
       // color: Colors.teal,
        width: 500.0,
        height: 500.0,
       // padding: const EdgeInsets.all(45.0),
        alignment: Alignment.center,
        margin: EdgeInsets.all(10.0),//to move the container
        child: Column(
          children: [
            Text(
                  'Application Locked',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                 SizedBox(height: 20), // Spacing between label and text box
                
                // Text Box (TextField)
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Password',
                  ),
                  obscureText: true, // Hide text input (like a password field)
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: SizedBox(
                  
                  child: ElevatedButton(
                  onPressed: () {
                     Navigator.push(context,MaterialPageRoute(
                builder: (context)=>HomeScreen(),
                 ));
                  },
                  child: Text('Unlock'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    backgroundColor: const Color.fromARGB(255, 29, 69, 139), // Button color
                    foregroundColor: Colors.white, // Text color
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
                 ),
                ),
                 
          ],  
        ),
        
      ),

    );
  }
}