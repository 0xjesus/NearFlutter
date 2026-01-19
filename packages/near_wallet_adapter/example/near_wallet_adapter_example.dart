import 'package:near_jsonrpc_types/near_jsonrpc_types.dart';
import 'package:near_wallet_adapter/near_wallet_adapter.dart';

void main() {
  // Build a transfer transaction
  final transferTx = Transaction(
    signerId: AccountId('alice.near'),
    receiverId: AccountId('bob.near'),
    actions: [
      TransferAction(deposit: NearToken.fromNear(1)),
    ],
  );
  print('Transfer TX: ${transferTx.toJson()}');

  // Build a contract call transaction
  final contractTx = Transaction(
    signerId: AccountId('alice.near'),
    receiverId: AccountId('token.near'),
    actions: [
      FunctionCallAction(
        methodName: 'ft_transfer',
        args: {'receiver_id': 'bob.near', 'amount': '1000000'},
        deposit: NearToken.oneYocto(),
      ),
    ],
  );
  print('Contract TX: ${contractTx.toJson()}');

  // MyNearWallet adapter example
  final adapter = MyNearWalletAdapter(
    config: MyNearWalletConfig(
      contractId: AccountId('token.near'),
      successUrl: 'myapp://callback/success',
      failureUrl: 'myapp://callback/failure',
    ),
    launchUrl: (uri) async {
      print('Launch URL: $uri');
      return true;
    },
  );

  // Build sign-in URL
  final signInUrl = adapter.buildSignInUrl(contractId: AccountId('token.near'));
  print('Sign-in URL: $signInUrl');
}
