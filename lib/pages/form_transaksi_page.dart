import 'package:flutter/material.dart';

class FormTransaksiPage extends StatefulWidget {
  const FormTransaksiPage({super.key});

  @override
  State<FormTransaksiPage> createState() => _FormTransaksiPageState();
}

class _FormTransaksiPageState extends State<FormTransaksiPage> {
  final _formKey = GlobalKey<FormState>();

  String jenisTransaksi = 'Pemasukan'; // default
  String kategori = 'Penjualan';

  final TextEditingController jumlahController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1931),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1931),
        title: const Text('Tambah Transaksi'),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Toggle Button Jenis Transaksi
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          jenisTransaksi = 'Pemasukan';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: jenisTransaksi == 'Pemasukan'
                            ? Colors.amber
                            : Colors.white24,
                        foregroundColor: jenisTransaksi == 'Pemasukan'
                            ? Colors.black
                            : Colors.white,
                      ),
                      child: const Text('Pemasukan'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          jenisTransaksi = 'Pengeluaran';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: jenisTransaksi == 'Pengeluaran'
                            ? Colors.amber
                            : Colors.white24,
                        foregroundColor: jenisTransaksi == 'Pengeluaran'
                            ? Colors.black
                            : Colors.white,
                      ),
                      child: const Text('Pengeluaran'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Dropdown kategori
              DropdownButtonFormField<String>(
                value: kategori,
                items: const [
                  DropdownMenuItem(
                    value: 'Penjualan',
                    child: Text('Penjualan'),
                  ),
                  DropdownMenuItem(value: 'Modal', child: Text('Modal')),
                  DropdownMenuItem(value: 'Lainnya', child: Text('Lainnya')),
                ],
                onChanged: (value) {
                  setState(() {
                    kategori = value!;
                  });
                },
                dropdownColor: const Color(0xFF0A1931),
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),

              // Input jumlah
              TextFormField(
                controller: jumlahController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Jumlah',
                  hintStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Masukkan jumlah' : null,
              ),
              const SizedBox(height: 16),

              // Input deskripsi
              TextFormField(
                controller: deskripsiController,
                decoration: const InputDecoration(
                  hintText: 'Deskripsi (Opsional)',
                  hintStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),

              // Tombol upload bukti
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: aksi unggah bukti
                },
                icon: const Icon(Icons.image),
                label: const Text('Unggah Bukti'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white24,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 24),

              // Tombol simpan transaksi
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: aksi simpan transaksi
                    debugPrint('Tipe: $jenisTransaksi');
                    debugPrint('Kategori: $kategori');
                    debugPrint('Jumlah: ${jumlahController.text}');
                    debugPrint('Deskripsi: ${deskripsiController.text}');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Simpan Transaksi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
