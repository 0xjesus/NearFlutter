## 0.1.0

- Initial release
- `WalletAdapter` abstract interface for wallet integrations
- Action types: `CreateAccountAction`, `DeployContractAction`, `FunctionCallAction`, `TransferAction`, `StakeAction`, `AddKeyAction`, `DeleteKeyAction`, `DeleteAccountAction`
- Transaction model with multi-action support
- Execution outcome types with sealed class pattern
- NEP-413 message signing support
- `WalletConnectAdapterBase` for WalletConnect 2.0 integration
- `MyNearWalletAdapter` for deep link wallet connection
