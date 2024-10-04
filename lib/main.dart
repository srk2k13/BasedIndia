import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onchain App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _privateKeyController = TextEditingController();
  String _balance = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Onchain App'),centerTitle:true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _accountController,
                decoration: InputDecoration(
                  labelText: 'Mainnet Account Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your account address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _privateKeyController,
                decoration: InputDecoration(
                  labelText: 'Private Key',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your private key';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final client = Web3Client('https://mainnet.infura.io/v3/ff8431a4378d4a09b817caf914ba3b60', Client());
                    final credentials = EthPrivateKey.fromHex(_privateKeyController.text);
                    final address = await credentials.extractAddress();
                    final balance = await client.getBalance(address);
                    setState(() {
                      _balance = 'Account balance: ${balance.getInWei} wei';
                    });
                  }
                },
                child: Text('Get Account Balance'),
              ),
              SizedBox(height: 20),
              Text(_balance),
            ],
          ),
        ),
      ),
    );
  }
}


