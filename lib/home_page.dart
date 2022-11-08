import 'package:anti_forge_dapp/supply_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var medicineCount = Provider.of<SupplyServices>(context, listen: true);

    return Scaffold(
        appBar: AppBar(title: const Text("Medicines")),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            medicineCount.addMedicine(
                420, "medic${medicineCount.totalMedicines}");
          },
          child: const Icon(Icons.add),
        ),
        body: Center(child: Text(medicineCount.totalMedicines.toString())));
  }
}
