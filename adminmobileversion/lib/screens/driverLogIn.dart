//import 'dart:convert';
import 'dart:async';
import 'dart:convert';

import 'package:adminmobileversion/screens/createAccount.dart';
//import 'package:adminmobileversion/screens/driverLogIn.dart';
import 'package:adminmobileversion/screens/driverMenu.dart';
import 'package:adminmobileversion/sqflite_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
//import 'package:adminmobileversion/screens/lockScreen.dart';
//import 'package:adminmobileversion/screens/mainMenu.dart';
import 'package:flutter/material.dart';
//import 'package:mssql_connection/mssql_connection.dart';
//import 'package:mysql1/mysql1.dart';
import 'package:http/http.dart' as http;

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

import 'package:provider/provider.dart';

bool logOnceChoice = false;
String booStatusChecker = "";
enum DioMethod { post, get, put, delete }
final String baseUrl = 'http://192.168.193.42:8000'; //the Main URL and changes it 
  Dio _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
class APIService {
  APIService._singleton();
  static final APIService instance = APIService._singleton();
  // Initialize Dio in the constructor
  APIService._() {
    
  }

  Future<Response> request(
    String endpoint,
    DioMethod method, {
  //  Map<String, dynamic>? param,
    String? contentType,
    dynamic formData,
  }) async {
    try {
      late Response response;
      
      switch (method) {
        case DioMethod.post:
          response = await _dio.post(endpoint);
          break;
        case DioMethod.get:
          response = await _dio.get(endpoint );
          break;
        case DioMethod.put:
          response = await _dio.put(endpoint);
          break;
        case DioMethod.delete:
          response = await _dio.delete(endpoint);
          break;
      }
      
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Connection timeout');
      case DioExceptionType.sendTimeout:
        return Exception('Send timeout');
      case DioExceptionType.receiveTimeout:
        return Exception('Receive timeout');
      case DioExceptionType.badResponse:
        return Exception('Bad response: ${e.response?.statusMessage}');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      default:
        return Exception('Network error occurred');
    }
  }
}

