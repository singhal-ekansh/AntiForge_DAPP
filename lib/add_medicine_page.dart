import 'package:anti_forge_dapp/supply_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AddMedicine extends StatefulWidget {
  const AddMedicine({Key? key}) : super(key: key);

  @override
  State<AddMedicine> createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController expireController = TextEditingController();
  SupplyServices? medicineChainInstance;
  String qrCode = "";

  @override
  Widget build(BuildContext context) {
    medicineChainInstance = Provider.of<SupplyServices>(context, listen: true);
    // String medName = medicineChain.medicineName;
    qrCode = (medicineChainInstance?.newHashCode ?? "");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Supply Chain"),
      ),
      body: manufactureWidget(),
    );
  }

  Widget manufactureWidget() {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: idController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Medicine ID",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Medicine Name",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: expireController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Expire Date",
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                medicineChainInstance?.addMedicine(
                    int.parse(idController.text),
                    nameController.text.toString(),
                    expireController.text.toString());
              },
              child: const Text("Add Medicine")),
          qrCode.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: QrImage(
                      data: qrCode,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
