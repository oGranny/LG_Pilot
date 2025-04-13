import 'package:flutter/material.dart';

class InputBar extends StatelessWidget {
  const InputBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Type your message here...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              // Handle send action
            },
          ),
        ),
      ),
    );
  }
}
