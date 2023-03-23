// ignore_for_file: constant_identifier_names

import 'package:dart_web3gas/src/gas_util.dart';
import 'package:dart_web3gas/web3dart/src/core/fee_history.dart';

import '../types.dart';

const PRIORITY_LEVELS = ['low', 'medium', 'high'];

class PriorityLevel {
  PriorityLevel({
    required this.baseFeePercentageMultiplier,
    required this.priorityFeePercentageMultiplier,
    required this.minSuggestedMaxPriorityFeePerGas,
    required this.minWaitTimeEstimate,
    required this.maxWaitTimeEstimate,
  });
  final double baseFeePercentageMultiplier;
  final double priorityFeePercentageMultiplier;
  final BigInt minSuggestedMaxPriorityFeePerGas;
  final int minWaitTimeEstimate;
  final int maxWaitTimeEstimate;

  static List<PriorityLevel> priorityLevelList() {
    return [
      PriorityLevel(
        baseFeePercentageMultiplier: 1.1,
        priorityFeePercentageMultiplier: 0.94,
        minSuggestedMaxPriorityFeePerGas: BigInt.from(10).pow(9),
        minWaitTimeEstimate: 15000,
        maxWaitTimeEstimate: 30000,
      ),
      PriorityLevel(
        baseFeePercentageMultiplier: 1.2,
        priorityFeePercentageMultiplier: 0.97,
        minSuggestedMaxPriorityFeePerGas:
            BigInt.from(10).pow(8) * BigInt.from(15),
        minWaitTimeEstimate: 15000,
        maxWaitTimeEstimate: 45000,
      ),
      PriorityLevel(
        baseFeePercentageMultiplier: 1.25,
        priorityFeePercentageMultiplier: 0.98,
        minSuggestedMaxPriorityFeePerGas:
            BigInt.from(10).pow(9) * BigInt.from(2),
        minWaitTimeEstimate: 15000,
        maxWaitTimeEstimate: 60000,
      ),
    ];
  }
}

List<Eip1559GasFee> calculateGasFeeEstimatesForPriorityLevels(
    FeeHistory feeHistory) {
  List<Eip1559GasFee> mm = [];
  for (var i = 0; i < PriorityLevel.priorityLevelList().length; i++) {
    var priorityLevel = PriorityLevel.priorityLevelList()[i];
    var gasEstimatesForPriorityLevel = calculateEstimatesForPriorityLevel(
      priorityLevel,
      feeHistory.reward!.map<BigInt>((e) => e[i]).toList(),
      feeHistory,
    );
    if (gasEstimatesForPriorityLevel != null) {
      mm.add(gasEstimatesForPriorityLevel);
    }
  }
  return mm;
}

Eip1559GasFee? calculateEstimatesForPriorityLevel(
  PriorityLevel priorityLevel,
  List<BigInt> priorityFees,
  FeeHistory blocks,
) {
  final latestBaseFeePerGas = blocks.baseFeePerGas.last;
  final adjustedBaseFee = BigInt.from(latestBaseFeePerGas.toDouble() *
      priorityLevel.baseFeePercentageMultiplier);
  final medianPriorityFee = priorityFees
      .reduce((value, element) => value > element ? value : element);
  final adjustedPriorityFee = BigInt.from(medianPriorityFee.toDouble() *
      priorityLevel.priorityFeePercentageMultiplier);

  final suggestedMaxPriorityFeePerGas = bigIntMax(
      adjustedPriorityFee, priorityLevel.minSuggestedMaxPriorityFeePerGas);
  final suggestedMaxFeePerGas = adjustedBaseFee + suggestedMaxPriorityFeePerGas;
  return Eip1559GasFee(
    maxWaitTimeEstimate: priorityLevel.maxWaitTimeEstimate,
    minWaitTimeEstimate: priorityLevel.minWaitTimeEstimate,
    suggestedMaxFeePerGas: fromWei(suggestedMaxFeePerGas),
    suggestedMaxPriorityFeePerGas: fromWei(suggestedMaxPriorityFeePerGas),
  );
}
