import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:nsetoken/slider_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/web3dart.dart';

void main() {
  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'NSE Token'),
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

late Client httpClient;
late Web3Client ethClient;
bool data = false;
int myAmount = 0;
final myAddress = "0x341BE0ADa94CEa1Fb79a5d17a1851f3B923Fe216";

var myData;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(
      "https://rinkeby.infura.io/v3/a83b1f51ead143b2b0da26305a756f87", 
      httpClient);
    getBalance(myAddress);

  }

  Future<DeployedContract> loadContract()async{
    String abi = await rootBundle.loadString("assets/abi.json");
    String contractAddress = "0x7338F36d40C1d4638df2eB9C7187D3448c0BAFc8";

    final contract = DeployedContract(ContractAbi.fromJson(abi, "NSEToken"),EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async{
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(contract: contract, function: ethFunction, params: args);

    return result;
  }

  Future<void> getBalance(String targetAddress) async{
    // EthereumAddress address = EthereumAddress.fromHex(targetAddress);
    List<dynamic> result = await query("getBalance", []);

    myData = result[0];
    data = true;
    setState(() {});
  }

  Future<String> submit(String functionName, List<dynamic> args)async{
    EthPrivateKey credentials = EthPrivateKey.fromHex("fb5dc4a16023a1e0df08b4f1e2ffe8a2f6567c929b69627eee5bf43b8243cda4");

    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.sendTransaction(
      credentials, 
      Transaction.callContract(
        contract: contract, function: ethFunction, parameters: args),
         fetchChainIdFromNetworkId: true);
    return result;
  }

  Future<String> sendCoin() async {
    var bigAmount = BigInt.from(myAmount);

    var response = await submit("depositBalance", [bigAmount]);

    print("Deposited.");
    return response;
  }

  Future<String> withdrawCoin() async {
    var bigAmount = BigInt.from(myAmount);

    var response = await submit("withdrawBalance", [bigAmount]);

    print("Withdrawn.");
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Vx.gray300,
      body: ZStack([
        VxBox()
          .blue600
          .size(context.screenWidth, context.percentHeight * 30)
          .make(),

        VStack([
          (context.percentHeight * 10).heightBox,
          "\$NSETOKEN".text.xl4.white.bold.center.makeCentered().py16(),
          (context.percentHeight * 5).heightBox,
          VxBox(child: VStack([
            "Balance".text.gray700.xl2.semiBold.makeCentered(),
            10.heightBox,
            data?"\$$myData".text.bold.xl6.makeCentered()
            : CircularProgressIndicator().centered()
          ]))
            .p16
            .white
            .size(context.screenWidth, context.percentHeight * 18)
            .rounded
            .shadowXl
            .make()
            .p16(),
          30.heightBox,

          SliderWidget(
            min: 0,
            max: 100,
            finalVal: (value) {
              myAmount = (value*100).round();
              print(myAmount);
            },
          ).centered().p(15),


          HStack([
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // background
                onPrimary: Colors.white, // foreground
              ),
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () => {getBalance(myAddress)},
              label: "Refresh".text.white.make(),
            ).h(50),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // background
                onPrimary: Colors.white, // foreground
              ),
              icon: const Icon(
                Icons.call_made_outlined,
                color: Colors.white,
              ),
              onPressed: () => {sendCoin()},
              label: "Deposit".text.white.make(),
            ).h(50),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // background
                onPrimary: Colors.white, // foreground
              ),
              icon: const Icon(
                Icons.call_received_outlined,
                color: Colors.white,
              ),
              onPressed: () => {withdrawCoin()},
              label: "Withdraw".text.white.make(),
            ).h(50),
          ], 
          alignment: MainAxisAlignment.spaceAround,
          axisSize: MainAxisSize.max,
          ).p8()
        ])
      ]),


    );
  }
}
