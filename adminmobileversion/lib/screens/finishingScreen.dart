import 'dart:convert';
import 'dart:math';

import 'package:adminmobileversion/mssqlDB.dart';
import 'package:adminmobileversion/screens/driverMenu.dart';
import 'package:adminmobileversion/sqflite_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mssql_connection/mssql_connection.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart' hide LocationAccuracy;
import 'package:restart_app/restart_app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:mssql_connection/mssql_connection.dart'; 
import 'package:dio/dio.dart';

enum DioMethod { post, get, put, delete }
final String baseUrl = 'http://192.168.193.42:8000'; //the Main URL 
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
    String? contentType,
    dynamic data,
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
        response = await _dio.put(endpoint,data: data);
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
class FinishingScreen extends StatefulWidget {
  final String passSerId;
  final String passPlateNum;

  const FinishingScreen({

    required this.passSerId,
    required this.passPlateNum,
  });

  @override
  _FinishingScreenState createState() => _FinishingScreenState();
}

class _FinishingScreenState extends State<FinishingScreen> { 
  String sen = "";
  var identityNo;

  //INIT STATE
  @override
  void initState() {
    super.initState();
    try{
    dbProcess2();
    dbProcess3();
    dbProcess4();
    }catch(e){
      errorUiSender(context,"Error in the initState");
      sen = "Error occured. Please try again";
      print('Error occured' + e.toString());
    }
  }

  //THE LOADING INDICATOR WIDGET
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

                 Future errorUiSender(BuildContext context,String message) async {
                 //INTERNET CONNECTIVITY CHECKER
                 final connectivityResult = await Connectivity().checkConnectivity();
                 String netStatus = connectivityResult.toString();
                 if(netStatus == "[ConnectivityResult.none]"){
                      showDialog(
                      barrierDismissible: false,
                      context: context,
                        builder: (BuildContext context){
                            return AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                               children: [
                                  SizedBox(width: 200,child: Image.asset('assets/netError.png')),
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
                                    child: const Text("Refresh"),
                                    onPressed: (){
                                      Navigator.push(context,MaterialPageRoute(
                                      builder: (context)=> FinishingScreen(passSerId: widget.passSerId,passPlateNum: widget.passPlateNum),
                                      ));
                                    },
                                  )
                               ],
                           ),
                         );
                      } 
                    );                  
                    }else{
                         //RETURN A DIALOG BOX TO RESTART AND REFRESH THE APP
                         return showDialog(
           barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text('${message}'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                              //RESTART THE APP 
                              Restart.restartApp(
                              notificationTitle: 'Restarting App',
                              notificationBody: 'Please tap here to open the app again.',
                              );
                        },
                        child: const Text('Restart the application'),
                      ),
                       TextButton(
                            onPressed: () {
                                Navigator.push(context,MaterialPageRoute(
                                builder: (context)=> FinishingScreen(passSerId: widget.passSerId,passPlateNum: widget.passPlateNum),
                                ));
                             },
                        child: const Text('Refresh'),
                      ),
                    ],
                  );
                }, 
              );
                     }
                 }            
    Future<void>dbProcess4()async {
          try {
          List<dynamic>cancelHolder = [];
          List<dynamic>serviceIdCheckerHolder = [];
          SqfliteHelper helper = SqfliteHelper();
          cancelHolder = await helper.getTasksUsingServiceID(widget.passSerId);
          for(var tempCancelHolder in cancelHolder){
             serviceIdCheckerHolder.add('${tempCancelHolder['id']}');
          }
          if(serviceIdCheckerHolder.isEmpty){}else{
            for(var updateHolder in serviceIdCheckerHolder){
                helper.updateTask(int.parse(updateHolder),true);
            }
          }
          } catch (e) {
            errorUiSender(context,"Error in the cancel updater");
            print('Error int the CANCEL UPDATER' + e.toString());  
          }
     }
   Future<void> dbProcess2() async {
    try {
      dbConn d2 = dbConn();
      MssqlConnection conn2 = await d2.connection();
      var service_id_local = widget.passSerId;
      String query = "UPDATE driverWork SET status = 1 WHERE serviceID = ${service_id_local}";
     //await conn2.execute(query, parameters: {'@serviceID': widget.passSerId});
     await conn2.getData(query);
    } catch (e) {
      //errorUiSender(context,"Error in the driverwork status updater");
      throw Exception();
    }
  }
  Future<void>dbProcess3()async {
    try{
      dbConn d2 = dbConn();
      MssqlConnection conn2 = await d2.connection();
      var service_id_local = widget.passSerId;
      String query = "SELECT driverID FROM driverWork WHERE serviceID = ${service_id_local}";
      String result = await conn2.getData(query);
      List<dynamic> reviews = jsonDecode(result);
     // identityNo = reviews[0];
     for(var sectionDevider in reviews){
      identityNo = sectionDevider['driverID'];
     }
      //print('IDENTITY NUMBER!!!!!' + identityNo.toString());
    }catch(e){
      errorUiSender(context,"Error in the driver ID finder");
      print('error of this part(id no)' + e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://img.freepik.com/premium-photo/office-worker-2d-cartoon-illustraton-white-background_889056-33111.jpg',
                      width: 300,
                      height: 340,
                    ),
                  //  SizedBox(height: 4),
                    Text(
                      'Ride Completed',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Thank you for your service',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildInfoCard(),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                 final connectivityResult = await Connectivity().checkConnectivity();
                 String netStatus = connectivityResult.toString();
                 print(netStatus);
                  if (netStatus == "[ConnectivityResult.none]") { 
                   errorUiSender(context,"Error in the network");
                  } else if(netStatus == "[ConnectivityResult.mobile]" || netStatus == "[ConnectivityResult.wifi]" || netStatus == "[ConnectivityResult.ethernet]" || netStatus == "[ConnectivityResult.vpn]") {
                                                  try {
     loadingIndicator(context);
     //Get the employee data
     final response = await APIService.instance.request(
        '/employees/$identityNo',
        DioMethod.get,
        contentType: Headers.jsonContentType,
      );
  final response2 = await APIService.instance.request(
  '/employeeUpdate/$identityNo',
  DioMethod.put,
  contentType: Headers.jsonContentType,
  data: {
    "Status": "Active"
},
);
      if (response.statusCode == 200 && response2.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful: ${response.data}')),
        );//snack bar
         Navigator.push(context,MaterialPageRoute(
                //builder: (context)=>HomeScreen(),
                builder: (context)=>DriverScreen(response.data),
                 ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed.Invalid user information: ${response.statusMessage}')),
        );
         errorUiSender(context,"Error in data saving");
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
                    },
                    child: Text('Back to Home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.confirmation_number, 'Service ID', widget.passSerId),
          SizedBox(height: 12),
          _buildInfoRow(Icons.directions_car, 'Vehicle', widget.passPlateNum),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.green[700], size: 24),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

