import 'package:ar_nav/model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MapBuilder extends StatefulWidget {
  const MapBuilder({super.key});

  @override
  State<MapBuilder> createState() => _MapBuilderState();
}

class _MapBuilderState extends State<MapBuilder> {
  List<PointNode> points = [];
  List<bool> sel = List.filled(10000, false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          ListView.builder(itemBuilder: _itemBuilder, itemCount: points.length),
      floatingActionButton: Column(
        children: [
          FloatingActionButton(
            onPressed: addNodeToMap,
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: getUserLocation,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget? _itemBuilder(BuildContext context, int index) {
    return GestureDetector(
      child: ListTile(
        title: Text('${points[index].x}, ${points[index].x}'),
        subtitle: Text(sel[index] ? "Selected" : ""),
      ),
      onTap: () {
        setState(() {
          sel[index] = !sel[index];
        });
      },
    );
  }

  void getUserLocation() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('unknown No allowed');
      }
    }
    var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );

    var point = PointNode(position.latitude, position.longitude);
    setState(() {
      points.add(point);
    });
  }

  void addNodeToMap() {}
}
