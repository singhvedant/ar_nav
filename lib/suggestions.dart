import 'package:flutter/material.dart';

class Suggestions extends StatelessWidget {
  const Suggestions({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: SizedBox(
        width: 300,
        height: 100,
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: const [
              Icon(Icons.location_pin),
              SizedBox(
                height: 8,
              ),
              Text('Your last searched location'),
            ],
          ),
        )),
      ),
    );
  }
}
