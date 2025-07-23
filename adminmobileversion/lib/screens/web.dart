import 'package:adminmobileversion/screens/driverMenu.dart';
import 'package:adminmobileversion/screens/moreInfoCompleted.dart';
import 'package:adminmobileversion/sqflite_helper.dart';
import 'package:flutter/material.dart';
import 'package:adminmobileversion/mssqlDB.dart';
import 'package:adminmobileversion/screens/driverWorkMoreInfo.dart';
import 'package:flutter/material.dart';
import 'package:mssql_connection/mssql_connection.dart';
import 'dart:convert';

import 'package:restart_app/restart_app.dart';
class CompletedEvents extends StatefulWidget {
  final Map<String, dynamic> passValue;
  const CompletedEvents(this.passValue);
  @override
  State<CompletedEvents> createState() => _CompletedEventsState();
}
class _CompletedEventsState extends State<CompletedEvents> {
 GlobalKey key = GlobalKey();

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
    bool isLoading2 = true; // To indicate data loading
  SqfliteHelper helper = SqfliteHelper();
  bool reDrawTheUi = true;

  //canceled data store
  List<dynamic> storeCancelData = [];//store cancel data row (in the sql lite table)
  List<dynamic> storeCancelServiceId = []; //store the service id's of canceled rows

  List<dynamic> CustomerInfo_forcanceled = [];//store the customer info for cancel part
  List<dynamic> carrierVehicleInfo_forcanceled = [];//store the vehicle plate number
  
  List<dynamic> cusNamesIndi_forcanceled = [];//individual customer names
  List<dynamic> dateIndi_forcanceled = [];//indivifual date
  List<dynamic> cusContactIndi_forcanceled = [];//individual customer contact
  List<dynamic> nicIndi_forcanceled = [];//individual NIC
  List<dynamic> vehiIndi_forcanceled = [];//individual vehicle ID


 //saved data store
     bool isLoading22 = true;
  List<dynamic> storeCancelData2 = [];//store cancel data row (in the sql lite table)
  List<dynamic> storeCancelServiceId2 = []; //store the service id's of canceled rows

  List<dynamic> CustomerInfo_forcanceled2 = [];//store the customer info for cancel part
  List<dynamic> carrierVehicleInfo_forcanceled2 = [];//store the vehicle plate number
  
  List<dynamic> cusNamesIndi_forcanceled2 = [];//individual customer names
  List<dynamic> dateIndi_forcanceled2 = [];//indivifual date
  List<dynamic> cusContactIndi_forcanceled2 = [];//individual customer contact
  List<dynamic> nicIndi_forcanceled2 = [];//individual NIC
  List<dynamic> vehiIndi_forcanceled2 = [];//individual vehicle ID

void clean(){
   storeCancelData.clear();
   storeCancelServiceId.clear(); //store the service id's of canceled rows
   CustomerInfo_forcanceled.clear();
   carrierVehicleInfo_forcanceled.clear();//store the vehicle plate number
   cusNamesIndi_forcanceled.clear();//individual customer names
   dateIndi_forcanceled.clear();//indivifual date
   cusContactIndi_forcanceled.clear();//individual customer contact
   nicIndi_forcanceled.clear();//individual NIC
   vehiIndi_forcanceled.clear();//individual vehicle ID
}
 Future<void> savedDataObtainer() async {
    try{
      //clean();
      dbConn d1 = dbConn(); // Object of DB class
      MssqlConnection conn = await d1.connection(); // Get the MS SQL DB connection
        storeCancelData2 = await helper.getSavedEvents();
    for(var tempCancelHolder in storeCancelData2){
      storeCancelServiceId2.add('${tempCancelHolder['serviceID']}'); //service ID storage
    }
    //print('saved activities are fetched' + '${storeCancelServiceId2}');
    if(storeCancelServiceId2.isEmpty){
        setState(() => isLoading22= false);
        return;
    }
    for(var serviceId_holder in storeCancelServiceId2){
        String query2 = "SELECT * FROM carrierServiceCustomers WHERE serviceID = $serviceId_holder";
        String result2 = await conn.getData(query2);
        CustomerInfo_forcanceled2.add(jsonDecode(result2));//obtain the customer info as a JSON 

        String query3 = "SELECT plateNumber FROM carrierVehiclesInfo WHERE vehicleID = (SELECT vehicleID FROM carrierServiceVehicleHistory WHERE serviceID = ${serviceId_holder})";
        String result3 = await conn.getData(query3);
        carrierVehicleInfo_forcanceled2.add(jsonDecode(result3));//obtain the vehicle plate num
    }
      for (var cusNameget in CustomerInfo_forcanceled2) {
        for (var cusNameget2 in cusNameget) {
          cusNamesIndi_forcanceled2.add('${cusNameget2['firstName']}' + ' ${cusNameget2['lastName']}');
          dateIndi_forcanceled2.add('${cusNameget2['Date']}');
          cusContactIndi_forcanceled2.add('${cusNameget2['phone']}');
          nicIndi_forcanceled2.add('${cusNameget2['NIC']}');
        }
      }
      for(var vehi1 in carrierVehicleInfo_forcanceled2){
        for(var vehi2 in vehi1){
          vehiIndi_forcanceled2.add('${vehi2['plateNumber']}');
        }
      }
      setState(() => isLoading22 = false);
    }catch(e){
      print('Error IN THE CANCEL DATA OBTAINING PART'+e.toString());
    }
  }


