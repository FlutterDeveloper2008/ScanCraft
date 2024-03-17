import 'package:flutter/material.dart';
import 'qrgen.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  Container adds = Container(
    child: Center(
      child: Text(
        'Generate',
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(
            height: 150,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              cursorColor: Colors.green,
              cursorErrorColor: Colors.green,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  hintText: 'Enter Data',
                  hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  fillColor: Colors.green,
                  hoverColor: Colors.green,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(15))),
              controller: controller,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => gen1(website: controller.text)));
              },
              child: SizedBox(height: 40, child: adds),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          )
        ],
      ),
    );
  }
}
