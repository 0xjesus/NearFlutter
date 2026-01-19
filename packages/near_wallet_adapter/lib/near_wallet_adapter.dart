/// Wallet adapter for NEAR Protocol.
///
/// This package provides:
/// - [WalletAdapter] - Abstract interface for wallet integrations
/// - [Action] types - CreateAccount, FunctionCall, Transfer, etc.
/// - [Transaction] - Transaction model with actions
/// - [ExecutionOutcome] - Transaction execution results
///
/// Example:
/// ```dart
/// import 'package:near_wallet_adapter/near_wallet_adapter.dart';
///
/// // Create a transaction
/// final tx = Transaction(
///   signerId: AccountId('alice.near'),
///   receiverId: AccountId('bob.near'),
///   actions: [
///     TransferAction(deposit: NearToken.fromNear(1)),
///   ],
/// );
///
/// // Sign and send with a wallet adapter
/// final result = await adapter.signAndSendTransaction(transaction: tx);
/// ```
library near_wallet_adapter;

export 'src/actions.dart';
export 'src/execution_outcome.dart';
export 'src/transaction.dart';
export 'src/wallet_adapter.dart';

// Wallet implementations
export 'src/adapters/wallet_connect_adapter.dart';
export 'src/adapters/my_near_wallet_adapter.dart';