  Future<void> cancelDataObtain() async {
    try{
      //clean();
      dbConn d1 = dbConn(); // Object of DB class
      MssqlConnection conn = await d1.connection(); // Get the MS SQL DB connection
        storeCancelData = await helper.getTasks(0);
    for(var tempCancelHolder in storeCancelData){
      storeCancelServiceId.add('${tempCancelHolder['serviceID']}'); //service ID storage
    }
    print('canceled activities are fetched' + '${storeCancelServiceId}');
    if(storeCancelServiceId.isEmpty){
        setState(() => isLoading2= false);
        return;
    }
    for(var serviceId_holder in storeCancelServiceId){
        String query2 = "SELECT * FROM carrierServiceCustomers WHERE serviceID = $serviceId_holder";
        String result2 = await conn.getData(query2);
        CustomerInfo_forcanceled.add(jsonDecode(result2));//obtain the customer info as a JSON 

        String query3 = "SELECT plateNumber FROM carrierVehiclesInfo WHERE vehicleID = (SELECT vehicleID FROM carrierServiceVehicleHistory WHERE serviceID = ${serviceId_holder})";
        String result3 = await conn.getData(query3);
        carrierVehicleInfo_forcanceled.add(jsonDecode(result3));//obtain the vehicle plate num
    }
      for (var cusNameget in CustomerInfo_forcanceled) {
        for (var cusNameget2 in cusNameget) {
          cusNamesIndi_forcanceled.add('${cusNameget2['firstName']}' + ' ${cusNameget2['lastName']}');
          dateIndi_forcanceled.add('${cusNameget2['Date']}');
          cusContactIndi_forcanceled.add('${cusNameget2['phone']}');
          nicIndi_forcanceled.add('${cusNameget2['NIC']}');
        }
      }
      for(var vehi1 in carrierVehicleInfo_forcanceled){
        for(var vehi2 in vehi1){
          vehiIndi_forcanceled.add('${vehi2['plateNumber']}');
        }
      }
      setState(() => isLoading2 = false);
    }catch(e){
      print('Error IN THE CANCEL DATA OBTAINING PART'+e.toString());
    }
  }
   @override
   void initState(){
    super.initState();
    try{
    dbProcess1(); 
    cancelDataObtain();// Fetch data when the widget initializes
    savedDataObtainer();
    }catch(e){
      print('ERROR IN THE CONSTRUCTOR' + e.toString());
    }
  }
  Future<void> dbProcess1() async {
    try {
      dbConn d1 = dbConn(); // Object of DB class
      MssqlConnection conn = await d1.connection(); // Get the MS SQL DB connection
      print("connected to DB using conn OUT1");

      var em_id = widget.passValue['EmployeeID'];
      passDriverId = em_id;
      String query = "SELECT * FROM driverWork WHERE driverID = $em_id AND status = 1";
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
    return Scaffold(
      body: SafeArea(
        child: isLoading
        ? Center(child: CircularProgressIndicator())
        :Column(
          children: [
           SizedBox(
            height: 694,
            child:  DefaultTabController(
              length: 3,
              child: Scaffold(
                appBar:AppBar(
  automaticallyImplyLeading: false, // This line removes the back arrow
  actions: [
    // Added Refresh Button
     IconButton(
          onPressed: () {
            //dbProcess1();
                      /**
                       * Navigator.push(context,MaterialPageRoute(
                      builder: (context)=> CompletedEvents(widget.passValue),
                      ));
                       */
                      try{
                        DriverScreen d1 = new DriverScreen(widget.passValue);
                        d1.refreshWeb(1);
                     Navigator.push(context,MaterialPageRoute(
                      builder: (context)=> d1,
                      ));
    }catch(e){
      print('ERROR IN THE CONSTRUCTOR' + e.toString());
    }

          },
          icon: Icon(Icons.refresh),
          tooltip: "Refresh",
        ),
  ],
  bottom: const TabBar(
    indicator: BoxDecoration(),
    tabs: [
      Tab(
        text: 'Canceled',
      ),
      Tab(
        text: 'Completed',
      ),
      Tab(
        text: 'Saved',
      ),
    ],
  ),
  title: Text(
  'Activities',
  style: TextStyle(
    fontSize: 33,
  ),
),

),
                body: TabBarView(
                  children: [
                    Container(
                      child: isLoading2
                      ? Center(child: CircularProgressIndicator())
                      :CustomerInfo_forcanceled.isEmpty
                      ?Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/cancelImage.png', // Make sure to add this image to your assets
                                  width: 240,
                                  height: 240,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No Canceled Activities',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'There are no canceled activities to display',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                          :
                      ListView(
                        key: key,
                        children: [
                              //CARD START
           for (int i = 0; i < CustomerInfo_forcanceled.length; i++)
          Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.directions_car,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                 Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${cusNamesIndi_forcanceled[i]}', //customer name
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Reserved date - ${dateIndi_forcanceled[i]}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Contact - ${cusContactIndi_forcanceled[i]}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                     Text(
                      'NIC - ${nicIndi_forcanceled[i]}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                     Text(
                      'Carrier Vehicle Number - ${vehiIndi_forcanceled[i]}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Canceled',
                  style: TextStyle(
                    color: Color.fromARGB(255, 218, 5, 5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                     Navigator.push(context,MaterialPageRoute(
                                    builder: (context)=>moreInfoCompleted(passSerId: storeCancelServiceId[i], passPlateNum: vehiIndi_forcanceled[i]),
                      ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'More Info',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
//CARD END
                        ],
                      ),
                      //😎😎😎😎😎😎😎😎😎😎😎😎😎😎😎😎😎😎😎😎😎😎😎😎😎😎😎😎😎
                    ),
                    
                    //COMPLETED SECTION START
                     Container(
                      //🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖
  child: CustomerInfo.isEmpty ?
  Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/cancelImage.png', // Make sure to add this image to your assets
                                  width: 250,
                                  height: 250,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No completed Activities',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'There are no completed activities to display',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
  : Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: SizedBox(
      child: ListView(
        children: [
          SizedBox(height: 4),
          Row(
  children: [
    SizedBox(width: 58), 
    Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // Button pressed action
            print("Button Pressed!");
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            backgroundColor: const Color.fromARGB(255, 41, 39, 176), // Button color
            foregroundColor: Colors.white, // Text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Rounded edges
            ),
            elevation: 10, // Shadow effect
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Custom',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    SizedBox(width: 8), // Add gap between the two buttons
    Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // Button pressed action
            print("Button Pressed!");
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            backgroundColor: Color.fromARGB(255, 41, 39, 176), // Button color
            foregroundColor: Colors.white, // Text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Rounded edges
            ),
            elevation: 10, // Shadow effect
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Show All',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ],
),
/**
 * Row(
  children: [
Align(
  alignment: Alignment.center, // Align the text to the center
  child: Text(
    'This month result',
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
),
    
  ],
),
 */
          //CARD START
           for (int i = 0; i < CustomerInfo.length; i++)
          Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.directions_car,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                 Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${cusNamesIndi[i]}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Reserved date - ${dateIndi[i]}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Contact - ${cusContactIndi[i]}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                     Text(
                      'NIC - ${nicIndi[i]}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                     Text(
                      'Carrier Vehicle Number - ${vehiIndi[i]}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Completed',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                     Navigator.push(context,MaterialPageRoute(
                                    builder: (context)=>moreInfoCompleted(passSerId: serviceID[i], passPlateNum: vehiIndi[i]),
                      ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'More Info',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),



//CARD END
        ],
      ),
      
    ),
  ),
),

                      //COMPLETED SECTION START
                     Container(
                      child: isLoading22
                      ? Center(child: CircularProgressIndicator())
                      :CustomerInfo_forcanceled2.isEmpty
                      ?Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/cancelImage.png', // Make sure to add this image to your assets
                                  width: 240,
                                  height: 240,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No Saved Activities',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'There are no canceled activities to display',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                          :
                      ListView(
                        children: [
                              //CARD START
           for (int i = 0; i < CustomerInfo_forcanceled2.length; i++)
          Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.directions_car,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                 Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${cusNamesIndi_forcanceled2[i]}', //customer name
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Reserved date - ${dateIndi_forcanceled2[i]}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Contact - ${cusContactIndi_forcanceled2[i]}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                     Text(
                      'NIC - ${nicIndi_forcanceled2[i]}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                     Text(
                      'Carrier Vehicle Number - ${vehiIndi_forcanceled2[i]}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Saved',
                  style: TextStyle(
                    color: Color.fromARGB(255, 218, 5, 5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                     Navigator.push(context,MaterialPageRoute(
                                    builder: (context)=>moreInfoCompleted(passSerId: storeCancelServiceId2[i], passPlateNum: vehiIndi_forcanceled2[i]),
                      ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'More Info',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
//CARD END
                        ],
                      ),
                      //🙃🙃🙃🙃🙃🙃🙃🙃🙃🙃🙃🙃🙃🙃🙃🙃🙃🙃🙃🙃🙃🙃🙃🙃🙃🙃🙃🙃🙃🙃🙃🙃🙃🙃🙃🙃🙃
                    ),


                  ],
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