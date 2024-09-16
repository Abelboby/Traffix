import 'package:flutter/material.dart';
import 'upload_screen.dart';
import '../services/wallet_service.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crypto Media App')),
      body: Center(
        child: ElevatedButton(
          child: Text('Connect Wallet'),
          onPressed: () async {
            final walletService = WalletService();
            await walletService.connectWallet();
            // Navigate to upload screen after wallet connection
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UploadScreen()),
            );
          },
        ),
      ),
    );
  }
}