import 'dart:convert';

import 'package:adminmobileversion/mssqlDB.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';//pac1
import 'package:mssql_connection/mssql_connection.dart';

class AttractiveForm extends StatefulWidget {
     final Map<String, dynamic> passValue;
  const AttractiveForm(this.passValue);
  @override
  _AttractiveFormState createState() => _AttractiveFormState();
}

class _AttractiveFormState extends State<AttractiveForm> {
  final _formKey = GlobalKey<FormState>();
   late final TextEditingController fname;
  late final TextEditingController lname;
 late final TextEditingController nic;
  late final TextEditingController address;
 late final TextEditingController phone;
 late final TextEditingController brand;
 late final TextEditingController plate_no;
 late final TextEditingController problem;
 late final TextEditingController email;
 late final TextEditingController vehicle_plate_no;
  DateTime current_date = DateTime.now();
  static double? longi_current;
  static double? lati_current;
  @override
  void dispose() {
    // Dispose controllers to free resources
    fname.dispose();
    lname.dispose();
    nic.dispose();
    address.dispose();
    phone.dispose();
    brand.dispose();
    plate_no.dispose();
    problem.dispose();
    email.dispose();
    vehicle_plate_no.dispose();
    super.dispose();
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
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
  }
   Future<Position> _getCurrentLocation()async{ //function to get access permissions
           
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
    @override
  void initState() {
    super.initState();
     try{
          _getCurrentLocation().then((value){
           lati_current = value.latitude;
           longi_current = value.longitude;
          print('OUTPUT LATITUDES(for the form)' + lati_current.toString() + ' OUTPUT LONGITUDES (for the form)' + longi_current.toString());
        });
            fname = TextEditingController();
   lname = TextEditingController();
   nic = TextEditingController();
   address = TextEditingController();
   phone = TextEditingController();
   brand = TextEditingController();
   plate_no = TextEditingController();
   problem = TextEditingController();
   email = TextEditingController();
   vehicle_plate_no = TextEditingController();
        }catch(e){
          print('ERROR IN THE CURRENT LOCATION (in the form)' + '${e.toString()}');
        }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  automaticallyImplyLeading: false, // Removes the back arrow
  title: Text(
    'Register',
    style: TextStyle(
      fontSize: 33, // Increases the font size
    ),
  ),
),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: fname,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter first name';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: lname,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter last name';
                          }
                          return null;
                        },
                        //onSaved: (value) => _lastName = value!,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                 Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: nic,
                        decoration: InputDecoration(
                          labelText: 'NIC',
                          prefixIcon: Icon(Icons.card_membership),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter NIC';
                          }
                          return null;
                        },
                        //onSaved: (value) => _firstName = value!,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: address,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          prefixIcon: Icon(Icons.house_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter the address';
                          }
                          return null;
                        },
                        //onSaved: (value) => _lastName = value!,
                      ),
                    ),
                  ],
                ),
                 SizedBox(height: 16),
                 Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: phone,
                      //  keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                        ],
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if(!RegExp(r'^\+\d{1,3}\s?\d+$').hasMatch(value!) && value.isNotEmpty){
                            return 'Should be +94 phone no.';
                          }
                          if (value == null || value.isEmpty) {
                            return 'Enter phone no.';
                          }
                          return null;
                        },
                        //onSaved: (value) => _firstName = value!,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter the email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Enter a valid mail';
                    }
                    return null;
                  },
                 // onSaved: (value) => _email = value!,
                ),
                    ),
                  ],
                ),
                 SizedBox(height: 16),
                 Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: brand,
                        decoration: InputDecoration(
                          labelText: 'Brand',
                          prefixIcon: Icon(Icons.commute_sharp),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter vehicle brand';
                          }
                          return null;
                        },
                        //onSaved: (value) => _firstName = value!,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: plate_no,
                        decoration: InputDecoration(
                          labelText: 'Plate no.',
                          prefixIcon: Icon(Icons.car_rental),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter plate no.';
                          }
                          return null;
                        },
                        //onSaved: (value) => _lastName = value!,
                      ),
                    ),
                  ],
                ),
                 SizedBox(height: 16),
                 TextFormField(
                  controller: problem,
                        decoration: InputDecoration(
                          labelText: 'Problem',
                          prefixIcon: Icon(Icons.question_mark),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter the problem';
                          }
                          return null;
                        },
                        //onSaved: (value) => _firstName = value!,
                      ),
                SizedBox(height: 16),
                                 TextFormField(
                  controller: vehicle_plate_no,
                        decoration: InputDecoration(
                          labelText: 'Carrier Vehicle plate number',
                          prefixIcon: Icon(Icons.no_crash_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter the carrier vehicle plate number';
                          }
                          return null;
                        },
                        //onSaved: (value) => _firstName = value!,
                      ),
                SizedBox(height: 20),
               ElevatedButton(
  style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white, backgroundColor: Color.fromARGB(255, 29, 129, 211),
    
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  ),
  child: Padding(
    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
    child: Text(
      'Submit',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    ),
  ),
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
            child: const Text("Ok"),
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
                  if(longi_current != null || longi_current != null){
                                      if(_formKey.currentState!.validate()){
                             try {
int year = current_date.year;
int month = current_date.month;
int day = current_date.day;
String today = '$year-$month-$day';

dbConn d2 = dbConn();
MssqlConnection conn2 = await d2.connection();

            String fname2 = fname?.text ?? '';
            String lname2 = lname?.text ?? '';
            String nic2 = nic?.text ?? '';
            String today2 = today;
            String address2 = address?.text ?? '';
            String phone2 = phone?.text ?? '';
            String email2 = email?.text ?? '';
            String brand2 = brand?.text ?? '';
            String plate_no2 = plate_no?.text ?? '';
            String problem2 = problem?.text ?? '';
            String carrier_plate_no = vehicle_plate_no?.text ?? '';

double lati_current2 = lati_current != null ? double.parse(lati_current.toString()) : 0.0;
double longi_current2 = longi_current != null ? double.parse(longi_current.toString()) : 0.0;
var emid = widget.passValue['EmployeeID'];
                            String query = "INSERT INTO carrierServiceCustomers(firstName,lastName,NIC,Date,address,phone,mail,brand,vehiclePlateNumber,problem,accidentLocationAddress,latitude_cuslocation,longitude_cuslocation,approvalStatus,emID,billedStatus) VALUES('$fname2','$lname2','$nic2','$today2','$address2','$phone2','$email2','$brand2','$plate_no2','$problem2','Call',$lati_current2,$longi_current2,'TRUE','$emid',0)";
                            await conn2.writeData(query);
                            String query_forNew_serviceID = "SELECT serviceID FROM carrierServiceCustomers WHERE NIC = '$nic2'";
                            String result = await conn2.getData(query_forNew_serviceID);
                            List<dynamic> result_of_newserviceID = [];
                            result_of_newserviceID = jsonDecode(result);
                             var newServiceId; //new service ID
                            for(var current_new_serviceid in result_of_newserviceID){
                              newServiceId = current_new_serviceid['serviceID'];
                            }
                            //int newIntSerId = int.parse(newServiceId);
                            //SELECT THE VEHICLE ID using the vehicle plate no
                            String query_carrierVehicleId = "SELECT vehicleID FROM carrierVehiclesInfo WHERE plateNumber = '$carrier_plate_no'";
                            String result2 = await conn2.getData(query_carrierVehicleId);
                            List<dynamic>result_of_carrierVehicleID = [];
                            result_of_carrierVehicleID = jsonDecode(result2); //vehicle ID (carrier)
                            var current_carrier_vehicleID;
                            for(var carrier_vehicle_holder in result_of_carrierVehicleID){
                              current_carrier_vehicleID = carrier_vehicle_holder['vehicleID'];
                            }
                            //int current_carrierInt_vehicleID = int.parse(current_carrier_vehicleID);

                            //INSERTING THE CARRIER VEHICLE HISTORY
                            String query_of_carrierVehicleHistory = "INSERT INTO carrierServiceVehicleHistory(serviceID,vehicleID) VALUES('$newServiceId','$current_carrier_vehicleID')";
                             await conn2.writeData(query_of_carrierVehicleHistory);

                             //inserting data to the driver work
                             String query_of_driverWork = "INSERT INTO driverWork(status,driverID,serviceID) VALUES(1,'$emid','$newServiceId')";
                             await conn2.writeData(query_of_driverWork);
                            //print('CURRENT CARRIER VEHICLE ID' + current_carrier_vehicleID.toString()); to test
                           // print('NEW SERVICE ID '+newServiceId.toString()); //to test only
                             ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Submitted')),
                      );

                            } catch (e) {
                              print(e.toString());
                             ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error occured when sending data : ' + e.toString())),
                      );
                            }
                       }
                  }else{
                     _returnLocationError();
                  }
                 }
                  },
                 
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
