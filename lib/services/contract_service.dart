import 'package:flutter_web3/flutter_web3.dart';
import '../models/media_item.dart';
import '../utils/constants.dart';

class ContractService {
  late Contract _contract;

  ContractService() {
    _initContract();
  }

  void _initContract() {
    _contract = Contract(
      CONTRACT_ADDRESS,
      CONTRACT_ABI,
      provider!.getSigner(),
    );
  }

  Future<void> uploadMediaData(MediaItem mediaItem) async {
    try {
      await _contract.call('uploadMedia', [
        mediaItem.cid,
        mediaItem.description,
        mediaItem.location,
        BigInt.from(mediaItem.timestamp),
      ]);
    } catch (e) {
      print('Error uploading media data: $e');
      rethrow;
    }
  }
}