library dart_web3gas;

import 'package:dart_web3gas/src/pri.dart';

import 'src/determine_gas_fee_calculations.dart';
import 'src/fetch_gas_estimates_via_eth_fee_history.dart';
import 'src/gas_util.dart';
import 'src/types.dart';
import 'web3dart/web3dart.dart';

class GasFeeController {
  static Future<GasFeeCalculations?> fetchGasFeeEstimateData(
      Web3Client web3) async {
    var isEIP1559Compatible = false;
    var chainId = await web3.getChainId();

    try {
      final latesBlock = await web3.getBlockInformation();
      isEIP1559Compatible = latesBlock.isSupportEIP1559;
    } catch (e) {
      logger.e(e);
      isEIP1559Compatible = false;
    }

    final gasFeeCalculations = await determineGasFeeCalculations(
      isEIP1559Compatible: isEIP1559Compatible,
      fetchGasEstimates: fetchGasEstimates,
      fetchGasEstimatesUrl:
          'https://gas-api.metaswap.codefi.network/networks/$chainId/suggestedGasFees',
      fetchEthGasPriceEstimate: fetchEthGasPriceEstimate,
      fetchGasEstimatesViaEthFeeHistory: fetchGasEstimatesViaEthFeeHistory,
      // fetchLegacyGasPriceEstimates: fetchGasEstimates,
      calculateTimeEstimate: calculateTimeEstimate,
      web3: web3,
    );

    return gasFeeCalculations;
  }
}
