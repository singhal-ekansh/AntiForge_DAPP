import 'dart:convert';
import 'dart:core';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

import 'logs_model.dart';
import 'medicine_model.dart';

class SupplyServices extends ChangeNotifier {
  final String _rpcUrl = 'HTTP://127.0.0.1:7545';
  final String _wsUrl = 'ws://127.0.0.1:7545/';

  final String privateKeyManufacture =
      "e04ae1b2a3b18347ad777a372d8cd7778fff9625dc9dbd36b044fc10d57bd71c";
  final String privateKeyTransporter1 =
      "77f7c11020353c22b291bffe5c9c8531a124c2a6c261eb4765d152251bbf73d3";
  final String privateKeyWholesaler =
      "bf5ef59d0a2c91ba9dac951c9169cef4785ae9f5041f2b99cf0e6ea354ef6fba";
  final String privateKeyTransporter2 =
      "55261da52458d3409f070a02ec332c387c0ce982060e82304d8c15d5441eacfb";
  final String privateKeyDistributor =
      "96b673d12d4b5414311c345e95b575104218b1aa56c89055c3efcce34ca8b667";

  // final Map<String, String> stakeholders = {
  //   "0x1C51175a52b3c299eC02307A24505D14bff44810": "Manufacture",
  //   "0xc05Aefd2434612028cC741f37685D0a660c49F9a": "Transporter",
  //   "0xa1e0b0D28d77F77b415E0844C33186B83870F9ec": "Wholesaler",
  //   "0x6A9e8eE7D7aA466B4CBFbf4e3AEE4e6B80F51779": "Transporter",
  //   "0x8BA4451D579697314cCfa612132A4660D9182147": "Distributor"
  // };

  late Web3Client _web3client;
  late String _abiCode;
  int totalMedicines = 0;
  var uuid = const Uuid();
  Medicine? medicineScanned;
  String medicineName = "";
  String newHashCode = "";

  late EthereumAddress _contractAddress;
  late Credentials manufactureCredentials;
  late Credentials transporter1Credentials;
  late Credentials wholesalerCredentials;
  late Credentials transporter2Credentials;
  late Credentials distributorCredentials;
  late EthereumAddress _ownAddress;
  late DeployedContract _contract;

  late ContractFunction _createMedicine;
  late ContractFunction _getScannedMedicineDetail;
  late ContractFunction _manufactureToTransport;
  late ContractFunction _toWholesaler;
  late ContractFunction _wholesaleToTransport;
  late ContractFunction _toDistributor;
  late ContractFunction _toCustomer;

  SupplyServices() {
    init();
  }

  Future<void> init() async {
    _web3client = Web3Client(_rpcUrl, http.Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    await getAbi();
    await getCredentials();
    await getDeployedContracts();
  }

  Future<void> getAbi() async {
    String abiStringFile =
        await rootBundle.loadString("build/contracts/SupplyChain.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    manufactureCredentials = EthPrivateKey.fromHex(privateKeyManufacture);
    transporter1Credentials = EthPrivateKey.fromHex(privateKeyTransporter1);
    wholesalerCredentials = EthPrivateKey.fromHex(privateKeyWholesaler);
    transporter2Credentials = EthPrivateKey.fromHex(privateKeyTransporter2);
    distributorCredentials = EthPrivateKey.fromHex(privateKeyDistributor);

    // _ownAddress = await _credentials.extractAddress();
  }

  Future<void> getDeployedContracts() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "SupplyChain"), _contractAddress);
    _createMedicine = _contract.function("createMedicine");
    _getScannedMedicineDetail = _contract.function("getScannedMedicineDetails");
    _manufactureToTransport =
        _contract.function("transporterReceiveMedicineFromManufacture");
    _toWholesaler = _contract.function("wholesalerReceiveMedicine");
    _wholesaleToTransport =
        _contract.function("transporterReceiveMedicineFromWholesaler");
    _toDistributor = _contract.function("distributorReceiveMedicine");
    _toCustomer = _contract.function("soldToCustomer");
  }

  addMedicine(int id, String name, String expireDate) async {
    newHashCode = uuid.v1();

    await _web3client.sendTransaction(
        manufactureCredentials,
        Transaction.callContract(
            contract: _contract,
            function: _createMedicine,
            parameters: [
              newHashCode,
              BigInt.from(id),
              name,
              expireDate,
              DateTime.now().millisecondsSinceEpoch.toString()
            ]));
    notifyListeners();
  }

  pickMedicineFromManufacture(String scannedId) async {
    await _web3client.sendTransaction(
        transporter1Credentials,
        Transaction.callContract(
            contract: _contract,
            function: _manufactureToTransport,
            parameters: [
              scannedId,
              DateTime.now().millisecondsSinceEpoch.toString()
            ]));
  }

  receiveMedicineByWholesaler(String scannedId) async {
    await _web3client.sendTransaction(
        wholesalerCredentials,
        Transaction.callContract(
            contract: _contract,
            function: _toWholesaler,
            parameters: [
              scannedId,
              DateTime.now().millisecondsSinceEpoch.toString()
            ]));
  }

  pickMedicineFromWholesaler(String scannedId) async {
    await _web3client.sendTransaction(
        transporter2Credentials,
        Transaction.callContract(
            contract: _contract,
            function: _wholesaleToTransport,
            parameters: [
              scannedId,
              DateTime.now().millisecondsSinceEpoch.toString()
            ]));
  }

  receiveMedicineByDistributor(String scannedId) async {
    await _web3client.sendTransaction(
        distributorCredentials,
        Transaction.callContract(
            contract: _contract,
            function: _toDistributor,
            parameters: [
              scannedId,
              DateTime.now().millisecondsSinceEpoch.toString()
            ]));
  }

  getScannedMedicine(String scannedId) async {
    var medicine = await _web3client.call(
        contract: _contract,
        function: _getScannedMedicineDetail,
        params: [scannedId]);

    List<Logs> logs = List.empty(growable: true);
    for (var log in medicine[0][5]) {
      logs.add(Logs(log[0].toString(), log[1].toString()));
    }
    medicineScanned = Medicine((medicine[0][0] as BigInt).toInt(),
        medicine[0][1], medicine[0][3], logs);

    notifyListeners();
  }
}
