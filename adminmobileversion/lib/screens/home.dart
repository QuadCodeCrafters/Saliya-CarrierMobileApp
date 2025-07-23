import 'package:flutter/material.dart';
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: SingleChildScrollView(
          child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
              padding: EdgeInsets.only(left: 10),
              margin: EdgeInsets.only(bottom: 12),
              child: Text("Home",
              style: TextStyle(
              fontSize: 33,
              fontWeight: FontWeight.bold
            ),
            ),
              ),
            ),
        //  Spacer(),
        //CAR SET START
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'New Customers',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'This is a description of the card content. It provides more detail about the card and what it represents.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('ACTION 1'),
                    onPressed: () {/* Action 1 */},
                  ),
                  TextButton(
                    child: const Text('ACTION 2'),
                    onPressed: () {/* Action 2 */},
                  ),
                ],
              ),
            ],
          ),
          ),
          //CARD 2 -----------------------------------------
          Padding(padding: EdgeInsets.only(top: 12)),
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Current activity',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'This is a description of the card content. It provides more detail about the card and what it represents.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('ACTION 1'),
                    onPressed: () {/* Action 1 */},
                  ),
                  TextButton(
                    child: const Text('ACTION 2'),
                    onPressed: () {/* Action 2 */},
                  ),
                ],
              ),
            ],
          ),
          ),
          Padding(padding: EdgeInsets.only(top: 12)),
          //CARD 3--------------------------------------------------
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Today's income",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'This is a description of the card content. It provides more detail about the card and what it represents.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('ACTION 1'),
                    onPressed: () {/* Action 1 */},
                  ),
                  TextButton(
                    child: const Text('ACTION 2'),
                    onPressed: () {/* Action 2 */},
                  ),
                ],
              ),
            ],
          ),
          ),
          Padding(padding: EdgeInsets.only(top: 12)),
          //CARD 4-------------------------------------------
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Completed vehicles',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'This is a description of the card content. It provides more detail about the card and what it represents.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('ACTION 1'),
                    onPressed: () {/* Action 1 */},
                  ),
                  TextButton(
                    child: const Text('ACTION 2'),
                    onPressed: () {/* Action 2 */},
                  ),
                ],
              ),
            ],
          ),
          ),
          Padding(padding: EdgeInsets.only(top: 12)),
          //CARD 5 ---------------------------------------------------
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Live tracking',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'This is a description of the card content. It provides more detail about the card and what it represents.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('ACTION 1'),
                    onPressed: () {/* Action 1 */},
                  ),
                  TextButton(
                    child: const Text('ACTION 2'),
                    onPressed: () {/* Action 2 */},
                  ),
                ],
              ),
            ],
          ),
          ),
          
          //CARD SET END

          ],
         ),
        ),         
      ),
    );
  }
}
