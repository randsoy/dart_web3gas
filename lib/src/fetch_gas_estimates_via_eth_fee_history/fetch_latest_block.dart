import '../../web3dart/web3dart.dart';

Future<BlockInformation> fetchLatestBlock(Web3Client web3) async {
  var blockNumber = await web3.getBlockNumber();

  var block = await web3.getBlockInformation(
      blockNumber: '0x${blockNumber.toRadixString(16)}',
      isContainFullObj: false);
  return block;
}
