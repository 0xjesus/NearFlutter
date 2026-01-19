# near_jsonrpc_client

Type-safe Dart client for NEAR Protocol JSON-RPC API.

This package provides a high-level, type-safe client for interacting with NEAR Protocol's JSON-RPC API. It is designed to work on all platforms supported by Dart (mobile, desktop, web).

## Features

- **Multi-Network Support**: Mainnet, Testnet, Betanet, or custom RPC
- **Type-Safe Responses**: All responses are strongly typed
- **Contract Interaction**: Call view functions on smart contracts
- **Account Management**: Query account info and access keys
- **Validator Information**: Get current and next epoch validators
- **Platform Agnostic**: Works on iOS, Android, Web, and Desktop

## Installation

```yaml
dependencies:
  near_jsonrpc_client: ^0.1.0
```

## Quick Start

```dart
import 'package:near_jsonrpc_client/near_jsonrpc_client.dart';

void main() async {
  // Create a client
  final client = NearRpcClient.mainnet();
  // Or: NearRpcClient.testnet()
  // Or: NearRpcClient(rpcUrl: 'https://custom-rpc.example.com')

  // Get network status
  final statusResult = await client.status();
  switch (statusResult) {
    case RpcSuccess(:final value):
      print('Chain: ${value.chainId}');
      print('Block: ${value.syncInfo.latestBlockHeight}');
    case RpcFailure(:final error):
      print('Error: ${error.message}');
  }

  // Query account
  final accountResult = await client.viewAccount(
    accountId: AccountId('alice.near'),
    blockReference: BlockReference.finality(Finality.final_),
  );

  if (accountResult.isSuccess) {
    final account = accountResult.getOrNull()!;
    print('Balance: ${account.amount.toNear()} NEAR');
  }

  // Call contract view function
  final ftResult = await client.callFunction(
    accountId: AccountId('wrap.near'),
    methodName: 'ft_metadata',
    blockReference: BlockReference.finality(Finality.final_),
  );

  if (ftResult.isSuccess) {
    final metadata = ftResult.getOrNull()!.resultAsJson();
    print('Token: ${metadata['symbol']}');
  }

  // Clean up
  client.close();
}
```

## API Reference

### Network Status

```dart
final result = await client.status();
// Returns: RpcResult<StatusResponse>
```

### Block Information

```dart
// By finality
final result = await client.block(
  BlockReference.finality(Finality.final_),
);

// By height
final result = await client.block(BlockReference.blockId(12345678));

// By hash
final result = await client.block(
  BlockReference.blockHash(CryptoHash('abc...')),
);
```

### Account Information

```dart
final result = await client.viewAccount(
  accountId: AccountId('alice.near'),
  blockReference: BlockReference.finality(Finality.final_),
);
```

### Access Keys

```dart
// Single key
final result = await client.viewAccessKey(
  accountId: AccountId('alice.near'),
  publicKey: PublicKey('ed25519:...'),
  blockReference: BlockReference.finality(Finality.final_),
);

// All keys
final result = await client.viewAccessKeyList(
  accountId: AccountId('alice.near'),
  blockReference: BlockReference.finality(Finality.final_),
);
```

### Contract Interaction

```dart
// Call view function
final result = await client.callFunction(
  accountId: AccountId('contract.near'),
  methodName: 'get_data',
  args: {'key': 'value'}, // Optional
  blockReference: BlockReference.finality(Finality.final_),
);

// Parse result
final data = result.getOrNull()!.resultAsJson();
```

### Validators

```dart
final result = await client.validators();
// Returns current and next epoch validators
```

### Gas Price

```dart
final result = await client.gasPrice();
// Returns gas price in yoctoNEAR per gas unit
```

## Error Handling

```dart
final result = await client.viewAccount(...);

switch (result) {
  case RpcSuccess(:final value):
    // Handle success
  case RpcFailure(:final error):
    switch (error.kind) {
      case RpcErrorKind.rpcError:
        // JSON-RPC error (e.g., account not found)
      case RpcErrorKind.httpError:
        // HTTP error (e.g., 503)
      case RpcErrorKind.networkError:
        // Network connectivity error
      case RpcErrorKind.timeout:
        // Request timeout
      case RpcErrorKind.parseError:
        // Response parsing error
      default:
        // Unknown error
    }
}
```

## License

MIT License - see [LICENSE](../../LICENSE) for details.
