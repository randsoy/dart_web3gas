import 'dart:io';

import 'package:dart_web3gas/web3dart/web3dart.dart';
import 'package:test/test.dart';

import 'package:dart_web3gas/dart_web3gas.dart';

void main() {
  test('adds one to input values', () async {
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
              '0xc09f0ad5ecb2a5956e5779144a89029460cb2ecf'),
          to: EthereumAddress.fromHex(
              '0xc09f0ad5ecb2a5956e5779144a89029460cb2ecf'));
      if (max != null && priority != null) {
        print('basefee: $basefee');
        print(
            'max:${double.parse(max) * basefee.toDouble()} pri:${double.parse(priority) * basefee.toDouble()}');
      }
    }
  });
}
