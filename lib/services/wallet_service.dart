import 'package:flutter_web3/flutter_web3.dart';

class WalletService {
  Future<void> connectWallet() async {
    if (Ethereum.isSupported) {
      try {
        final accs = await ethereum!.requestAccount();
        print('Connected: $accs');
      } catch (e) {
        print('Error connecting to wallet: $e');
      }
    } else {
      print('Ethereum is not supported');
    }
  }
}