class Driverlogin extends StatelessWidget {
  bool? checker;
  SqfliteHelper helper = SqfliteHelper();
  final userNameController = TextEditingController();
  final idcontroller = TextEditingController();
/**
 List<dynamic>employees = [];
void fetchEmployees(BuildContext context) async{
try{
const url = 'http://192.168.204.42:8000/employees/1';
final uri = Uri.parse(url);
final response = await http.get(uri);
final body = response.body;
final json = jsonDecode(body);
employees = json['results'];
}catch(e){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: $e')),
  );
}
}
 */
Future loadingIndicator(BuildContext context){
    return showDialog(
           barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Loading'),
                    content: LinearProgressIndicator(),
                    actions: <Widget>[
                      
                    ],
                  );
                }, 
              );
}
Future errorUiSender(BuildContext context,String message){
  return showDialog(
           barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text(
                        '${message}'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,MaterialPageRoute(
                //builder: (context)=>HomeScreen(),
                builder: (context)=>Driverlogin(),
                 ));
                        },
                        child: const Text('Ok'),
                      ),
                    ],
                  );
                }, 
              );
}
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
      Image.asset(
        'assets/AutoPlus.jpg', // Replace with your image path
        width: 200.0,
        height: 200.0,
      ),
      SizedBox(height: 10),
      Text(
        'AutoPlus Driver',
        style: TextStyle(
          color: Colors.white,
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
),

            SizedBox(height: 25.0),
            // Email Input Field
            TextField(
              controller: userNameController,
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
            TextField( //TODO: login only once
              controller: idcontroller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF2A3B48), // Dark input background
                hintText: 'Identification Number (ID)',
                hintStyle: TextStyle(color: Colors.white60),
                prefixIcon: Icon(Icons.lock, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 30.0),

            ElevatedButton(
              onPressed: () async {
                 final connectivityResult = await Connectivity().checkConnectivity();
                 String netStatus = connectivityResult.toString().toString();
                 print(netStatus);
                  if (netStatus == "[ConnectivityResult.none]") { 
                    showDialog(
    context: context,
    builder: (BuildContext context){
      return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 200,
            child: Image.asset('assets/netError.png')
          ),
          const SizedBox(height: 32),
          const Text( 
            "Whoops!",
            style: TextStyle(fontSize: 16, 
              fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text( 
            "No internet connection found.",
            style: TextStyle(fontSize: 14, 
              fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text( 
            "Check your connection and try again.",
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            child: const Text("Try Again"),
            onPressed: (){
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
    } 
                    );
                  } else if(netStatus == "[ConnectivityResult.mobile]" || netStatus == "[ConnectivityResult.wifi]" || netStatus == "[ConnectivityResult.ethernet]" || netStatus == "[ConnectivityResult.vpn]") {
                   
                     if(userNameController.text == "" || idcontroller.text == ""){
                  ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please fill the necessary information')),
                  );
                 }else{
                  try {
                    String userName = userNameController.text;
                    String identityNo = idcontroller.text;
        loadingIndicator(context);
      final response = await APIService.instance.request(
        '/employeeLogin/$identityNo/$userName',
        DioMethod.get,
        contentType: Headers.jsonContentType,
      );
      //Get the position details
     List<dynamic> posHolder = [];

// Ensure response.data is a Map and not a List
if (response.data is Map<String, dynamic>) {
  posHolder.add(response.data['Position']);
} else if (response.data is String) {
  Map<String, dynamic> userData = jsonDecode(response.data);
  posHolder.add(userData['Position']);
}
//print(posHolder[0]);
//end of position details

      if (response.statusCode == 200 && posHolder[0] == "Driver") {
         if(booStatusChecker == "true"){ //check one time saving
       try{
         helper.updateLocalAccDetails(userName,identityNo,1);
         helper.updateSettings(1,1);
       }catch(e){
        print(e.toString());
       }
      }else if(booStatusChecker == "false"){
        print(logOnceChoice);
         try{
          helper.updateLocalAccDetails("null","null",1); //check one time saving (false part)
          helper.updateSettings(1,0);
         }catch(e){
          print(e.toString());
         }
      }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful: ${response.data}')),
        );//snack bar
         Navigator.push(context,MaterialPageRoute(
                //builder: (context)=>HomeScreen(),
                builder: (context)=>DriverScreen(response.data),
          ));
      }else if(posHolder[0] != "Driver"){
        errorUiSender(context,"Login failed. LogIn is possible for drivers only.");
      } 
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed.Invalid user information: ${response.statusMessage}')),
        );
      }
    }on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      errorUiSender(context,"Could not connect to the server. Please try again later (connection timeout)");
      print('Connection timeout. The server is not responding.');

    } else if (e.type == DioExceptionType.receiveTimeout) {
      errorUiSender(context,"Could not connect to the server. Please try again later (Recieve timeout)");
      print('Receive timeout. The server took too long to respond.');

    } else if (e.type == DioExceptionType.badResponse) {
      errorUiSender(context,"Bad response");
      print('Received invalid status code: ${e.response?.statusCode}');

    } else if (e.type == DioExceptionType.unknown) {
      errorUiSender(context,"Could not connect to the server. Please try again later (Unknown)");
      print('Failed to connect to the server: ${e.message}');

    }
  } catch (e) {
    errorUiSender(context,"Error occured when login in. Please try again later");
    print('An unexpected error occurred: $e');
  }
                 }

                   }
        },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00B7FF), // Button color
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'LogIn',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 30.0),
            // Add DashPress to Your Site Text
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Centers the entire row's content horizontally.
              crossAxisAlignment: CrossAxisAlignment.center, // Aligns the children vertically.
              children: [
                Text(
                "Check this box to login only once",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16.0,
                ),
              ),
                      ChangeNotifierProvider( //The ChangeNotifierProvider widget is used to create and provide an instance of a class (in this case, CheckboxProvider) to its child widget tree.
          create: (_) => CheckboxProvider(),
/**
 * The => syntax is equivalent to writing a function body with a single return statement.
It simplifies the syntax for functions that return a single expression.
 */

          /**
           * The create parameter in ChangeNotifierProvider is a callback function used to initialize an instance of a class that 
           * will act as the state provider for widgets further down in the widget tree.
It tells ChangeNotifierProvider how to create the object that it will manage and provide to the widget tree.
           */

           /**
            * Why Doesn't It Need a Name?
The provider package handles the lifecycle of the created object.
You only access it through the provided API (Consumer or Provider.of), so there's no need to assign it a specific name in the code.
            */

          /**
           * he line create: (_) => CheckboxProvider() creates an instance of the CheckboxProvider class and makes it available in the widget tree. 
           * The instance does not need an explicit 
           * name because the ChangeNotifierProvider takes care of storing and managing it.
           */
          child: Consumer<CheckboxProvider>(
            /**
             * The Consumer widget listens to the provided CheckboxProvider and rebuilds whenever its state changes.
             * The Consumer widget in Flutter (from the provider package) is used to listen to changes in a specific provider 
             * (in this case, CheckboxProvider) and rebuild parts of the widget tree accordingly.
             */

            /**
             * Consumer: A widget provided by the provider package.
It allows you to listen to changes in the state of a specific provider (CheckboxProvider in this case).
Whenever the state of the provider changes (due to notifyListeners being called), the Consumer rebuilds the widget inside its builder method.
             */

            /**The <CheckboxProvider> part specifies the type of provider this Consumer listens to.
It tells Flutter to retrieve an instance of CheckboxProvider from the nearest ChangeNotifierProvider ancestor in the widget tree. */

/** How the Consumer Works
Access to the Provider:

The Consumer retrieves the CheckboxProvider instance from the nearest ancestor ChangeNotifierProvider<CheckboxProvider>.
Listening for Changes:

The Consumer listens to CheckboxProvider for any changes (e.g., when notifyListeners() is called).
Rebuilding:

When the state of CheckboxProvider changes, the builder function is called again, and the widget inside the Consumer is rebuilt. */
            builder: (context, checkboxProvider, _) {
              /**
               * The builder is a callback function that defines how the widget should look based on the state provided by CheckboxProvider.
               */

              /**
               * Parameters of builder
context:

The BuildContext of the widget.
Allows access to things like theme, media query, or other widgets in the widget tree.
Can also be used to fetch other providers if necessary.
checkboxProvider:

This is the instance of the CheckboxProvider class.
It contains the current state (e.g., isChecked) and methods to update the state.
_:

This represents the child widget passed to the Consumer.
In this case, _ is unused because no child widget is passed to the Consumer.
Conventionally, _ is used to indicate an unused parameter.
               */

              /**NOTE!! - this builder is a widget function related to the "ChangeNotifierProvider" calss. we calls that function in here like 
               * inserting values to attributes we can call the functions reltaed to the widget
               * 
               * in the class,
               * --> Widget Function(BuildContext, Widget?) builder
               * we calls this (this is in the class and we call it)
              */

              /**
               * The builder in the Consumer widget is called a callback function because it is a function you pass as an argument 
               * to another function (or widget) to be executed later, often in response to an event or change in state.
               
               Purpose of Returning a Widget: The builder function is responsible for constructing and returning a widget (in this case, a Checkbox)
                that will be inserted into the widget tree. The widget returned here is what gets rendered on the screen.
               
               Flutter's widget tree is declarative. Each widget represents part of the UI, and the builder function must return a widget to display.
Whenever the state managed by checkboxProvider changes, the builder function is triggered, and the returned widget (the Checkbox) is rebuilt with the updated state.
               */
              return Checkbox(
                /**
                 * in Flutter, you can return a widget while calling a function, as the widget tree is declarative. Functions in Flutter often return widgets to define a reusable piece of the UI.
                  Widgets in Flutter are immutable, so instead of modifying a widget, you define a new one and return it, ensuring that the UI is reconstructed when needed.
                 */
                /**
                 * In summary, you can return a widget by calling a function that constructs it, 
                 * and this aligns with Flutter's declarative approach. Functions are a powerful way to simplify and modularize your UI code.
                 */
                /**
                 * If you mean returning non-widget values (like a string, number, or boolean), that’s not typically done directly in widget-building contexts like the builder. 
                 * In such cases, you handle logic outside the builder and use its output to construct the widget.
                 */

                //RENDER AGAIN WITH THE NEW VALUES
              value: checkboxProvider.isChecked,
              onChanged: (value) {
                //call the seter method with the value
                checkboxProvider.isChecked = value ?? true;
              },
            );
            } 
          ),
        ),
              ],
            ),
            
          
          ],
        ),
      ),
    );
  }
  
}
class CheckboxProvider with ChangeNotifier {
  /**
   * CheckboxProvider: This is a class designed to manage and provide state (in this case, the state of a checkbox).
with ChangeNotifier: The ChangeNotifier mixin provides a mechanism to notify listeners whenever the state changes. It's part of Flutter's 
foundation library and is commonly used in the Provider package for state management.
   */
  /**MIXIN CLASSES ARE IN A SEPARATE CHAPTER */
  bool _isChecked = false;
  bool get isChecked => _isChecked;
  /**
   * This is a getter that allows other parts of the app to read the value of _isChecked.
It exposes the private variable _isChecked in a controlled, read-only manner.

   */
  set isChecked(bool value) {
    _isChecked = value;
    if(value == true){
    logOnceChoice = true;
    booStatusChecker = "true";
    print(booStatusChecker);
    }else{
    logOnceChoice = false;
     booStatusChecker = "false";
    print(booStatusChecker);
    }
    notifyListeners();
    /**notifyListeners() is called whenever the isChecked value changes, notifying all widgets that depend on this provider to rebuild. */
  }
  /**
   * his is a setter that allows other parts of the app to update the value of _isChecked.
When the value is updated, the setter calls notifyListeners().
   */

  /**
   * How It Works in Practice
The checkbox UI binds to CheckboxProvider via Consumer or Provider.of to listen for changes.
When the checkbox is toggled:
The setter isChecked is invoked.
The state _isChecked is updated.
notifyListeners() is called, triggering a rebuild of all widgets listening to CheckboxProvider.
This keeps the UI in sync with the state.
   */
}
