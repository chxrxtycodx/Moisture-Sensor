import 'package:flutter/material.dart';

void main() {
  runApp(const MoistureMeterApp());
}

class MoistureMeterApp extends StatelessWidget {
  const MoistureMeterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MoistureMeterScreen(),
    );
  }
}

class MoistureMeterScreen extends StatefulWidget {
  @override
  _MoistureMeterScreenState createState() => _MoistureMeterScreenState();
}

class _MoistureMeterScreenState extends State<MoistureMeterScreen> {
  final List<Map<String, dynamic>> userPlants = [];
  final Map<String, double> plantMoistureLevels = {
    "Rose": 50,
    "Cactus": 20,
    "Oak Tree": 70,
    "Apple Tree": 65,
    "Blueberry Bush": 60,
  };

  // Fixed overall moisture level
  final double overallMoistureLevel = 45.0;

  final Map<String, IconData> plantIcons = {
    "Rose": Icons.local_florist,
    "Cactus": Icons.eco,
    "Oak Tree": Icons.nature,
    "Apple Tree": Icons.agriculture,
    "Blueberry Bush": Icons.grass,
  };

  void addPlant(String plant) {
    // Use the overallMoistureLevel as the initial currentMoisture
    setState(() {
      userPlants.add({
        "name": plant,
        "currentMoisture": overallMoistureLevel, // Fixed initial moisture
        "minRequiredMoisture": plantMoistureLevels[plant] ?? 50.0,
      });
    });
  }

  void deletePlant(int index) {
    setState(() {
      userPlants.removeAt(index);
    });
  }

  void _showAddPlantDialog() {
    String searchQuery = "";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Select a Plant"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search for a plant...",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: plantMoistureLevels.keys
                            .where((plant) =>
                                plant.toLowerCase().contains(searchQuery))
                            .map((plant) {
                          return ListTile(
                            leading: Icon(plantIcons[plant] ?? Icons.local_florist),
                            title: Text(plant),
                            subtitle: Text(
                                "Requires ${plantMoistureLevels[plant]}% moisture"),
                            onTap: () {
                              addPlant(plant);
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moisture Meter'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddPlantDialog,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Overall Moisture Level: ${overallMoistureLevel.toStringAsFixed(1)}%',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: userPlants.isEmpty
                ? Center(child: Text("No plants added. Tap + to add."))
                : ListView.builder(
                    itemCount: userPlants.length,
                    itemBuilder: (context, index) {
                      final plant = userPlants[index];
                      return Card(
                        margin: EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(plantIcons[plant["name"]] ?? Icons.local_florist, size: 40),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      plant["name"],
                                      style: TextStyle(
                                          fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Current Moisture: ${plant["currentMoisture"].toStringAsFixed(1)}%',
                                    ),
                                    Text(
                                      'Minimum Required: ${plant["minRequiredMoisture"].toStringAsFixed(1)}%',
                                      style: TextStyle(
                                        color: plant["currentMoisture"] >=
                                                plant["minRequiredMoisture"]
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black),
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                      Positioned(
                                        bottom: (plant["minRequiredMoisture"] / 100) * 100,
                                        child: Container(
                                          height: 2,
                                          width: 20,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      Container(
                                        height: (plant["currentMoisture"] / 100) * 100,
                                        width: 20,
                                        color: plant["currentMoisture"] >=
                                                plant["minRequiredMoisture"]
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => deletePlant(index),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}