/// Type-safe Dart client for NEAR Protocol JSON-RPC API.
///
/// This library provides a high-level, type-safe client for interacting with
/// NEAR Protocol's JSON-RPC API. It is designed to work on all platforms
/// supported by Dart (mobile, desktop, web).
///
/// Example:
/// ```dart
/// final client = NearRpcClient.testnet();
/// final result = await client.status();
///
/// switch (result) {
///   case RpcSuccess(:final value):
///     print('Chain ID: ${value.chainId}');
///   case RpcFailure(:final error):
///     print('Error: ${error.message}');
/// }
/// ```
library near_jsonrpc_client;

export 'package:near_jsonrpc_types/near_jsonrpc_types.dart';

export 'src/near_rpc_client.dart';
export 'src/responses/status_response.dart';
export 'src/responses/block_response.dart';
export 'src/responses/account_response.dart';
export 'src/responses/gas_price_response.dart';
export 'src/responses/call_function_response.dart';
export 'src/responses/validators_response.dart';
export 'src/responses/transaction_response.dart';
export 'src/responses/chunk_response.dart';
