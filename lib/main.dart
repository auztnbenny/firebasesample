import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _messageController = TextEditingController();

  // Function to handle adding a message to Firestore
  Future<void> _addMessage(String message) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference messages =
          FirebaseFirestore.instance.collection('messages');

      // Add the message to Firestore
      await messages.add({
        'text': message,
        'timestamp': FieldValue.serverTimestamp(), // Add server timestamp
      });

      // Clear the text field after adding the message
      _messageController.clear();

      // Show a snackbar to indicate success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Message added successfully'),
        ),
      );
    } catch (e) {
      // Show a snackbar to indicate error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding message: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Firebase Example'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Enter your message',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Call the function to add the message
                _addMessage(_messageController.text);
              },
              child: Text('Add Message'),
            ),
          ],
        ),
      ),
    );
  }
}
