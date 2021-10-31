import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class readData {
  late FirebaseFirestore firestore;

  init() {
    firestore = FirebaseFirestore.instance;
  }
}

class readDatas extends StatelessWidget {
  const readDatas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        FirebaseFirestore.instance
            .collection('users')
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            print(doc["first_name"]);
          });
        });

        // Otherwise, show something whilst waiting for initialization to complete
        return Notif("Error", Colors.red);
      },
    );
  }
}

class OpenDB extends StatelessWidget {
  Widget _app;
  OpenDB(this._app);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Notif("Error", Colors.red);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return this._app;
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Notif("Error", Colors.red);
      },
    );
  }
}

class checkCon extends StatelessWidget {
  Widget _app;
  checkCon(this._app);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Notif("Error", Colors.red);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return this._app;
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Notif("Error", Colors.red);
      },
    );
  }
}

checkConn() {
  return Notif("asd", Colors.red);
  /*
  return FutureBuilder(
    // Initialize FlutterFire
    future: Firebase.initializeApp(),
    builder: (context, snapshot) {
      // Check for errors
      if (snapshot.hasError) {
        return Notif("Error", Colors.red);
      }

      // Once complete, show your application
      if (snapshot.connectionState == ConnectionState.done) {
        return Notif("Connected", Colors.green);
      }

      // Otherwise, show something whilst waiting for initialization to complete
      return Notif("Error", Colors.red);
    },
  );
  */
}

class checkConnection extends StatelessWidget {
  String _message = "";
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Notif("Error", Colors.red);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return Notif("Success", Colors.green);
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Notif("Error", Colors.red);
      },
    );
  }
}

//Add users----------------------------------------------------------------------
class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  // String _fields, _dbcols;

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final _fname = TextEditingController();
    final _lname = TextEditingController();
    @override
    void dispose() {
      // Clean up the controller when the widget is disposed.
      _fname.dispose();
      _lname.dispose();
      super.dispose();
    }

    Future<void> addUser() {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      // Call the user's CollectionReference to add a new user
      return users
          .add({"name": _fname.text, "password": _lname.text})
          .then((value) => print("Inserted to Database"))
          .catchError((error) => print("Failed to Insert: $error"));
    }

    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: Column(
          children: [
            TextField(
              controller: _fname,
            ),
            TextField(
              controller: _lname,
            ),
            TextButton(
              onPressed: addUser,
              child: Text(
                "Add User",
              ),
            ),
          ],
        )),
      ],
    );
  }
}

//Notify Users
class Notif extends StatelessWidget {
  final String _message;
  Color _color;
  Notif(this._message, this._color);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      color: _color,
      width: 48.0,
      height: 48.0,
      child: Text(_message),
    );
  }
}

//Update Users----------------------------------------
class updateUser extends StatelessWidget {
  final String _userid;

  updateUser(this._userid);

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> updateUser() {
      // Call the user's CollectionReference to add a new user
      return users
          // existing document in 'users' collection: "ABC123"
          .doc(_userid)
          .set(
            {'name': "Admin2"},
            SetOptions(merge: true),
          )
          .then((value) =>
              print("'full_name' & 'age' merged with existing data!"))
          .catchError((error) => print("Failed to merge data: $error"));
    }

    return TextButton(
      onPressed: updateUser,
      child: Text(
        "Update User",
      ),
    );
  }
}

//GET Specific User--------------------------------------------------
class GetUser extends StatelessWidget {
  final String documentId;

  GetUser(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text("Full Name: ${data['name']} ${data['password']}");
        }

        return Text("loading");
      },
    );
  }
}

class GetAll extends StatelessWidget {
  final String documentId;

  GetAll(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc().get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text("Full Name: ${data['name']} ${data['password']}");
        }

        return Text("loading");
      },
    );
  }
}

class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final _fname = TextEditingController();
  final _lname = TextEditingController();
  final _fname2 = TextEditingController();
  final _lname2 = TextEditingController();
  String ID = "";
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> updateUser() {
    // Call the user's CollectionReference to add a new user
    return users
        // existing document in 'users' collection: "ABC123"
        .doc(ID)
        .set(
          {'name': _fname.text, 'password': _lname.text},
          SetOptions(merge: true),
        )
        .then(
            (value) => print("'full_name' & 'age' merged with existing data!"))
        .catchError((error) => print("Failed to merge data: $error"));
  }

  Future<void> showInformationDialog() async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Input Text"),
            actions: <Widget>[
              TextField(
                controller: _fname,
              ),
              TextField(
                controller: _lname,
              ),
              RaisedButton(
                  onPressed: () {
                    updateUser();
                  },
                  child: Text("Update")),
              RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Close"))
            ],
          );
        });
  }

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        if (!snapshot.hasData) {
          return Text("No Data");
        }

        return Container(
          height: 500,
          child: ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              var documentID;

              return ListTile(
                  title: Text("${data['name']}" '\n' "${data['password']}"),
                  subtitle: Text(document.id),
                  onTap: () async {
                    _fname.text = "${data['name']}";
                    _lname.text = "${data['password']}";
                    ID = document.id;
                    await showInformationDialog();
                  });
            }).toList(),
          ),
        );
      },
    );
  }
}
