
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
class SqfliteHelper {
  Future<Database> openMyDatabase() async {
    //test section
     final String? path = await getDatabasesPath();
     print('the path' + path!);
    //test section
    return await openDatabase(
        // join method is used to join the path of the database with the path of the app's document directory.
        join(await getDatabasesPath(), 'localData.db'),
        // The version of the database. This is used to manage database schema changes.
        version: 1,
        // onCreate is a callback function that is called ONLY when the database is created for the first time.
        onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE cancelledEvents(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, serviceID TEXT, status  INTEGER)',
      );
      //Here we are creating a table named todoList with three columns: id, title, and status.
      //The id column is the primary key and is set to autoincrement.    
      //We use INTEGER for the status column because SQLite does not have a boolean data type.
      //Instead, we use 0 for false and 1 for true.    
    });
  }

    Future<void> insertData(String service_id, bool status) async {
    //db is the instance of the database that we get from the openMyDatabase function.
    final db = await openMyDatabase();
    //after getting the database instance, we insert the task into the todoList table.
    //insert method takes three arguments: the name of the table, the data to be inserted, and the conflictAlgorithm.
    //data is a map with the column names as keys and the values to be inserted as values.
    //We use ConflictAlgorithm.replace to replace the task if it already exists.
    //here we don't need to insert the id column because it is set to autoincrement.
    db.insert(
        'cancelledEvents',
        {
          'serviceID': service_id,
          'status': status ? 1 : 0,
          //We use 1 for true and 0 for false.
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
   Future<void> deleteTask(int id) async {
    final db = await openMyDatabase();
    //delete method takes two arguments: the name of the table and the where clause.
    //we are using unique id for each task as the where clause to delete the task with the given id.
    db.delete('cancelledEvents', where: 'id = ?', whereArgs: [id]);
  }
   Future<void> updateTask(int id, bool status) async {
    final db = await openMyDatabase();
    //update method takes four arguments: the name of the table, the data to be updated, the where clause, and the whereArgs.
    //In this case, we are updating the status of the task with the given id.
    db.update(
        'cancelledEvents',
        {
          'status': status ? 1 : 0,
          //We use 1 for true and 0 for false.
        },
        where: 'id = ?',
        whereArgs: [id]);
  }
  Future<List<Map<String, dynamic>>> getTasks(int status) async {
    final db = await openMyDatabase();
    //query method is used to get the tasks from the cancelledEvents table.
    //It takes the name of the table as an argument.
    //and returns a list of maps where each map represents a task.
    //like [{id: 1, title: 'Task 1', status: 1}, {id: 2, title: 'Task 2', status: 0}]
    return await db.query(
    'cancelledEvents', // Table name
    where: 'status = ?', // WHERE clause
    whereArgs: [status], // Arguments for the placeholders
  );
  }
    Future<List<Map<String, dynamic>>> getTasksUsingServiceID(String service_id_para) async { //use in the finishing screen
    final db = await openMyDatabase();
    //query method is used to get the tasks from the cancelledEvents table.
    //It takes the name of the table as an argument.
    //and returns a list of maps where each map represents a task.
    //like [{id: 1, title: 'Task 1', status: 1}, {id: 2, title: 'Task 2', status: 0}]
    return await db.query(
    'cancelledEvents', // Table name
    where: 'serviceID = ?', // WHERE clause
    whereArgs: [service_id_para], // Arguments for the placeholders
  );
  }

   Future<Database> createNewTable() async {
    return await openDatabase(
        // join method is used to join the path of the database with the path of the app's document directory.
        join(await getDatabasesPath(), 'localData.db'),
        // The version of the database. This is used to manage database schema changes.
        version: 1,
        // onCreate is a callback function that is called ONLY when the database is created for the first time.
        onOpen: (db) {
      return db.execute(
        'CREATE TABLE cancelledEvents(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, serviceID TEXT, status  INTEGER)',
      );
    });
  }

  Future<void> insertSaveEvents(String service_id) async {
    //db is the instance of the database that we get from the openMyDatabase function.
    final db = await openMyDatabase();
    //after getting the database instance, we insert the task into the todoList table.
    //insert method takes three arguments: the name of the table, the data to be inserted, and the conflictAlgorithm.
    //data is a map with the column names as keys and the values to be inserted as values.
    //We use ConflictAlgorithm.replace to replace the task if it already exists.
    //here we don't need to insert the id column because it is set to autoincrement.
    db.insert(
        'savedEvents',
        {
          'serviceID': service_id,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
   Future<List<Map<String, dynamic>>> checkSavedData(String service_id_para) async { //use in the current work screen
    final db = await openMyDatabase();
    //query method is used to get the tasks from the cancelledEvents table.
    //It takes the name of the table as an argument.
    //and returns a list of maps where each map represents a task.
    //like [{id: 1, title: 'Task 1', status: 1}, {id: 2, title: 'Task 2', status: 0}]
    return await db.query(
    'savedEvents', // Table name
    where: 'serviceID = ?', // WHERE clause
    whereArgs: [service_id_para], // Arguments for the placeholders
  );
  }
  Future<void> deleteSavedEvents(String service_para_id) async {
    final db = await openMyDatabase();
    //delete method takes two arguments: the name of the table and the where clause.
    //we are using unique service_para_id for each task as the where clause to delete the task with the given service_para_id.
    db.delete('savedEvents', where: 'serviceID = ?', whereArgs: [service_para_id]);
  }
  Future<List<Map<String, dynamic>>> getSavedEvents() async {
    final db = await openMyDatabase();
    //query method is used to get the tasks from the cancelledEvents table.
    //It takes the name of the table as an argument.
    //and returns a list of maps where each map represents a task.
    //like [{id: 1, title: 'Task 1', status: 1}, {id: 2, title: 'Task 2', status: 0}]
    return await db.query(
    'savedEvents', // Table name
  );
  }

   Future<void> deleteAppData() async {
    final db = await openMyDatabase();
    db.delete('cancelledEvents');
    db.delete('savedEvents');
   }

   Future<List<Map<String, dynamic>>> checkTheSetting1(int id) async { //use in the current work screen
    final db = await openMyDatabase();
    //query method is used to get the tasks from the cancelledEvents table.
    //It takes the name of the table as an argument.
    //and returns a list of maps where each map represents a task.
    //like [{id: 1, title: 'Task 1', status: 1}, {id: 2, title: 'Task 2', status: 0}]
    return await db.query(
    'settings', // Table name
    where: 'id = ?', // WHERE clause
    whereArgs: [id], // Arguments for the placeholders
  );
  }
  Future<List<Map<String, dynamic>>> getStoredAccInfo(int id) async { //use in the current work screen
    final db = await openMyDatabase();
    //query method is used to get the tasks from the cancelledEvents table.
    //It takes the name of the table as an argument.
    //and returns a list of maps where each map represents a task.
    //like [{id: 1, title: 'Task 1', status: 1}, {id: 2, title: 'Task 2', status: 0}]
    return await db.query(
    'accDetailsLocal', // Table name
    where: 'id = ?', // WHERE clause
    whereArgs: [id], // Arguments for the placeholders
  );
  }
   Future<void> updateLocalAccDetails(String us_name,String identification_no,int id) async {
    final db = await openMyDatabase();
    //update method takes four arguments: the name of the table, the data to be updated, the where clause, and the whereArgs.
    //In this case, we are updating the status of the task with the given id.
    db.update(
        'accDetailsLocal',
        {
          'userName': us_name,
          'identificationNo' : identification_no
          //We use 1 for true and 0 for false.
        },
        where: 'id = ?',
        whereArgs: [id]);
  }
   Future<void> updateSettings(int id,int status) async {
    final db = await openMyDatabase();
    //update method takes four arguments: the name of the table, the data to be updated, the where clause, and the whereArgs.
    //In this case, we are updating the status of the task with the given id.
    db.update(
        'settings',
        {
          'status': status,
          //We use 1 for true and 0 for false.
        },
        where: 'id = ?',
        whereArgs: [id]);
  }
}