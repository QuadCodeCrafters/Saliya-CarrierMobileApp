import 'package:adminmobileversion/mssqlDB.dart';
import 'package:adminmobileversion/screens/mainActivity.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mssql_connection/mssql_connection.dart';
import 'dart:convert';

class moreInfoCompleted extends StatefulWidget {
  final dynamic passSerId;
  final dynamic passPlateNum;
  
  const moreInfoCompleted({
    required this.passSerId, 
    required this.passPlateNum
  });

  @override
  moreInfoCompletedState createState() => moreInfoCompletedState();
}

class moreInfoCompletedState extends State<moreInfoCompleted> {
  List<dynamic> cusInfo = [];
  List<dynamic> cusInfoIndi = [];
  bool isLoading = true;
  String? error;
  static double? lati;
  static double? logi;
  CameraPosition? _initialCameraPosition; // Nullable CameraPosition
  GoogleMapController? _googleMapController;
  //late Marker origin;

  @override
  void initState() {
    super.initState();
    dbProcess2();
  }

  Future<void> dbProcess2() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      dbConn d2 = dbConn();
      MssqlConnection conn2 = await d2.connection();
      
      var service_id_local = widget.passSerId;
      String query = "SELECT * FROM carrierServiceCustomers WHERE serviceID = ${service_id_local}";
      String result = await conn2.getData(query);
      
     if (!mounted) return;

      setState(() {
        cusInfo = jsonDecode(result);
        cusInfoIndi.clear();
        
        for (var cusInfoSeparator in cusInfo) {
          cusInfoIndi.addAll([
            '${cusInfoSeparator["firstName"]}',
            '${cusInfoSeparator["lastName"]}',
            '${cusInfoSeparator["NIC"]}',
            '${cusInfoSeparator["Date"]}',
            '${cusInfoSeparator["address"]}',
            '${cusInfoSeparator["phone"]}',
            '${cusInfoSeparator["mail"]}',
            '${cusInfoSeparator["brand"]}',
            '${cusInfoSeparator["vehiclePlateNumber"]}',
            '${cusInfoSeparator["problem"]}',
            '${cusInfoSeparator["approvalStatus"]}'
          ]);
          lati = cusInfoSeparator["latitude_cuslocation"];
          logi = cusInfoSeparator["longitude_cuslocation"];
        }
        if (lati != null && logi != null) {
          _initialCameraPosition = CameraPosition(
            target: LatLng(lati!, logi!),
            zoom: 13,
          );
        }
        isLoading = false;
      });
        // Move the camera to the new position
      _moveCamera();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.toString();
        isLoading = false;
      });
      print('Error in the current work part(more information): $e');
    }
  }
    void _moveCamera() {
    if (lati != null && logi != null && _googleMapController != null) {
      _googleMapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(lati!, logi!),
        ),
      );
    }
  }
  @override
  void dispose(){
    _googleMapController?.dispose();
    super.dispose();
  }

  Widget _buildCustomerInfo() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Text('Error: $error', style: TextStyle(color: Colors.red)),
      );
    }

    if (cusInfoIndi.isEmpty) {
      return Center(
        child: Text('No customer information available'),
      );
    }

    return ListView(
      children: [
        Card(
          child: ListTile(
            title: Text('Carrier Vehicle ID'),
            subtitle: Text('${widget.passPlateNum}'),
          ),
        ),
        if (cusInfoIndi.length >= 2) Card(
          child: ListTile(
            title: Text('Customer Name'),
            subtitle: Text('${cusInfoIndi[0]} ${cusInfoIndi[1]}'),
          ),
        ),
        if (cusInfoIndi.length >= 3) Card(
          child: ListTile(
            title: Text('NIC'),
            subtitle: Text('${cusInfoIndi[2]}'),
          ),
        ),
        if (cusInfoIndi.length >= 4) Card(
          child: ListTile(
            title: Text('Date reserved'),
            subtitle: Text('${cusInfoIndi[3]}'),
          ),
        ),
        if (cusInfoIndi.length >= 5) Card(
          child: ListTile(
            title: Text('Customer address'),
            subtitle: Text('${cusInfoIndi[4]}'),
          ),
        ),
        if (cusInfoIndi.length >= 6) Card(
          child: ListTile(
            title: Text('Phone'),
            subtitle: Text('${cusInfoIndi[5]}'),
          ),
        ),
        if (cusInfoIndi.length >= 7) Card(
          child: ListTile(
            title: Text('E-mail'),
            subtitle: Text('${cusInfoIndi[6]}'),
          ),
        ),
        if (cusInfoIndi.length >= 8) Card(
          child: ListTile(
            title: Text('Brand'),
            subtitle: Text('${cusInfoIndi[7]}'),
          ),
        ),
        if (cusInfoIndi.length >= 9) Card(
          child: ListTile(
            title: Text('Customer vehicle plate number'),
            subtitle: Text('${cusInfoIndi[8]}'),
          ),
        ),
        if (cusInfoIndi.length >= 10) Card(
          child: ListTile(
            title: Text('Problem'),
            subtitle: Text('${cusInfoIndi[9]}'),
          ),
        ),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More Information', style: TextStyle(fontSize: 30)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Section (50% of screen)
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                   Stack(
                    children: [
                       SizedBox(
                          height: 328,
                          child: _initialCameraPosition == null //if this is null "? Center(child: CircularProgressIndicator())" will run
                              ? Center(child: CircularProgressIndicator()) //circle progree indicator to indicate its loading state
                              /**
                               * In Flutter, widgets are typically Dart classes that define the user interface. 
                               * These classes often have constructors that allow developers to pass parameters 
                               * (like properties or event handlers) to customize the widget's behavior and appearance.
                               * 
                               * The GoogleMap widget is part of the Flutter Google Maps plugin, and its purpose is to render a Google Map in the Flutter app. Like most widgets in Flutter, it has a constructor 
                               * that you use to create an instance of the GoogleMap widget with specific configurations.
                               */
                              : GoogleMap( //else this will execute (create the google map)
                                  initialCameraPosition: _initialCameraPosition!,
                                  zoomControlsEnabled: false,
                                  myLocationButtonEnabled: false,
                                  onMapCreated: (controller) {
                                    //When the GoogleMap widget initializes, it creates the GoogleMapController object in the background.
                                    //This object is then passed to the onMapCreated callback so that you can use it to interact with the map programmatically.
                                    /**
                                     * The controller is a tool automatically created by the GoogleMap widget, allowing you to control and interact with the map. It makes it possible 
                                     * to manipulate the map programmatically in response to user actions or application logic.
                                     * Each GoogleMap widget instance has its own unique GoogleMapController.
The controller allows you to control only the specific map it is linked to.
                                     */
                                    _googleMapController = controller; //use this automatically created object locally

                                    // Move the camera to the initial position
                                    _moveCamera();
                                  },
                                  markers: lati != null && logi != null
                                      ? {
                                          Marker(
                                            markerId: MarkerId('CustomerLocation'),
                                            position: LatLng(lati!, logi!),
                                          )
                                        }
                                      : {},
                                ),
                        ),
                    Positioned(
                      top: 266,
                      left: 8,
                      child:  FloatingActionButton(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      child: Icon(Icons.my_location),
                      onPressed: _moveCamera,
                      
                      ),
                    ),
                    ],
                   ),
                  ],
                ),
              ),
            ),
            
            // Bottom Section (50% of screen)
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment(0.0, 0.0),
                      child: Text(
                      'Customer Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: _buildCustomerInfo(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}