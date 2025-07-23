import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mssql_connection/mssql_connection.dart'; //pac 1
import 'dart:convert'; //pac 2
class dbConn{
  Future<MssqlConnection> connection() async { //a future function due to async
    bool Errstatus = false;
                   MssqlConnection mssqlConnection = MssqlConnection.getInstance();
                   bool isConnected = await mssqlConnection.connect(
  ip: '192.168.193.42', //always changes
  port: '1433',
  databaseName: 'webEditorData',
  username: 'saliyaAdmin001',
  password: 'saliya007#',
  timeoutInSeconds: 15,
);
if(!isConnected){
  //TODO: inform to the user in a proper way
  throw new Exception('failed to connect to the database');
}else{
 return mssqlConnection; //return the DB CON OBJECT after connecting 
}
  }
}