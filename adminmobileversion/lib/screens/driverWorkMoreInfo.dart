import 'package:adminmobileversion/mssqlDB.dart';
import 'package:adminmobileversion/screens/mainActivity.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mssql_connection/mssql_connection.dart';
import 'dart:convert';

class DriverWorkMoreInfoWindow extends StatefulWidget {
  final dynamic passSerId;
  final dynamic passPlateNum;
  final Map<String, dynamic> passValue;
  
  const DriverWorkMoreInfoWindow({
    required this.passSerId, 
    required this.passPlateNum,
    required this.passValue
  });

  @override
  DriverWorkMoreInfoWindowState createState() => DriverWorkMoreInfoWindowState();
}

class DriverWorkMoreInfoWindowState extends State<DriverWorkMoreInfoWindow> {
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
    return Center(child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E40AF)),
    ));
  }

  if (error != null) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Color(0xFFDC2626)),
          SizedBox(height: 16),
          Text(
            'Error: $error',
            style: TextStyle(color: Color(0xFFDC2626), fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  if (cusInfoIndi.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 60, color: Color(0xFF3B82F6)),
          SizedBox(height: 16),
          Text(
            'No customer information available',
            style: TextStyle(color: Color(0xFF3B82F6), fontSize: 18),
          ),
        ],
      ),
    );
  }

  return ListView(
    padding: EdgeInsets.all(5),
    children: [
      _buildInfoCard('Carrier Vehicle ID', '${widget.passPlateNum}', Icons.directions_car),
      if (cusInfoIndi.length >= 2) _buildInfoCard('Customer Name', '${cusInfoIndi[0]} ${cusInfoIndi[1]}', Icons.person),
      if (cusInfoIndi.length >= 3) _buildInfoCard('NIC', '${cusInfoIndi[2]}', Icons.credit_card),
      if (cusInfoIndi.length >= 4) _buildInfoCard('Date reserved', '${cusInfoIndi[3]}', Icons.calendar_today),
      if (cusInfoIndi.length >= 5) _buildInfoCard('Customer address', '${cusInfoIndi[4]}', Icons.location_on),
      if (cusInfoIndi.length >= 6) _buildInfoCard('Phone', '${cusInfoIndi[5]}', Icons.phone),
      if (cusInfoIndi.length >= 7) _buildInfoCard('E-mail', '${cusInfoIndi[6]}', Icons.email),
      if (cusInfoIndi.length >= 8) _buildInfoCard('Brand', '${cusInfoIndi[7]}', Icons.branding_watermark),
      if (cusInfoIndi.length >= 9) _buildInfoCard('Customer vehicle plate number', '${cusInfoIndi[8]}', Icons.confirmation_number),
      if (cusInfoIndi.length >= 10) _buildInfoCard('Problem', '${cusInfoIndi[9]}', Icons.report_problem),
    ],
  );
}

Widget _buildInfoCard(String title, String subtitle, IconData icon) {
  return Card(
    elevation: 2,
    margin: EdgeInsets.only(bottom: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.fromARGB(255, 14, 52, 175), Color.fromARGB(255, 67, 121, 209)],
          ),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              subtitle,
              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
            ),
          ),
        ),
      ),
    ),
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
                  //  SizedBox(height: 2),
                    Expanded(
                      child: _buildCustomerInfo(),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      
  onPressed: () async {
    final connectivityResult = await Connectivity().checkConnectivity();
    String netStatus = connectivityResult.toString();
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
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
    } 
                    );
     }else{
      showDialog(
    context: context,
    builder: (BuildContext context) {
      return  AlertDialog(
      title: Text('confirmation'),
      content: Text('Are you sure you want to accept this?'),
      actions: <Widget>[
            TextButton(
              onPressed: () => {
                Navigator.pop(context, 'Cancel')
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => {
               // Navigator.pop(context, 'OK')
                Navigator.push(context,MaterialPageRoute(
                  builder: (context)=> DriverMainActivity(passSerId: widget.passSerId,passPlateNum: widget.passPlateNum, passValue: widget.passValue,),
                )),
              },
              child: const Text('OK'),
            ),
          ],
    );
    },
   );
     }
  },
  icon: Icon(
    Icons.local_shipping, // Carrier vehicle icon
    size: 24,
    color: Colors.black,
  ),
  label: Text(
    'ACCEPT',
    style: TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
  style: ElevatedButton.styleFrom(
    backgroundColor: Color.fromARGB(255, 0, 198, 224), // Amber/yellow color
    minimumSize: Size(double.infinity, 50), // Full width button with height 50
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25), // Rounded corners
    ),
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    
  ),
)
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