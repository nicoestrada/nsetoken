import 'package:flutter/material.dart';
import 'package:http/http.dart';
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

//Client httpClient;
//Web3Client ethClient;
bool data = false;

final myAddress = "0x341BE0ADa94CEa1Fb79a5d17a1851f3B923Fe216";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Vx.gray300,
      body: ZStack([
        VxBox()
          .blue500
          .size(context.screenWidth, context.percentHeight * 18)
          .make(),

        VStack([
          (context.percentHeight * 10).heightBox,
          "\$NSETOKEN".text.xl4.white.bold.center.makeCentered().py16(),
          (context.percentHeight * 5).heightBox,
          VxBox(child: VStack([
            "Balance".text.gray700.xl2.semiBold.makeCentered(),
            10.heightBox,
            data?"\$1".text.bold.xl6.makeCentered()
            : CircularProgressIndicator().centered()
          ]))
            .p16
            .white
            .size(context.screenWidth, context.percentHeight * 18)
            .rounded
            .make()
            .p16(),
          30.heightBox,
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
              onPressed: () { },
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
              onPressed: () { },
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
              onPressed: () { },
              label: "Withdraw".text.white.make(),
            ).h(50),
          ], 
          alignment: MainAxisAlignment.spaceAround,
          axisSize: MainAxisSize.max,
          ).p16()
        ])
      ]),


    );
  }
}
