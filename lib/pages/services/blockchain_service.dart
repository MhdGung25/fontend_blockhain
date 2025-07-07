import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart'; // For making HTTP requests

class BlockchainService {
  final String rpcUrl; // e.g. https://mainnet.infura.io/v3/YOUR-PROJECT-ID
  final String privateKey; // Your wallet's private key (keep it safe!)
  late Web3Client _client;
  late Credentials _credentials;
  late EthereumAddress _ownAddress;

  BlockchainService({required this.rpcUrl, required this.privateKey}) {
    _client = Web3Client(rpcUrl, Client());
    _credentials = EthPrivateKey.fromHex(privateKey);
  }

  // Initialize own address from private key
  Future<EthereumAddress> getOwnAddress() async {
    _ownAddress = await _credentials.extractAddress();
    return _ownAddress;
  }

  // Get Ether balance of your address
  Future<EtherAmount> getBalance() async {
    final address = await getOwnAddress();
    return await _client.getBalance(address);
  }

  // Send Ether transaction (to another address)
  Future<String> sendTransaction(String toAddress, double amountInEther) async {
    final receiver = EthereumAddress.fromHex(toAddress);
    final amount = EtherAmount.fromUnitAndValue(EtherUnit.ether, amountInEther);

    final txHash = await _client.sendTransaction(
      _credentials,
      Transaction(to: receiver, value: amount),
      chainId:
          null, // set your network chain id here if needed, e.g., 1 for mainnet
    );

    return txHash; // returns the transaction hash
  }

  // Dispose client to close http connections
  void dispose() {
    _client.dispose();
  }
}
