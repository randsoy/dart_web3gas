import 'package:dart_web3gas/src/pri.dart';
import 'package:dart_web3gas/src/types.dart';

import '../web3dart/web3dart.dart';

Future<GasFeeCalculations?> determineGasFeeCalculations({
  bool isEIP1559Compatible = false,
  required FetchGasEstimatesFun fetchGasEstimates,
  required String fetchGasEstimatesUrl,
  required FetchGasEstimatesViaEthFeeHistoryFun
      fetchGasEstimatesViaEthFeeHistory,
  required CalculateTimeEstimateFun calculateTimeEstimate,
  FetchLegacyGasPriceEstimatesFun? fetchLegacyGasPriceEstimates,
  required FetchEthGasPriceEstimateFun fetchEthGasPriceEstimate,
  required Web3Client web3,
}) async {
  GasFeeEstimates? estimates;
  try {
    if (isEIP1559Compatible) {
      try {
        estimates = await fetchGasEstimates(fetchGasEstimatesUrl);
      } catch (e) {
        logger.e(e);
        estimates = await fetchGasEstimatesViaEthFeeHistory(web3);
      }

      final estimatedGasFeeTimeBounds = calculateTimeEstimate(
          estimates.medium.suggestedMaxPriorityFeePerGas,
          estimates.medium.suggestedMaxFeePerGas,
          estimates);

      return GasFeeCalculations(
          gasEstimateType: GasEstimateType.feeMarket,
          estimatedGasFeeTimeBounds: estimatedGasFeeTimeBounds,
          gasFeeEstimates: estimates);
    } else if (fetchLegacyGasPriceEstimates != null) {
      estimates = await fetchLegacyGasPriceEstimates();
      return GasFeeCalculations(
        gasFeeEstimates: estimates,
        gasEstimateType: GasEstimateType.legacy,
      );
    }
    throw ('Main gas fee/price estimation failed. Use fallback');
  } catch (e) {
    try {
      final gasPrice = await fetchEthGasPriceEstimate(web3);
      return GasFeeCalculations(
        gasPrice: gasPrice,
        gasEstimateType: GasEstimateType.ethGasprice,
      );
    } catch (error) {
      // if (error.runtimeType == Error) {
      //   throw 'Gas fee/price estimation failed. Message: ${error.message}';
      // }
      rethrow;
    }
  }
}
