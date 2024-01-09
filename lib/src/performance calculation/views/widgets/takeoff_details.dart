import 'package:flutter/material.dart';

class TakeoffDetails extends StatelessWidget {
  const TakeoffDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Takeoff Details")),
        body: const Center(
          child: Text("These are the takeoff details", style: TextStyle(color: Colors.white)),
        )
    );
  }
}
