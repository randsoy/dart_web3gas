import 'dart:io';

import 'package:dart_web3gas/web3dart/web3dart.dart';

import 'package:dart_web3gas/dart_web3gas.dart';

Future<void> main() async {
  var http = HttpClient();
  http.connectionTimeout = const Duration(seconds: 2);
  {
    var web3 =
        Web3Client.custom(JsonRPCHttp('https://polygon.llamarpc.com', http));
    var gas = await GasFeeController.fetchGasFeeEstimateData(web3);
    var max = gas?.gasFeeEstimates?.medium.suggestedMaxFeePerGas;
    var priority = gas?.gasFeeEstimates?.medium.suggestedMaxPriorityFeePerGas;

    var basefee = await web3.estimateGas(
        sender: EthereumAddress.fromHex(
            '0xf17C8F3ADb9DEB7E3D4a23E66Fd2f4838349739b'),
        to: EthereumAddress.fromHex(
            '0xf17C8F3ADb9DEB7E3D4a23E66Fd2f4838349739b'));
    if (max != null && priority != null) {
      print('basefee: $basefee');
      print(
          'max:${double.parse(max) * basefee.toDouble()} pri:${double.parse(priority) * basefee.toDouble()}');
    }
  }
}
