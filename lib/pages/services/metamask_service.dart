import 'package:flutter_web3/flutter_web3.dart';

class MetaMaskService {
  static Future<bool> checkWalletConnection() async {
    if (!Ethereum.isSupported || ethereum == null) {
      print("❌ Browser tidak mendukung MetaMask.");
      return false;
    }

    try {
      final accounts = await ethereum!.requestAccount();
      if (accounts.isNotEmpty) {
        print("✅ MetaMask sudah terkoneksi dengan: ${accounts.first}");
        return true;
      } else {
        print("⚠️ Tidak ada akun MetaMask yang terhubung.");
        return false;
      }
    } catch (e) {
      print("❌ Error cek koneksi MetaMask: $e");
      return false;
    }
  }

  static Future<bool> connectWallet() async {
    if (!Ethereum.isSupported || ethereum == null) {
      print("❌ Browser tidak mendukung MetaMask.");
      return false;
    }

    try {
      final accounts = await ethereum!.requestAccount();
      if (accounts.isNotEmpty) {
        print("✅ Berhasil koneksi ke MetaMask: ${accounts.first}");
        return true;
      } else {
        print("❌ Tidak ada akun yang dipilih.");
        return false;
      }
    } catch (e) {
      print("❌ Error saat connectWallet: $e");
      return false;
    }
  }

  static Future<double> getBalance() async {
    if (!Ethereum.isSupported || ethereum == null) {
      print("❌ Browser tidak mendukung MetaMask.");
      return 0.0;
    }

    try {
      final accounts = await ethereum!.requestAccount();
      if (accounts.isEmpty) {
        print("⚠️ Tidak ada akun MetaMask yang terhubung.");
        return 0.0;
      }

      final balanceBigInt = await provider!.getBalance(accounts.first);
      final balanceEth = balanceBigInt / BigInt.from(10).pow(18);

      return balanceEth.toDouble();
    } catch (e) {
      print("❌ Error ambil saldo: $e");
      return 0.0;
    }
  }
}
