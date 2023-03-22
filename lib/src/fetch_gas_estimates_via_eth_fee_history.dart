import 'package:dart_web3gas/web3dart/src/core/fee_history.dart';

import '../web3dart/web3dart.dart';
import 'fetch_gas_estimates_via_eth_fee_history/calculate_gas_fee_estimates_for_priority_levels.dart';
import 'fetch_gas_estimates_via_eth_fee_history/fetch_latest_block.dart';
import 'gas_util.dart';
import 'types.dart';

Future<GasFeeEstimates> fetchGasEstimatesViaEthFeeHistory(
    Web3Client web3) async {
  final latestBlock = await fetchLatestBlock(web3);
  final blocks = await fetchBlockFeeHistory(
      web3, 5, '0x${latestBlock.number.toRadixString(16)}',
      rewardPercentiles: [10, 20, 30]);
  final estimatedBaseFee = latestBlock.baseFeePerGas;
  if (estimatedBaseFee == null) {
    throw 'estimatedBaseFee is null';
  }
  final levelSpecificEstimates =
      calculateGasFeeEstimatesForPriorityLevels(blocks);

  return GasFeeEstimates(
    low: levelSpecificEstimates[0],
    medium: levelSpecificEstimates[1],
    high: levelSpecificEstimates[2],
    estimatedBaseFee: fromWei(estimatedBaseFee.getInWei),
  );
}

Future<FeeHistory> fetchBlockFeeHistory(
  Web3Client web3,
  int blockCount,
  String block, {
  List<double>? rewardPercentiles,
}) async {
  rewardPercentiles?.sort();
  final endblockNumber = await web3.getBlockNumber();
  final blockChunks = await web3.getFeeHistory(
    blockCount,
    atBlock: BlockNum.exact(endblockNumber),
    rewardPercentiles: [10, 20, 30],
  );
  return blockChunks;
}
