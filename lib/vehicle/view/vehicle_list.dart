import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/vehicle/modal/vehicle_modal.dart';

class VehicleList extends StatefulWidget {
  final List<Vehicle> vehicles;

  VehicleList({required this.vehicles});

  @override
  _VehicleListState createState() => _VehicleListState();
}

class _VehicleListState extends State<VehicleList> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fuelEfficiencyController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  void _addVehicle() async {
    String name = _nameController.text.trim();
    double? fuelEfficiency = double.tryParse(_fuelEfficiencyController.text.trim());
    int? age = int.tryParse(_ageController.text.trim());

    if (name.isEmpty || fuelEfficiency == null || age == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter valid details'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    await FirebaseFirestore.instance.collection('vehicles').add({
      'name': name,
      'fuelEfficiency': fuelEfficiency,
      'age': age,
    });

    // Clear the text fields
    _nameController.clear();
    _fuelEfficiencyController.clear();
    _ageController.clear();

    Navigator.pop(context); 
    setState(() {}); 
  }

  

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( 
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = widget.vehicles[index];
              Color color = Colors.red;

              if (vehicle.fuelEfficiency >= 15 && vehicle.age <= 5) {
                color = Colors.green;
              } else if (vehicle.fuelEfficiency >= 15 && vehicle.age > 5) {
                color = Colors.amber;
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(vehicle.name),
                  subtitle: Text(
                      'Fuel Efficiency: ${vehicle.fuelEfficiency} km/l, Age: ${vehicle.age} years'),
                  tileColor: color,
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: ElevatedButton(
              onPressed: _showAddVehicleDialog,
              child: Text('Add Vehicle'),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddVehicleDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Vehicle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Vehicle Name'),
              ),
              TextField(
                controller: _fuelEfficiencyController,
                decoration: InputDecoration(labelText: 'Fuel Efficiency (km/l)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age (years)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _addVehicle,
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
