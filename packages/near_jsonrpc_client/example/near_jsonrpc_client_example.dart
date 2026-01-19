import 'package:near_jsonrpc_client/near_jsonrpc_client.dart';

void main() async {
  final client = NearRpcClient.mainnet();

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
    accountId: AccountId('near'),
    blockReference: BlockReference.finality(Finality.final_),
  );

  if (accountResult.isSuccess) {
    final account = accountResult.getOrNull()!;
    print('Balance: ${account.amount.toNear()} NEAR');
  }

  client.close();
}
