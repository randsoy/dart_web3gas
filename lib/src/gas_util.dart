import 'dart:convert';

import 'package:dart_web3gas/src/types.dart';
import 'package:http/http.dart';

import '../web3dart/web3dart.dart';

BigInt gweiDecToWEI(String value) {
  return BigInt.from(double.parse(value) * BigInt.one.pow(9).toInt());
}

BigInt bigIntMin(BigInt v1, BigInt v2) {
  if (v1 < v2) return v1;
  return v2;
}

BigInt bigIntMax(BigInt v1, BigInt v2) {
  if (v1 > v2) return v1;
  return v2;
}

String fromWei(BigInt wei, {EtherUnit unit = EtherUnit.gwei}) {
  return EtherAmount.inWei(wei).getValueInUnit(unit).toString();
}

EstimatedGasFeeTimeBounds calculateTimeEstimate(
    String suggestedMaxPriorityFeePerGas,
    String suggestedMaxFeePerGas,
    GasFeeEstimates estimates) {
  final low = estimates.low;
  final high = estimates.high;
  final medium = estimates.medium;

  final maxPriorityFeePerGasInWEI = gweiDecToWEI(suggestedMaxPriorityFeePerGas);
  final maxFeePerGasInWEI = gweiDecToWEI(suggestedMaxFeePerGas);
  final estimatedBaseFeeInWEI = gweiDecToWEI(estimates.estimatedBaseFee);

  final effectiveMaxPriorityFee = bigIntMin(
      maxPriorityFeePerGasInWEI, maxFeePerGasInWEI - estimatedBaseFeeInWEI);

  final lowMaxPriorityFeeInWEI =
      gweiDecToWEI(low.suggestedMaxPriorityFeePerGas);
  final mediumMaxPriorityFeeInWEI =
      gweiDecToWEI(medium.suggestedMaxPriorityFeePerGas);
  final highMaxPriorityFeeInWEI =
      gweiDecToWEI(high.suggestedMaxPriorityFeePerGas);

  int? lowerTimeBound;
  int? upperTimeBound;

  if (effectiveMaxPriorityFee < lowMaxPriorityFeeInWEI) {
    lowerTimeBound = null;
    upperTimeBound = null;
  } else if (effectiveMaxPriorityFee >= (lowMaxPriorityFeeInWEI) &&
      effectiveMaxPriorityFee < (mediumMaxPriorityFeeInWEI)) {
    lowerTimeBound = low.minWaitTimeEstimate;
    upperTimeBound = low.maxWaitTimeEstimate;
  } else if (effectiveMaxPriorityFee >= (mediumMaxPriorityFeeInWEI) &&
      effectiveMaxPriorityFee < (highMaxPriorityFeeInWEI)) {
    lowerTimeBound = medium.minWaitTimeEstimate;
    upperTimeBound = medium.maxWaitTimeEstimate;
  } else if (effectiveMaxPriorityFee == (highMaxPriorityFeeInWEI)) {
    lowerTimeBound = high.minWaitTimeEstimate;
    upperTimeBound = high.maxWaitTimeEstimate;
  } else {
    lowerTimeBound = 0;
    upperTimeBound = high.maxWaitTimeEstimate;
  }

  return EstimatedGasFeeTimeBounds(
    lowerTimeBound: lowerTimeBound,
    upperTimeBound: upperTimeBound,
  );
}

Future<GasFeeEstimates> fetchGasEstimates(String url) async {
  final c = Client();
  final response = await c.get(Uri.parse(url));
  final data = jsonDecode(response.body) as Map<String, dynamic>;

  return GasFeeEstimates.fromJson(data);
}

Future<BigInt> fetchEthGasPriceEstimate(Web3Client web3) async {
  final gasPrice = await web3.getGasPrice();
  return gasPrice;
}


// int fetchLegacyGasPriceEstimates(){

// }