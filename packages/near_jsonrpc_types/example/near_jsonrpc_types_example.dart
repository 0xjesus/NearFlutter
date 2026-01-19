import 'package:near_jsonrpc_types/near_jsonrpc_types.dart';

void main() {
  // Account IDs with validation
  final account = AccountId('alice.near');
  print('Account: $account');

  // NEAR tokens (handles 24 decimal places)
  final amount = NearToken.fromNear(10);
  print('Amount: ${amount.toNear()} NEAR');

  // Public keys
  final key = PublicKey('ed25519:6E8sCci9badyRkXb3JoRpBj5p8C6Tw41ELDZoiihKEtp');
  print('Key type: ${key.keyType}');

  // Block references
  final finalRef = BlockReference.finality(Finality.final_);
  print('Block reference: ${finalRef.toJson()}');
}
