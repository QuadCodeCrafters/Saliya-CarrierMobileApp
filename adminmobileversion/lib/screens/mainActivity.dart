import 'dart:convert';

import 'package:adminmobileversion/mssqlDB.dart';
import 'package:adminmobileversion/screens/driverMenu.dart';
import 'package:adminmobileversion/screens/finishingScreen.dart';
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
class DriverMainActivity extends StatefulWidget {
  //const DriverMainActivity({Key? key}) : super(key: key);
    final dynamic passSerId;
    final dynamic passPlateNum;
    final Map<String, dynamic> passValue;

    const DriverMainActivity({
       required this.passSerId, 
       required this.passPlateNum,
       required this.passValue
    });

  @override
  DriverMainActivityState createState() => DriverMainActivityState();
}

class DriverMainActivityState extends State<DriverMainActivity> {
  List<dynamic> cusInfo = [];
  List<dynamic> cusInfoIndi = [];
  bool isLoading = true;
  String? error;
  static double? lati;
  static double? logi;

  static double? lati_current;
  static double? longi_current;
  CameraPosition? _initialCameraPosition; // Nullable CameraPosition
  GoogleMapController? _googleMapController;
  SqfliteHelper helper = SqfliteHelper();
  Future errorUiSender(BuildContext context,String message) async {
                 final connectivityResult = await Connectivity().checkConnectivity();
                 String netStatus = connectivityResult.toString();
                  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
                 if(!serviceEnabled){
                 _returnLocationError();
                 }
                 if(netStatus == "[ConnectivityResult.none]"){
                  showDialog(
    barrierDismissible: false,
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
            child: const Text("Refresh"),
            onPressed: (){
                     Navigator.push(context,MaterialPageRoute(
                  builder: (context)=> DriverMainActivity(passSerId: widget.passSerId,passPlateNum: widget.passPlateNum, passValue: widget.passValue,),
                ));
            },
          )
        ],
      ),
    );
    } 
                    );                  
                 }else{
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
                             Restart.restartApp(
                              notificationTitle: 'Restarting App',
                              notificationBody: 'Please tap here to open the app again.',
                             );
                        },
                        child: const Text('Restart the app'),
                      ),
                    ],
                  );
                }, 
              );
                 }
}
   @override
  void initState() {
    super.initState();
    dbProcess2();
    
     try{
          _getCurrentLocation().then((value){
           lati_current = value.latitude;
           longi_current = value.longitude;
          print('OUTPUT LATITUDES' + lati_current.toString() + ' OUTPUT LONGITUDES' + longi_current.toString());
        });
        }catch(e){
          errorUiSender(context,"Error occured when obtaining the current location. Try again later");
          print('ERROR IN THE CURRENT LOCATION' + '${e.toString()}');
        }
        getCurrentLiveLocation();
  }

LocationData? currentLocationLive;
static double? liveLatMar; //for live tracking 
static double? liveLonMar;

void getCurrentLiveLocation() async {
  try {
    Location liveLoc = Location();

    // Get initial location
    liveLoc.getLocation().then((liveLocData) {
      currentLocationLive = liveLocData;
      if (currentLocationLive != null) {
        liveLatMar = currentLocationLive!.latitude;
        liveLonMar = currentLocationLive!.longitude;
        //print('Initial LATI: $liveLatMar, Initial LON: $liveLonMar');
      }
    });

    // Listen for live location changes
    liveLoc.onLocationChanged.listen((newLoc) {
      currentLocationLive = newLoc;

      // Update the camera position on the map
      _googleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 13.5,
            target: LatLng(
              newLoc.latitude!,
              newLoc.longitude!,
            ),
          ),
        ),
      );

      // Update live latitude and longitude
      liveLatMar = newLoc.latitude;
      liveLonMar = newLoc.longitude;

      // Print updated live location
      print('Live LATI: $liveLatMar, Live LON: $liveLonMar');

      // Trigger UI update if necessary
      setState(() {});
    });
  } catch (e) {
    errorUiSender(context,"Error occured when tracking the live location");
    print('ERROR IN THE LIVE STREAM: ' + e.toString());
  }
}

