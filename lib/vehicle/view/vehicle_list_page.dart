import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list_app/vehicle/modal/vehicle_modal.dart';
import 'package:todo_list_app/vehicle/view/vehicle_list.dart';

class VehicleListPage extends StatelessWidget {
  Future<List<Vehicle>> fetchVehicles() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('vehicles').get();
  return querySnapshot.docs.map((doc) {
    return Vehicle(
      name: doc['name'],
      fuelEfficiency: (doc['fuelEfficiency'] as num).toDouble(), // Ensure double type
      age: doc['age'],
    );
  }).toList();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle List'),
      ),
      body: FutureBuilder<List<Vehicle>>(
        future: fetchVehicles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No vehicles found.'));
          } else {
            return VehicleList(vehicles: snapshot.data!);
          }
        },
      ),
    );
  }
}