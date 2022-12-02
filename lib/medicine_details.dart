import 'package:anti_forge_dapp/medicine_model.dart';
import 'package:anti_forge_dapp/supply_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MedicineDetails extends StatefulWidget {
  final String qrCode;

  const MedicineDetails({Key? key, required this.qrCode}) : super(key: key);

  @override
  State<MedicineDetails> createState() => _MedicineDetailsState();
}

class _MedicineDetailsState extends State<MedicineDetails> {
  @override
  Widget build(BuildContext context) {
    SupplyServices medicineChainInstance =
        Provider.of<SupplyServices>(context, listen: true);
    medicineChainInstance.getScannedMedicine(widget.qrCode);

    Medicine? medicine = medicineChainInstance.medicineScanned;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medicine Detail"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Medicine ID : ${medicine?.id}",
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Name : ${medicine?.name}",
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "expire date : ${medicine?.expireDate}",
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Medicine Shipment Details : ",
              style: TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: medicine?.logs.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Holder Address : ${medicine?.logs[medicine.logs.length - index - 1].holderAddress}",
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                            "Holder Role : ${medicineChainInstance.stakeholders[medicine?.logs[medicine.logs.length - index - 1].holderAddress]}"),
                        Text(
                            "Arrival Time : ${DateTime.fromMillisecondsSinceEpoch(int.parse(medicine?.logs[medicine.logs.length - index - 1].arrivalTime ?? "0"))}",
                            style: const TextStyle(fontSize: 15)),
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
