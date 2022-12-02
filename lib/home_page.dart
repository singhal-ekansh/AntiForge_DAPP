import 'package:anti_forge_dapp/medicine_details.dart';
import 'package:anti_forge_dapp/supply_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SupplyServices medicineChainInstance;

  @override
  Widget build(BuildContext context) {
    medicineChainInstance = Provider.of<SupplyServices>(context, listen: true);

    return Scaffold(
      appBar: AppBar(title: const Text("Medical Chain Management")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/add_medicine');
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Icon(Icons.medical_services_sharp),
                      SizedBox(width: 15),
                      Expanded(
                          child: Text(
                        "Manufacture Add Medicine",
                        style: TextStyle(fontSize: 16),
                      )),
                    ],
                  ),
                )),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    scanAndGetQrCode(context, 0);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Icon(Icons.bike_scooter),
                        SizedBox(width: 15),
                        Expanded(
                            child: Text(
                          "Transporter1 Pick Medicine",
                          style: TextStyle(fontSize: 16),
                        )),
                      ],
                    ),
                  ))),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    scanAndGetQrCode(context, 1);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Icon(Icons.factory),
                        SizedBox(width: 15),
                        Expanded(
                            child: Text(
                          "Wholesaler collects medicine",
                          style: TextStyle(fontSize: 16),
                        )),
                      ],
                    ),
                  ))),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    scanAndGetQrCode(context, 2);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Icon(Icons.bike_scooter),
                        SizedBox(width: 15),
                        Expanded(
                            child: Text(
                          "Transporter2 pick medicine",
                          style: TextStyle(fontSize: 16),
                        )),
                      ],
                    ),
                  ))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {
                  scanAndGetQrCode(context, 3);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Icon(Icons.person),
                      SizedBox(width: 15),
                      Expanded(
                          child: Text(
                        "Distributor collects medicine",
                        style: TextStyle(fontSize: 16),
                      )),
                    ],
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {
                  scanAndGetQrCode(context, 4);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Icon(Icons.qr_code),
                      SizedBox(width: 15),
                      Expanded(
                          child: Text(
                        "Check Medicine Details",
                        style: TextStyle(fontSize: 16),
                      )),
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }

  Future<void> scanAndGetQrCode(
      BuildContext context, int functionNumber) async {
    final result = await Navigator.pushNamed(context, '/scan_medicine');
    switch (functionNumber) {
      case 0:
        medicineChainInstance.pickMedicineFromManufacture(result.toString());
        break;
      case 1:
        medicineChainInstance.receiveMedicineByWholesaler(result.toString());
        break;
      case 2:
        medicineChainInstance.pickMedicineFromWholesaler(result.toString());
        break;
      case 3:
        medicineChainInstance.receiveMedicineByDistributor(result.toString());
        break;
      case 4:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MedicineDetails(qrCode: result.toString())));
    }
  }
}
