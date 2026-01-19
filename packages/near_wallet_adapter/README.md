# near_wallet_adapter

Wallet adapter for NEAR Protocol - connect, sign, and send transactions.

This package provides a platform-agnostic interface for integrating NEAR wallets into your Flutter application. It supports multiple wallet types including WalletConnect, browser wallets, and mobile deep links.

## Features

- **Transaction Building**: Type-safe action builders (Transfer, FunctionCall, etc.)
- **Wallet Abstraction**: Unified interface for multiple wallet types
- **NEP-413 Support**: Message signing for authentication
- **Execution Results**: Typed transaction outcomes and error handling
- **Platform Agnostic**: Works on iOS, Android, Web, and Desktop

## Installation

```yaml
dependencies:
  near_wallet_adapter: ^0.1.0
```

## Quick Start

### Building Transactions

```dart
import 'package:near_wallet_adapter/near_wallet_adapter.dart';
import 'package:near_jsonrpc_types/near_jsonrpc_types.dart';

// Simple transfer
final transferTx = Transaction(
  signerId: AccountId('alice.near'),
  receiverId: AccountId('bob.near'),
  actions: [
    TransferAction(deposit: NearToken.fromNear(1)),
  ],
);

// Contract function call
final contractTx = Transaction(
  signerId: AccountId('alice.near'),
  receiverId: AccountId('token.near'),
  actions: [
    FunctionCallAction(
      methodName: 'ft_transfer',
      args: {
        'receiver_id': 'bob.near',
        'amount': '1000000000000000000',
      },
      deposit: NearToken.oneYocto(), // 1 yoctoNEAR for storage
    ),
  ],
);
```

### Action Types

```dart
// Create account
CreateAccountAction()

// Deploy contract
DeployContractAction(code: wasmBytes)

// Function call
FunctionCallAction(
  methodName: 'method_name',
  args: {'key': 'value'},       // Optional JSON args
  gas: BigInt.from(30000000000000), // Optional, defaults to 30 TGas
  deposit: NearToken.zero(),
)

// Transfer NEAR
TransferAction(deposit: NearToken.fromNear(10))

// Stake
StakeAction(
  stake: NearToken.fromNear(100),
  publicKey: PublicKey('ed25519:...'),
)

// Add access key
AddKeyAction(
  publicKey: PublicKey('ed25519:...'),
  accessKey: FullAccessKey(),
  // Or: FunctionCallAccessKey(receiverId: ..., methodNames: [...])
)

// Delete key
DeleteKeyAction(publicKey: PublicKey('ed25519:...'))

// Delete account
DeleteAccountAction(beneficiaryId: AccountId('beneficiary.near'))
```

### Using a Wallet Adapter

```dart
// Sign and send transaction
final result = await adapter.signAndSendTransaction(
  transaction: transferTx,
);

// Handle result
switch (result.outcome.status) {
  case ExecutionStatusSuccessValue(:final value):
    print('Success! Return value: $value');
  case ExecutionStatusSuccessReceiptIds(:final receiptIds):
    print('Success! Receipt IDs: $receiptIds');
  case ExecutionStatusFailure(:final error):
    print('Failed: ${error.errorMessage}');
}

// Batch multiple transactions
final results = await adapter.signAndSendTransactions(
  transactions: [tx1, tx2, tx3],
);
```

### NEP-413 Message Signing

```dart
// Sign a message for authentication (no gas fees)
final nonce = List<int>.generate(32, (i) => Random().nextInt(256));

final signedMessage = await adapter.signMessage(
  SignMessageParams(
    message: 'Login to MyApp',
    recipient: 'myapp.com',
    nonce: nonce,
  ),
);

// Verify on your backend
print('Account: ${signedMessage.accountId}');
print('Signature: ${signedMessage.signature}');
```

### Wallet Session Management

```dart
// Sign in to contract
final accounts = await adapter.signIn(
  contractId: AccountId('app.near'),
  methodNames: ['get_data', 'set_data'], // Optional: restrict methods
);

// Check if signed in
if (await adapter.isSignedIn()) {
  final accounts = await adapter.getAccounts();
  print('Connected accounts: ${accounts.map((a) => a.accountId)}');
}

// Sign out
await adapter.signOut();
```

## Access Key Types

```dart
// Full access - can perform any action
final fullAccess = FullAccessKey();

// Function call access - restricted to specific contract/methods
final functionCallAccess = FunctionCallAccessKey(
  receiverId: AccountId('contract.near'),
  methodNames: ['view_data', 'update_data'], // Empty = all methods
  allowance: NearToken.fromNear(1), // Max gas allowance
);
```

## Error Handling

```dart
final result = await adapter.signAndSendTransaction(transaction: tx);

if (result.outcome.status is ExecutionStatusFailure) {
  final failure = result.outcome.status as ExecutionStatusFailure;

  switch (failure.error.errorType) {
    case 'NotEnoughBalance':
      print('Insufficient funds');
    case 'InvalidNonce':
      print('Invalid transaction nonce');
    case 'ActionError':
      print('Action failed: ${failure.error.errorMessage}');
    default:
      print('Error: ${failure.error.errorMessage}');
  }
}
```

## Wallet Implementations

Planned wallet adapter implementations:

- `WalletConnectAdapter` - WalletConnect 2.0 protocol
- `MyNearWalletAdapter` - MyNearWallet deep links
- `MeteorWalletAdapter` - Meteor Wallet integration
- `HereWalletAdapter` - HERE Wallet integration

## License

MIT License - see [LICENSE](../../LICENSE) for details.
