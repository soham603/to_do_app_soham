import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:play_store/Screens/add_note_screen.dart';
import 'package:play_store/widgets/drawer_screen.dart';
import 'package:play_store/widgets/stream_notes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}

bool show = true;

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        if (notification.direction == ScrollDirection.forward) {
          setState(() {
            show = true;
          });
        }
        if (notification.direction == ScrollDirection.reverse) {
          setState(() {
            show = false;
          });
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TO DO'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Information'),
                      content: Container(
                        height: 130,
                        child: const Column(
                          children: [
                            Text('Things to Note Down:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            SizedBox(height: 7,),
                            Text('1. You can delete the note by sliding right side.', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                            SizedBox(height: 7,),
                            Text('2. You will have 30 sec time to get back your deleted note in case you delete it by mistake.', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.info),
            ),
          ],
        ),
        drawer: MyDrawer(),
        backgroundColor: Colors.white,
        floatingActionButton: Visibility(
          visible: show,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AddScreen(),
              ));
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.add),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              DoneNotes(false),
              const SizedBox(height: 10,),
              const Text('Completed Tasks', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              DoneNotes(true),
            ],
          ),
        ),
      ),
    );
  }
}
