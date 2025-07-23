import 'package:adminmobileversion/mssqlDB.dart';
import 'package:adminmobileversion/screens/driverMenu.dart';
import 'package:adminmobileversion/screens/driverWorkMoreInfo.dart';
import 'package:adminmobileversion/sqflite_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mssql_connection/mssql_connection.dart';
import 'dart:convert';

class DriverCurrentWork extends StatefulWidget {
  final Map<String, dynamic> passValue;
  //TODO: ARRANGE THE CARD BUTTONS CENTER LIKE PIC ME DRIVER
  DriverCurrentWork(this.passValue);
  @override
  _DriverCurrentWorkState createState() => _DriverCurrentWorkState();
}
class _DriverCurrentWorkState extends State<DriverCurrentWork> {
  List<dynamic> reviews = [];
  List<dynamic> serviceID = [];
  List<dynamic> CustomerInfo = [];
  var passDriverId;
  List<dynamic> cusNamesIndi = [];
  List<dynamic> dateIndi = [];
  List<dynamic> cusContactIndi = [];
  List<dynamic> nicIndi = [];
  List<dynamic> vehiIndi = [];
  int assiNum = 0;
  List<dynamic> carrierVehicleInfo = [];
  bool isLoading = true; // To indicate data loading

  SqfliteHelper helper = SqfliteHelper();
    List<dynamic> storeSaveRow = [];//store cancel data row (in the sql lite table)
    
