// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Eip1559GasFee _$Eip1559GasFeeFromJson(Map<String, dynamic> json) =>
    Eip1559GasFee(
      maxWaitTimeEstimate: json['maxWaitTimeEstimate'] as int,
      minWaitTimeEstimate: json['minWaitTimeEstimate'] as int,
      suggestedMaxFeePerGas: json['suggestedMaxFeePerGas'] as String,
      suggestedMaxPriorityFeePerGas:
          json['suggestedMaxPriorityFeePerGas'] as String,
    );

Map<String, dynamic> _$Eip1559GasFeeToJson(Eip1559GasFee instance) =>
    <String, dynamic>{
      'minWaitTimeEstimate': instance.minWaitTimeEstimate,
      'maxWaitTimeEstimate': instance.maxWaitTimeEstimate,
      'suggestedMaxPriorityFeePerGas': instance.suggestedMaxPriorityFeePerGas,
      'suggestedMaxFeePerGas': instance.suggestedMaxFeePerGas,
    };

GasFeeEstimates _$GasFeeEstimatesFromJson(Map<String, dynamic> json) =>
    GasFeeEstimates(
      low: Eip1559GasFee.fromJson(json['low'] as Map<String, dynamic>),
      medium: Eip1559GasFee.fromJson(json['medium'] as Map<String, dynamic>),
      high: Eip1559GasFee.fromJson(json['high'] as Map<String, dynamic>),
      estimatedBaseFee: json['estimatedBaseFee'] as String,
      historicalBaseFeeRange: (json['historicalBaseFeeRange'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      baseFeeTrend: json['baseFeeTrend'] as String,
      latestPriorityFeeRange: (json['latestPriorityFeeRange'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      historicalPriorityFeeRange:
          (json['historicalPriorityFeeRange'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      priorityFeeTrend: json['priorityFeeTrend'] as String,
      networkCongestion: (json['networkCongestion'] as num).toDouble(),
    );

Map<String, dynamic> _$GasFeeEstimatesToJson(GasFeeEstimates instance) =>
    <String, dynamic>{
      'low': instance.low,
      'medium': instance.medium,
      'high': instance.high,
      'estimatedBaseFee': instance.estimatedBaseFee,
      'historicalBaseFeeRange': instance.historicalBaseFeeRange,
      'baseFeeTrend': instance.baseFeeTrend,
      'latestPriorityFeeRange': instance.latestPriorityFeeRange,
      'historicalPriorityFeeRange': instance.historicalPriorityFeeRange,
      'priorityFeeTrend': instance.priorityFeeTrend,
      'networkCongestion': instance.networkCongestion,
    };
