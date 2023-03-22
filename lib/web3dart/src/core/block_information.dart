part of web3dart;

class BlockInformation {
  BlockInformation({
    required this.baseFeePerGas,
    required this.timestamp,
    required this.number,
  });

  factory BlockInformation.fromJson(Map<String, dynamic> json) {
    return BlockInformation(
      number: BigInt.parse(json['number']),
      baseFeePerGas: json.containsKey('baseFeePerGas')
          ? EtherAmount.fromBigInt(
              EtherUnit.wei,
              hexToInt(json['baseFeePerGas'] as String),
            )
          : null,
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        hexToDartInt(json['timestamp'] as String) * 1000,
        isUtc: true,
      ),
    );
  }

  /// Block Number.
  final BigInt number;

  final EtherAmount? baseFeePerGas;
  final DateTime timestamp;
  bool get isSupportEIP1559 => baseFeePerGas != null;
}
