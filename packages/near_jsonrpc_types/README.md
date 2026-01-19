# near_jsonrpc_types

Type-safe models for NEAR Protocol JSON-RPC API.

This package provides Dart types for interacting with NEAR Protocol's JSON-RPC API. All types are designed to be serialization-safe and follow NEAR Protocol naming conventions.

## Features

- **Type-Safe Primitives**: `AccountId`, `CryptoHash`, `PublicKey`, `NearToken`
- **Block References**: Query by finality, height, or hash
- **JSON-RPC Types**: Request/Response handling with error types
- **Result Type**: Sealed class for exhaustive pattern matching

## Installation

```yaml
dependencies:
  near_jsonrpc_types: ^0.1.0
```

## Usage

### Primitives

```dart
import 'package:near_jsonrpc_types/near_jsonrpc_types.dart';

// Account IDs with validation
final account = AccountId('alice.near');

// NEAR tokens (handles 24 decimal places)
final amount = NearToken.fromNear(10);
print(amount.toNear()); // 10.0

// Public keys
final key = PublicKey('ed25519:6E8sCci9badyRkXb3JoRpBj5p8C6Tw41ELDZoiihKEtp');
print(key.keyType); // KeyType.ed25519

// Cryptographic hashes
final hash = CryptoHash('9FsxVXBh5p1J7EBP2LXB7j2Z3nVqgDctPCbKxVJkNs7f');
```

### Block References

```dart
// Latest finalized block (recommended for most queries)
final finalRef = BlockReference.finality(Finality.final_);

// Latest block (may be reorganized)
final optimisticRef = BlockReference.finality(Finality.optimistic);

// Specific block height
final heightRef = BlockReference.blockId(123456789);

// Specific block hash
final hashRef = BlockReference.blockHash(CryptoHash('abc...'));
```

### Result Type

```dart
RpcResult<StatusResponse> result = await client.status();

// Pattern matching (recommended)
switch (result) {
  case RpcSuccess(:final value):
    print('Success: ${value.chainId}');
  case RpcFailure(:final error):
    print('Error: ${error.message}');
}

// Or use convenience methods
final value = result.getOrNull();
final valueOrThrow = result.getOrThrow();
```

## API Reference

See the [API documentation](https://pub.dev/documentation/near_jsonrpc_types/latest/) for detailed information.

## License

MIT License - see [LICENSE](../../LICENSE) for details.