     String buttonText = 'Save';
     String netStatus = "";
     bool netStatusNumber = true;
     int testVar1 = 0; 
   Future<void> checkInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    netStatus = connectivityResult.toString();
    if(netStatus == ""){
       setState(() => netStatusNumber = false);
       return;
    }
    if(netStatus == "[ConnectivityResult.none]"){
    }
     if(netStatus == "[ConnectivityResult.mobile]" || netStatus == "[ConnectivityResult.wifi]"){
      dbProcess1();
     }
    setState(() => netStatusNumber = false); // Update UI after data fetching
   }
  @override
  void initState() {
    super.initState();
    checkInternet();
  }

  Future<void> dbProcess1() async {
    try {
      dbConn d1 = dbConn(); // Object of DB class
      MssqlConnection conn = await d1.connection(); // Get the MS SQL DB connection
      print("connected to DB using conn OUT1");

      var em_id = widget.passValue['EmployeeID'];
      passDriverId = em_id;
      String query = "SELECT * FROM driverWork WHERE driverID = $em_id AND status = 0";
      String result = await conn.getData(query); // Fetch data
      reviews = jsonDecode(result);

      if (reviews.isEmpty) {
        setState(() => isLoading = false);
        return;
      }

      for (var serviceIDget in reviews) {
        serviceID.add('${serviceIDget['serviceID']}');
      }
      for (var cusInfoGet in serviceID) {
        String query2 = "SELECT * FROM carrierServiceCustomers WHERE serviceID = $cusInfoGet";
        String result2 = await conn.getData(query2);
        CustomerInfo.add(jsonDecode(result2));

        String query3 =
            "SELECT plateNumber FROM carrierVehiclesInfo WHERE vehicleID = (SELECT vehicleID FROM carrierServiceVehicleHistory WHERE serviceID = ${cusInfoGet})";
        String result3 = await conn.getData(query3);
        carrierVehicleInfo.add(jsonDecode(result3));
        assiNum = assiNum + 1;
      }

      for (var cusNameget in CustomerInfo) {
        for (var cusNameget2 in cusNameget) {
          cusNamesIndi.add('${cusNameget2['firstName']}' + ' ${cusNameget2['lastName']}');
          dateIndi.add('${cusNameget2['Date']}');
          cusContactIndi.add('${cusNameget2['phone']}');
          nicIndi.add('${cusNameget2['NIC']}');
        }
      }
      for(var vehi1 in carrierVehicleInfo){
        for(var vehi2 in vehi1){
          vehiIndi.add('${vehi2['plateNumber']}');
        }
      }

      print(vehiIndi);

      setState(() => isLoading = false); // Update UI after data fetching
    } catch (e) {
      //TODO: show the errors properly
      print(e.toString() + 'error in the current work part!!');
    }
  }

  @override
  Widget build(BuildContext context) {
    if(netStatusNumber){
      return Scaffold(
      body: SafeArea(
        child: Center(child: CircularProgressIndicator()),
      ),
      );
    }
    else{
      if(netStatus == "[ConnectivityResult.mobile]" || netStatus == "[ConnectivityResult.wifi]"){
      testVar1++;
      print('CARDS LOADED');
       return Scaffold(
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator()) // Show loading indicator
            : SingleChildScrollView(
                child: Column(
                  children: [
              Align(
  alignment: Alignment.topLeft,
  child: Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    margin: EdgeInsets.only(bottom: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Current Work",
          style: TextStyle(
            fontSize: 33,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: () {
            //dbProcess1();
                      Navigator.push(context,MaterialPageRoute(
                      builder: (context)=> DriverScreen(widget.passValue),
                      ));
          },
          icon: Icon(Icons.refresh),
          tooltip: "Refresh",
        ),
      ],
    ),
  ),
),

            Align(
              alignment: Alignment.topLeft,
              child: Container(
              padding: EdgeInsets.only(left: 10),
              margin: EdgeInsets.only(bottom: 12),
              child: Text("There are ${assiNum} works assigned",
              style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
            ),
              ),
            ),
                    for (int i = 0; i < CustomerInfo.length; i++)
                      Container(
                        decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [Color(0xFF2C5282), Color(0xFF1A365D)],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                        child: Card(
                          elevation: 5,
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '${cusNamesIndi[i]}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      '${Icons.calendar_today} Reserved Date : ${dateIndi[i]}',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    Text(
                                      '${Icons.phone} Customer Contact : ${cusContactIndi[i]}',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    Text(
                                      '${Icons.credit_card} Customer NIC : ${nicIndi[i]}',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    Text(
                                      '${Icons.directions_car} Carrier Vehicle Number : ${vehiIndi[i]}',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  ElevatedButton(
                                              child: Text(buttonText),
                                              onPressed: () async {
                                              try{
                                              storeSaveRow = await helper.checkSavedData(serviceID[i]);
                                              if(storeSaveRow.isEmpty){
                                              helper.insertSaveEvents(serviceID[i]);
                                                //print('EVENT SAVED');//to test
                                              setState(() {
                                               // Change the button text when pressed
                                              buttonText = buttonText == 'Save' ? 'Saved' : 'Save';
                                              });
                                              }
                                              else{
                                              helper.deleteSavedEvents(serviceID[i]);
                                              //print('EVENT REMOVED');//to test
                                              setState(() {
                                              // Change the button text when pressed
                                              buttonText = buttonText == 'Saved' ? 'Save' : 'Save';
                                              });
                                             }
                                            // print('Save test' + storeSaveRow.toString()); //for the test
                                             }catch(e){
                                             //TODO: add the better error handeling
                                             print('ERROR EVENT SAVER ' + e.toString());
                                             }

                                              },
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white, backgroundColor: Color(0xFF4299E1),
                                              ),
                                            ),
                                  ElevatedButton(
                                    child: const Text('More Info'),
                                    style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white, backgroundColor: Color(0xFF48BB78),
                                    ),
                                    onPressed: () async {
                                     final connectivityResult = await Connectivity().checkConnectivity();
                                     String netStatus = connectivityResult.toString();
                                     //print(netStatus);
                                     if (netStatus == "[ConnectivityResult.none]") { 
                                      showDialog(
    context: context,
     barrierDismissible: false,
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
              Navigator.push(context,MaterialPageRoute(
                      builder: (context)=> DriverScreen(widget.passValue),
                      ));
            },
          )
        ],
      ),
    );
    } 
                    );
                                     }else{
                                      Navigator.push(context,MaterialPageRoute(
                                    builder: (context)=>DriverWorkMoreInfoWindow(passSerId: serviceID[i],passPlateNum: vehiIndi[i], passValue: widget.passValue),
                                    ));
                                     }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
    }else if(netStatus == "[ConnectivityResult.none]"){
      testVar1 = 2;
      print('NO CONNECTION none');
      return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_off_rounded,
                size: 100,
                color: Color(0xFF6C63FF),
              ),
              const SizedBox(height: 32),
              const Text(
                'Oops! No Internet Connection',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Please check your network connection and try again.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF9C9EB9),
                ),
                textAlign: TextAlign.center,
              ),
                  IconButton(
          onPressed: () {
            //dbProcess1();
                      Navigator.push(context,MaterialPageRoute(
                      builder: (context)=> DriverScreen(widget.passValue),
                      ));
          },
          icon: Icon(Icons.refresh),
          tooltip: "Refresh",
        ),
              const SizedBox(height: 48),
           
            ],
          ),
        ),
      ),
    );
    } 
    else{
      print('NO CONNECTION');
      return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_off_rounded,
                size: 100,
                color: Color(0xFF6C63FF),
              ),
              const SizedBox(height: 32),
              const Text(
                'Error occured',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Please check your network connection and try again.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF9C9EB9),
                ),
                textAlign: TextAlign.center,
              ),
              IconButton(
          onPressed: () {
            //dbProcess1();
                      Navigator.push(context,MaterialPageRoute(
                      builder: (context)=> DriverScreen(widget.passValue),
                      ));
          },
          icon: Icon(Icons.refresh),
          tooltip: "Refresh",
        ),
              const SizedBox(height: 48),
           
            ],
          ),
        ),
      ),
    );
    }
    }
    
  }
}
