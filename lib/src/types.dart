import 'package:json_annotation/json_annotation.dart';

import '../web3dart/web3dart.dart';

part 'types.g.dart';

typedef FetchGasEstimatesFun = Future<GasFeeEstimates> Function(String url);
typedef FetchGasEstimatesViaEthFeeHistoryFun = Future<GasFeeEstimates> Function(
    Web3Client web3);
typedef CalculateTimeEstimateFun = EstimatedGasFeeTimeBounds Function(
    String suggestedMaxPriorityFeePerGas,
    String suggestedMaxFeePerGas,
    GasFeeEstimates estimates);

typedef FetchLegacyGasPriceEstimatesFun = Future<GasFeeEstimates> Function();
typedef FetchEthGasPriceEstimateFun = Future<BigInt> Function(Web3Client web3);

enum GasEstimateType { none, feeMarket, legacy, ethGasprice }

@JsonSerializable()
class Eip1559GasFee {
  Eip1559GasFee({
    required this.maxWaitTimeEstimate,
    required this.minWaitTimeEstimate,
    required this.suggestedMaxFeePerGas,
    required this.suggestedMaxPriorityFeePerGas,
  });
  final int minWaitTimeEstimate;
  final int maxWaitTimeEstimate;
  final String suggestedMaxPriorityFeePerGas;
  final String suggestedMaxFeePerGas;

  factory Eip1559GasFee.fromJson(Map<String, dynamic> json) =>
      _$Eip1559GasFeeFromJson(json);
  Map<String, dynamic> toJson() => _$Eip1559GasFeeToJson(this);
}

@JsonSerializable()
class GasFeeEstimates {
  GasFeeEstimates({
    required this.low,
    required this.medium,
    required this.high,
    required this.estimatedBaseFee,
    this.historicalBaseFeeRange = const [],
    this.baseFeeTrend,
    this.latestPriorityFeeRange = const [],
    this.historicalPriorityFeeRange = const [],
    this.priorityFeeTrend,
    this.networkCongestion,
  });
  final Eip1559GasFee low;
  final Eip1559GasFee medium;
  final Eip1559GasFee high;
  final String estimatedBaseFee;
  final List<String> historicalBaseFeeRange;
  final String? baseFeeTrend; // 'up' | 'down' | 'level'
  final List<String> latestPriorityFeeRange;
  final List<String> historicalPriorityFeeRange;
  final String? priorityFeeTrend;
  final double? networkCongestion;

  factory GasFeeEstimates.fromJson(Map<String, dynamic> json) =>
      _$GasFeeEstimatesFromJson(json);
  Map<String, dynamic> toJson() => _$GasFeeEstimatesToJson(this);
}

class EstimatedGasFeeTimeBounds {
  EstimatedGasFeeTimeBounds({
    this.lowerTimeBound,
    this.upperTimeBound,
  });
  final int? lowerTimeBound;
  final int? upperTimeBound;
}

class GasFeeCalculations {
  GasFeeCalculations({
    this.gasFeeEstimates,
    this.estimatedGasFeeTimeBounds,
    required this.gasEstimateType,
    this.gasPrice,
  });

  final GasFeeEstimates? gasFeeEstimates;
  final EstimatedGasFeeTimeBounds? estimatedGasFeeTimeBounds;
  final GasEstimateType gasEstimateType;
  final BigInt? gasPrice; // ethGasprice
}