Future<Object>_returnLocationError() async{
    return showDialog(
           barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text(
                        'Location services are disabled. Turn on location services to continue'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                           Navigator.push(context,MaterialPageRoute(
                  builder: (context)=> DriverMainActivity(passSerId: widget.passSerId,passPlateNum: widget.passPlateNum, passValue: widget.passValue,),
                ));
                        },
                        child: const Text('Refresh'),
                      ),
                    ],
                  );
                },
              );
  }
  Future<Position> _getCurrentLocation()async{ //get the current locatiom
           
          bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if(!serviceEnabled){
          _returnLocationError();
          return Future.error('Location services are disabled');
        }
        LocationPermission permission = await Geolocator.checkPermission();
        if(permission == LocationPermission.denied){
          permission = await Geolocator.requestPermission();
          if(permission == LocationPermission.denied){
            return Future.error('Location permissions are denied');
          }
        }
        if(permission == LocationPermission.deniedForever){
          return Future.error('Location permissions are permently denied');
        }
        return await Geolocator.getCurrentPosition();
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

      setState(() async {
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
        //test section start
       
        //test section end
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
    //  errorUiSender(context,"Error occured when obtaining the customer information");
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
  //open the google map application
  void openMap(double currentLatitude, double currentLongitude, double destinationLatitude, double destinationLongitude) async {
  String url = "https://www.google.com/maps/dir/?api=1&origin=$currentLatitude,$currentLongitude&destination=$destinationLatitude,$destinationLongitude";

  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'COULD NOT OPEN GOOGLE MAPS';
  }
}
//open the phone app
_launchCaller() async {
   var url = "tel:${cusInfoIndi[5]}"; // Add 'tel:' before the phone number
  if ( await canLaunchUrl(Uri.parse(url))) {
     launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}


// Function to show a Bottom Sheet
void _showBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true, // Makes the BottomSheet scrollable
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8, // Initial height (80% of screen)
        minChildSize: 0.4, // Minimum height
        maxChildSize: 0.9, // Maximum height (90% of screen)
        builder: (BuildContext context, ScrollController scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'More Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      title: Text('Carrier Vehicle ID'),
                      subtitle: Text('${widget.passPlateNum}'),
                    ),
                  ),
                  if (cusInfoIndi.length >= 2)
                    Card(
                      child: ListTile(
                        title: Text('Customer Name'),
                        subtitle: Text('${cusInfoIndi[0]} ${cusInfoIndi[1]}'),
                      ),
                    ),
                  if (cusInfoIndi.length >= 3)
                    Card(
                      child: ListTile(
                        title: Text('NIC'),
                        subtitle: Text('${cusInfoIndi[2]}'),
                      ),
                    ),
                  if (cusInfoIndi.length >= 4)
                    Card(
                      child: ListTile(
                        title: Text('Date reserved'),
                        subtitle: Text('${cusInfoIndi[3]}'),
                      ),
                    ),
                  if (cusInfoIndi.length >= 5)
                    Card(
                      child: ListTile(
                        title: Text('Customer address'),
                        subtitle: Text('${cusInfoIndi[4]}'),
                      ),
                    ),
                  if (cusInfoIndi.length >= 6)
                    Card(
                      child: ListTile(
                        title: Text('Phone'),
                        subtitle: Text('${cusInfoIndi[5]}'),
                      ),
                    ),
                  if (cusInfoIndi.length >= 7)
                    Card(
                      child: ListTile(
                        title: Text('E-mail'),
                        subtitle: Text('${cusInfoIndi[6]}'),
                      ),
                    ),
                  if (cusInfoIndi.length >= 8)
                    Card(
                      child: ListTile(
                        title: Text('Brand'),
                        subtitle: Text('${cusInfoIndi[7]}'),
                      ),
                    ),
                  if (cusInfoIndi.length >= 9)
                    Card(
                      child: ListTile(
                        title: Text('Customer vehicle plate number'),
                        subtitle: Text('${cusInfoIndi[8]}'),
                      ),
                    ),
                  if (cusInfoIndi.length >= 10)
                    Card(
                      child: ListTile(
                        title: Text('Problem'),
                        subtitle: Text('${cusInfoIndi[9]}'),
                      ),
                    ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the Bottom Sheet
                    },
                    child: Text('Close'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map Container
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[200], // Placeholder color
            child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                   Stack(
                    children: [
                       SizedBox(
                          height: 520,
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
                                  //TODO:commented temporaly
                                 /* initialCameraPosition: CameraPosition(
                                   target: LatLng(
            currentLocationLive!.latitude!, currentLocationLive!.longitude!),
        zoom: 13.5,
                                  ),*/
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
                                  
                                  markers: {
  if (lati != null && logi != null)
    Marker(
      markerId: MarkerId('CustomerLocation'),
      position: LatLng(lati!, logi!),
    ),
  if (lati_current != null && longi_current != null)
    Marker(
      markerId: MarkerId('currentLocation'),
      position: LatLng(lati_current!, longi_current!),
    ),
    if (liveLatMar != null && liveLonMar !=null)
   Marker(
  markerId: const MarkerId("currentLocationLiveStream"),
  position: LatLng(
    liveLatMar!,
    liveLonMar!,
  ),
  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), // Change the color
),

},

                                ),
                        ),
                    Positioned(
                      top: 448,
                      left: 8,
                      child:  FloatingActionButton(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      child: Icon(Icons.my_location),
                      onPressed: _moveCamera,
                      
                      ),
                    ),
                    Positioned(
                      top: 384,
                      left: 8,
                      child:  FloatingActionButton(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      child: Icon(Icons.refresh),
                      onPressed: () {
                          Navigator.push(context,MaterialPageRoute(
                  builder: (context)=> DriverMainActivity(passSerId: widget.passSerId,passPlateNum: widget.passPlateNum, passValue: widget.passValue,),
                ));
                      },
                      
                      ),
                    ),
                    ],
                   ),
                  ],
                ),
          ),

          // Bottom Sheet with Driver Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  
                  // Customer info preview
                  if (cusInfoIndi.length >= 2)...[
                    Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        const SizedBox(width: 15),
                         Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${cusInfoIndi[0]} ${cusInfoIndi[1]}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              if (cusInfoIndi.length >= 5)
                              Text(
                                '${cusInfoIndi[4]}',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ],
                
                  // Action buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          icon: Icons.call,
                          label: 'Call',
                          color: Colors.green,
                          onTap: () {
                            try{
                              _launchCaller();
                            }catch(e){
                                                        showDialog(
    context: context,
    builder: (BuildContext context) {
      return  AlertDialog(
      title: Text('Error Occured'),
      content: Text('Unable to open phone app. Check wether the application is properly installed'),
      actions: <Widget>[
            TextButton(
              onPressed: () => {
                //Navigator.pop(context, 'Cancel')
              },
              child: const Text('Ok'),
            ),

          ],
    );
    },
   );
                            }
                          },
                        ),
                        _buildActionButton(
                          icon: Icons.directions,
                          label: 'Directions',
                          color: Colors.blue,
                          onTap: () {
                            try{
                             openMap(lati_current!, longi_current!, lati!, logi!);
                            }catch(e){
                              //TODO: IM HERE !!!!!
                               showDialog(
    context: context,
    builder: (BuildContext context) {
      return  AlertDialog(
      title: Text('Error Occured'),
      content: Text('Unable to open Google maps. Check wether the application is properly installed (Maps Go version is not recomended)'),
      actions: <Widget>[
            TextButton(
              onPressed: () => {
                //Navigator.pop(context, 'Cancel')
              },
              child: const Text('Ok'),
            ),

          ],
    );
    },
   );
                            }
                          },
                        ),
                        _buildActionButton(
                          icon: Icons.info_outline,
                          label: 'More Info',
                          color: Colors.orange,
                          onTap: () {
                             _showBottomSheet(context);
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Finish and Cancel buttons
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              
//SHOW DIALOG
showDialog(
    context: context,
    builder: (BuildContext context) {
      return  AlertDialog(
      title: Text('confirmation'),
      content: Text('Are you sure you want to cancel this ride?'),
      actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'No');
                try{
                //  final test1 = await helper.getTasks();
                //  print(test1);
                //helper.deleteTask(1);
                //print('task deleted');
                }catch(e){
                  print(e.toString());
                }
              },
              child: const Text('No'),
            ),
//Yes button
           TextButton(
  onPressed: () async {
    try {
      await helper.insertData('${widget.passSerId}', false); //🍓🍓🍓🍓🍓🍓🍓🍓🍓🍓🍓🍓🍓🍓🍓🍓🍓🍓🍓🍓🍓🍓🍓🍓🍓🍓🍓🍓🍓🍓🍓🍓🍓
      print('Cancel data inserted');
                     
                      Navigator.push(context,MaterialPageRoute(
                      builder: (context)=> DriverScreen(widget.passValue),
                      ));
                      
      // Optional: Add success handling here
    } catch (e) {
     errorUiSender(context,"Error occured when inserting cancel data");
      print('Error CANCEL DATA INSERT PART: $e');
    }
  },
  child: const Text('Yes'),
),
//Yes button end
          ],
    );
    },
   );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Cancel Ride',
                              style: TextStyle(fontSize: 16,color: Color.fromRGBO(255, 255, 255, 1),),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton(
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
               Navigator.push(context,MaterialPageRoute(
                  builder: (context)=> DriverMainActivity(passSerId: widget.passSerId,passPlateNum: widget.passPlateNum, passValue: widget.passValue,),
                ));
            },
          )
        ],
      ),
    );
    } 
                    );
                  } else if(netStatus == "[ConnectivityResult.mobile]" || netStatus == "[ConnectivityResult.wifi]" || netStatus == "[ConnectivityResult.ethernet]" || netStatus == "[ConnectivityResult.vpn]") {
                  Navigator.push(context,MaterialPageRoute(
                                    builder: (context)=> FinishingScreen(passSerId: widget.passSerId,passPlateNum: widget.passPlateNum),
                                    ));
                  }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Finish Ride',
                             style: TextStyle(fontSize: 16,color: Color.fromRGBO(255, 255, 255, 1),)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: 25),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}