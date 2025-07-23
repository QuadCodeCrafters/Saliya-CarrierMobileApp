import 'package:adminmobileversion/screens/driverLogIn.dart';
import 'package:adminmobileversion/screens/driverMenu.dart';
import 'package:adminmobileversion/sqflite_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'screens/LoginScreen.dart';

enum DioMethod { post, get, put, delete }
final String baseUrl = 'http://192.168.204.42:8000'; //the Main URL and changes it 
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
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Add error handling for gesture-related errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };
  //TODO: FOR NOW
  SqfliteHelper helper = SqfliteHelper();
  List<dynamic>storeSettings = [];
  List<dynamic>localAcc = [];
  storeSettings = await helper.checkTheSetting1(1);
  int logStatus = 0;
  for(var logHolderTEmp in storeSettings){
    logStatus = logHolderTEmp['status'];
  }
 // print('LOGSTATUS' + logStatus.toString());
 if(logStatus == 1){
  String usName = "",identificationNo = "";
  localAcc = await helper.getStoredAccInfo(1);
  for(var localAccTemp in localAcc){
    usName = localAccTemp['userName'];
    identificationNo = localAccTemp['identificationNo'];
  }
  if(identificationNo != "" || usName != ""){
     try {
      final response = await APIService.instance.request(
        '/employeeLogin/$identificationNo/$usName',
        DioMethod.get,
        contentType: Headers.jsonContentType,
      );

      if (response.statusCode == 200) {
       runApp(MyApp2(response.data));
      } else {
         runApp(const MyApp());
      }
    } catch (e) {
      print(e.toString());
    }
  }
  //print(identificationNo); //to test
 }else{
   runApp(const MyApp());
 }
 //runApp(const MyApp());
  //for now
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       home: Driverlogin(),
    );
  }
}

 class MyApp2 extends StatelessWidget {
  var passValue;
   MyApp2(this.passValue);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       home: DriverScreen(passValue),
    );
  }
}
