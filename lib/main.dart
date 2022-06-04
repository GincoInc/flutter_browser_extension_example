// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:dart_bip32_bip44/dart_bip32_bip44.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:http/http.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double? balance;
  EthPrivateKey? privateKey;
  EthPrivateKey? credentials;
  // final apiUrl =
  //     "https://rinkeby.infura.io/v3/b8afb8ea41da4395a9374aa0641e2165";
  final apiUrl =
      'https://ropsten.infura.io/v3/afb1ae020fa14826bbb53cde949f70ec';

  @override
  void initState() {
    super.initState();
    web3dartExample();
    getBalnce();
  }

  void web3dartExample() async {
    // generate a new key randomly
    var rng = Random.secure();

    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    // String randomMnemonic = bip39.generateMnemonic();
    // print('randomMnemonic:' + randomMnemonic);
    // final seed = bip39.mnemonicToSeedHex(randomMnemonic);
    // print('seed: ' + seed);
    // String entropy = bip39.mnemonicToEntropy(randomMnemonic);
    // print('entropy: ' + entropy);
    // String prvKeyHex =
    //     Chain.seed(seed).forPath("m/44'/60'/0'/0/0").privateKeyHex();

    // print("privateKeyHex: " + prvKeyHex);

    // print("----------------------------------");

    // seed =
    //     '4d294ec54422ab8400ae0acb77a185dc501116bf9feb2453cc06e2cc60344c75188f2c8c690089333b1a7134ef8a53fac75156b00641e234a780131f1c69fe99';
    String prvKeyHex =
        '00e392e9b97366249da3fc0ecbfba2f2efc36fef2993938f8960b956789af49b5a';
    final credentials = EthPrivateKey.fromHex(prvKeyHex);
    Wallet wallet = Wallet.createNew(credentials, "password", rng);
    print(wallet.toJson());
    print('address: ' + wallet.privateKey.address.hex);
    setState(() {
      privateKey = wallet.privateKey;
      this.credentials = credentials;
    });
  }

  Future<void> getBalnce() async {
    if (privateKey == null) return;
    final httpClient = Client();
    final ethClient = Web3Client(apiUrl, httpClient);
    final address = EthereumAddress.fromHex(privateKey!.address.hex);

    EtherAmount balance = await ethClient.getBalance(address);
    setState(() {
      this.balance = balance.getValueInUnit(EtherUnit.ether);
    });
  }

  Future<void> sendTransaction() async {
    if (privateKey == null) return;
    final httpClient = Client();
    final ethClient = Web3Client(apiUrl, httpClient);
    // ethClient.
    final hash = await ethClient.sendTransaction(
      privateKey!,
      Transaction(
        to: EthereumAddress.fromHex(
          '0xd3e8763675e4c425df46cc3b5c0f6cbdac396046',
        ),
        gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 10),
        maxGas: 600000,
        // 1000000gwei == 0.001eth
        value: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 1000000),
      ),
      chainId: 3,
    );
    print("transaction hash: " + hash);
  }

  void subscribe() {
    final coinPriceStream = FirebaseFirestore.instance
        .collection('coinPrices')
        .doc("latest")
        .collection("coins")
        .snapshots();

    coinPriceStream.listen((querySnapshot) {
      querySnapshot.docs.map((document) {
        final data = document.data();
        print(data);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: subscribe,
              child: Text("subscribe"),
            ),
            const SizedBox(height: 16),
            Text("${balance ?? 0} eth"),
            const SizedBox(height: 16),
            TextButton(
              onPressed: sendTransaction,
              child: Text("SendTransaction"),
            ),
          ],
        ),
      ),
    );
  }
}
