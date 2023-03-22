library json_rpc;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'json_rpc.dart';

class JsonRPCHttp extends RpcService {
  JsonRPCHttp(String url, this.client) : super(url);

  final HttpClient client;

  int _currentRequestId = 1;

  /// Performs an RPC request, asking the server to execute the function with
  /// the given name and the associated parameters, which need to be encodable
  /// with the [json] class of dart:convert.
  ///
  /// When the request is successful, an [RPCResponse] with the request id and
  /// the data from the server will be returned. If not, an RPCError will be
  /// thrown. Other errors might be thrown if an IO-Error occurs.
  @override
  Future<RPCResponse> call(String function, [List<dynamic>? params]) async {
    params ??= [];

    final requestPayload = {
      'jsonrpc': '2.0',
      'method': function,
      'params': params,
      'id': _currentRequestId++,
    };
    var request = await client.postUrl(Uri.parse(url));
    request.headers.set('Content-Type', 'application/json');
    request.add(utf8.encode(json.encode(requestPayload)));
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    // final response = await http.post(
    //   Uri.parse(url),
    //   headers: {'Content-Type': 'application/json'},
    //   body: json.encode(requestPayload),
    // );

    final data = json.decode(responseBody) as Map<String, dynamic>;

    if (data.containsKey('error')) {
      final error = data['error'];

      final code = error['code'] as int;
      final message = error['message'] as String;
      final errorData = error['data'];

      throw RPCError(code, message, errorData);
    }

    final id = data['id'] as int;
    final result = data['result'];
    return RPCResponse(id, result);
  }
}
