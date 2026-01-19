# NEAR Flutter SDK

Type-safe Dart/Flutter client for NEAR Protocol JSON-RPC API. Platform agnostic - works on Mobile, Desktop, and Web.

[![CI](https://github.com/0xJesus/NearFlutter/actions/workflows/ci.yml/badge.svg)](https://github.com/0xJesus/NearFlutter/actions/workflows/ci.yml)
[![pub package](https://img.shields.io/pub/v/near_jsonrpc_client.svg)](https://pub.dev/packages/near_jsonrpc_client)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Packages

| Package | Description |
|---------|-------------|
| [near_jsonrpc_types](packages/near_jsonrpc_types) | Type definitions and serialization for NEAR RPC |
| [near_jsonrpc_client](packages/near_jsonrpc_client) | HTTP client with typed methods for NEAR RPC |

## Quick Start

### Installation

```yaml
dependencies:
  near_jsonrpc_client: ^0.1.0
```

### Basic Usage

```dart
import 'package:near_jsonrpc_client/near_jsonrpc_client.dart';

void main() async {
  // Create a client for testnet
  final client = NearRpcClient.testnet();

  // Get node status
  final statusResult = await client.status();
  switch (statusResult) {
    case RpcSuccess(:final value):
      print('Chain ID: ${value.chainId}');
      print('Latest block: ${value.syncInfo.latestBlockHeight}');
    case RpcFailure(:final error):
      print('Error: ${error.message}');
  }

  // Get account information
  final accountResult = await client.viewAccount(
    accountId: AccountId('alice.testnet'),
    blockReference: BlockReference.finality(Finality.final_),
  );

  if (accountResult.isSuccess) {
    final account = accountResult.getOrNull()!;
    print('Balance: ${account.amount.toNear()} NEAR');
  }

  // Get block information
  final blockResult = await client.block(
    BlockReference.finality(Finality.final_),
  );

  // Get gas price
  final gasPriceResult = await client.gasPrice();

  // Clean up
  client.close();
}
```

## Features

### Type Safety

All responses are strongly typed using Dart's sealed classes for exhaustive pattern matching:

```dart
final result = await client.status();

// Exhaustive pattern matching
switch (result) {
  case RpcSuccess(:final value):
    // Access typed response
    print(value.chainId);
  case RpcFailure(:final error):
    // Handle typed error
    print(error.message);
}

// Or use convenience methods
final status = result.getOrNull();
final statusOrThrow = result.getOrThrow();
```

### Block References

Query data at different points in the blockchain:

```dart
// Latest finalized block (recommended)
BlockReference.finality(Finality.final_)

// Latest block (may be reorganized)
BlockReference.finality(Finality.optimistic)

// Specific block height
BlockReference.blockId(123456789)

// Specific block hash
BlockReference.blockHash(CryptoHash('abc...'))
```

### Network Configuration

```dart
// Testnet (for development)
final client = NearRpcClient.testnet();

// Mainnet (for production)
final client = NearRpcClient.mainnet();

// Custom RPC endpoint
final client = NearRpcClient(rpcUrl: 'https://your-rpc-node.com');
```

## API Reference

### Node Status

```dart
final result = await client.status();
```

Returns node version, chain ID, protocol version, and sync status.

### Block Information

```dart
final result = await client.block(blockReference);
```

Returns block header, author, and chunk information.

### Account Information

```dart
final result = await client.viewAccount(
  accountId: AccountId('alice.testnet'),
  blockReference: BlockReference.finality(Finality.final_),
);
```

Returns account balance, storage usage, and code hash.

### Access Key Information

```dart
final result = await client.viewAccessKey(
  accountId: AccountId('alice.testnet'),
  publicKey: PublicKey('ed25519:...'),
  blockReference: BlockReference.finality(Finality.final_),
);
```

Returns access key nonce and permission scope.

### Gas Price

```dart
final result = await client.gasPrice();
```

Returns current gas price in yoctoNEAR per gas unit.

## Error Handling

Errors are categorized for easy handling:

```dart
switch (error.kind) {
  case RpcErrorKind.rpcError:
    // JSON-RPC protocol error
  case RpcErrorKind.httpError:
    // HTTP transport error
  case RpcErrorKind.networkError:
    // Network connectivity error
  case RpcErrorKind.timeout:
    // Request timeout
  case RpcErrorKind.parseError:
    // Response parsing error
  case RpcErrorKind.cancelled:
    // Request was cancelled
  case RpcErrorKind.runtimeError:
    // NEAR runtime error
  case RpcErrorKind.unknown:
    // Unknown error
}
```

## Development

### Running Tests

```bash
# Unit tests
dart test

# Integration tests (requires network)
dart test --tags integration
```

### Code Generation

The types are designed to be extended with code generation:

```bash
dart run build_runner build
```

## License

MIT License - see [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details.
