import 'package:flutter/material.dart';
import 'package:frontend_blockhain/pages/utils/constants.dart';

import '../routes/app_routes.dart';

class FormPengajuanPage extends StatefulWidget {
  const FormPengajuanPage({super.key});

  @override
  State<FormPengajuanPage> createState() => _FormPengajuanPageState();
}

class _FormPengajuanPageState extends State<FormPengajuanPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaUsaha = TextEditingController();
  final TextEditingController jumlahPengajuan = TextEditingController();
  final TextEditingController alasan = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E2F56),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Form Pengajuan",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildField("Nama Usaha", namaUsaha),
              const SizedBox(height: 16),
              _buildField(
                "Jumlah Pengajuan (Rp)",
                jumlahPengajuan,
                isNumber: true,
              ),
              const SizedBox(height: 16),
              _buildField("Alasan Pengajuan", alasan, maxLines: 3),
              const SizedBox(height: 32),
              CustomButton(
                text: "Lanjutkan",
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushNamed(context, AppRoutes.konfirmasiPengajuan);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      validator: (value) => value!.isEmpty ? "Wajib diisi" : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
