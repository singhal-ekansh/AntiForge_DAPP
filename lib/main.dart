import 'package:anti_forge_dapp/add_medicine_page.dart';
import 'package:anti_forge_dapp/home_page.dart';
import 'package:anti_forge_dapp/medicine_details.dart';
import 'package:anti_forge_dapp/qr_scanner.dart';
import 'package:anti_forge_dapp/supply_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SupplyServices(),
      child: MaterialApp(
        title: "SupplyChain",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/add_medicine': (context) => const AddMedicine(),
          '/scan_medicine': (context) => const QrScanner(),
        },
      ),
    );
  }
}
