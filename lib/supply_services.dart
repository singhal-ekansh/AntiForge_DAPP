import 'dart:convert';
import 'dart:core';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class SupplyServices extends ChangeNotifier {
  final String _rpcUrl = 'HTTP://127.0.0.1:7545';
  final String _wsUrl = 'ws://127.0.0.1:7545';

  final String _privateKey =
      "24108abad855efb054f3e00b453191f6ba81705007a5599ead609db75c0a83ad";

  late Web3Client _web3client;
  late String _abiCode;
  int totalMedicines = 0;

  late EthereumAddress _contractAddress;
  late Credentials _credentials;
  late EthereumAddress _ownAddress;
  late DeployedContract _contract;
  late ContractFunction _createMedicine;
  late ContractFunction _getTotalMedicines;

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
    _credentials = EthPrivateKey.fromHex(_privateKey);
    _ownAddress = await _credentials.extractAddress();
  }

  Future<void> getDeployedContracts() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "SupplyChain"), _contractAddress);
    _createMedicine = _contract.function("createMedicine");
    _getTotalMedicines = _contract.function("count");

    await getTotalMedicines();
  }

  getTotalMedicines() async {
    List totalMedList = await _web3client
        .call(contract: _contract, function: _getTotalMedicines, params: []);

    BigInt totalMed = totalMedList[0];
    totalMedicines = totalMed.toInt();

    notifyListeners();
  }

  addMedicine(int id, String name) async {
    await _web3client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _createMedicine,
            parameters: [BigInt.from(id), name]));
    await getTotalMedicines();
  }
}
