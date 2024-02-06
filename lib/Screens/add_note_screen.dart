import 'package:flutter/material.dart';
import 'package:play_store/data/firestore.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final title = TextEditingController();
  final subtitle = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  int indexx = 0;

  List cardstitle = ['Sports', 'Meeting', 'Educational', 'Others', 'Important'];

  // Limit the title to 25 characters
  final int maxTitleCharacters = 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Note'),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title input taking:
                title_widget(),

                const SizedBox(
                  height: 10,
                ),

                // subtitle input:
                subtitle_widget(),

                const SizedBox(
                  height: 20,
                ),
                
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text('Swipe to select your activity card', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                      SizedBox(width: 3,),
                      Icon(Icons.keyboard_double_arrow_right),
                    ],
                  ),
                ),
                SizedBox(height: 10,),

                images_sel(),
                const SizedBox(
                  height: 10,
                ),

                buttonsss()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonsss() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () {
            Firestore_Datasource().AddNote(title.text, subtitle.text, indexx);
            Navigator.pop(context);
          },
          child: const Text("Add Task"),
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
            minimumSize: const Size(170, 50),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
            minimumSize: const Size(170, 50),
          ),
        ),
      ],
    );
  }

  Widget images_sel() {
    return Container(
      height: 190,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                indexx = index;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: indexx == index ? 6 : 2,
                  color: indexx == index ? Colors.red : Colors.black,
                ),
              ),
              width: 140,
              margin: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Image.asset('assets/${index}.jpg'),
                  const SizedBox(height: 5),
                  Text(
                    cardstitle[index],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget title_widget() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      focusNode: _focusNode1,
      controller: title,
      onChanged: (text) {
        // Limit the title to a maximum of maxTitleCharacters characters
        if (text.length > maxTitleCharacters) {
          setState(() {
            title.text = text.substring(0, maxTitleCharacters);
          });
        }
      },
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.green,
            width: 3,
          ),
        ),
        hintText: "Title",
        label: const Text("Enter Title"),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      obscureText: false,
    );
  }

  Widget subtitle_widget() {
    return TextFormField(
      textInputAction: TextInputAction.done,
      maxLines: 5,
      focusNode: _focusNode2,
      controller: subtitle,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.green,
            width: 3,
          ),
        ),
        hintText: "Sub - Title",
        label: const Text("Enter Subtitles"),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      obscureText: false,
    );
  }
}
