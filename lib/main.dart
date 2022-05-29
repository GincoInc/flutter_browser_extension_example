// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:bip39/bip39.dart' as bip39;

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
  @override
  void initState() {
    super.initState();
    web3dartExample();
  }

  void web3dartExample() async {
    // generate a new key randomly
    var rng = Random.secure();

    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    String randomMnemonic = bip39.generateMnemonic();
    print('randomMnemonic:' + randomMnemonic);
    String seed = bip39.mnemonicToSeedHex(randomMnemonic);
    print('seed: ' + seed);
    String entropy = bip39.mnemonicToEntropy(randomMnemonic);
    print('entropy: ' + entropy);
    print("----------------------------------");

    seed =
        '4d294ec54422ab8400ae0acb77a185dc501116bf9feb2453cc06e2cc60344c75188f2c8c690089333b1a7134ef8a53fac75156b00641e234a780131f1c69fe99';
    final credentials = EthPrivateKey.fromHex(seed);
    Wallet wallet = Wallet.createNew(credentials, "password", rng);
    print(wallet.toJson());
    print('address: ' + wallet.privateKey.address.hex);
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
            )
          ],
        ),
      ),
    );
  }
}
