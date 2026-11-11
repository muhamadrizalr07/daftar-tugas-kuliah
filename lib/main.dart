
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Tugas {
  final int id;
  final String judul;
  final String mataKuliah;
  final DateTime tenggat;

  Tugas({
    required this.id,
    required this.judul,
    required this.mataKuliah,
    required this.tenggat,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daftar Tugas Kuliah',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const HalamanDaftar(),
    );
  }
}

class HalamanDaftar extends StatefulWidget {
  const HalamanDaftar({super.key});

  @override
  State<HalamanDaftar> createState() => _HalamanDaftarState();
}

class _HalamanDaftarState extends State<HalamanDaftar> {
  int _idBerikutnya = 4;

  final List<Tugas> _daftar = [
    Tugas(
      id: 1,
      judul: 'Membuat Makalah',
      mataKuliah: 'Pemrograman Mobile',
      tenggat: DateTime(2026, 11, 15),
    ),
    Tugas(
      id: 2,
      judul: 'Membuat Presentasi',
      mataKuliah: 'Kurikulum Pembelajaran',
      tenggat: DateTime(2026, 11, 18),
    ),
    Tugas(
      id: 3,
      judul: 'Mengerjakan Laporan',
      mataKuliah: 'Pemrograman Internet',
      tenggat: DateTime(2026, 11, 20),
    ),
  ];

  String _formatTanggal(DateTime tanggal) {
    return '${tanggal.day.toString().padLeft(2, '0')}/'
        '${tanggal.month.toString().padLeft(2, '0')}/'
        '${tanggal.year}';
  }

  void _info(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _tambah() async {
    final hasil = await Navigator.push<Tugas>(
      context,
      MaterialPageRoute(
        builder: (_) => HalamanForm(
          idBaru: _idBerikutnya,
        ),
      ),
    );

    if (hasil != null) {
      setState(() {
        _daftar.add(hasil);
        _idBerikutnya++;
      });

      _info('Tugas berhasil ditambahkan');
    }
  }

  Future<void> _ubah(Tugas tugas) async {
    final hasil = await Navigator.push<Tugas>(
      context,
      MaterialPageRoute(
        builder: (_) => HalamanForm(
          tugas: tugas,
          idBaru: _idBerikutnya,
        ),
      ),
    );

    if (hasil != null) {
      final posisi = _daftar.indexWhere(
        (item) => item.id == tugas.id,
      );

      if (posisi == -1) return;

      setState(() {
        _daftar[posisi] = hasil;
      });

      _info('Tugas berhasil diperbarui');
    }
  }

  Future<void> _hapus(Tugas tugas) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Tugas?'),
          content: Text(
            'Apakah kamu yakin ingin menghapus '
            '"${tugas.judul}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (yakin == true) {
      setState(() {
        _daftar.removeWhere(
          (item) => item.id == tugas.id,
        );
      });

      _info('Tugas berhasil dihapus');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Tugas (${_daftar.length})'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _daftar.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Belum ada data',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Silakan tambahkan tugas baru.'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _daftar.length,
              itemBuilder: (context, index) {
                final tugas = _daftar[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                tugas.judul,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              '#${tugas.id}',
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Mata Kuliah: ${tugas.mataKuliah}',
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Tenggat: ${_formatTanggal(tugas.tenggat)}',
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () => _ubah(tugas),
                              icon: const Icon(Icons.edit),
                              label: const Text('Ubah'),
                            ),
                            TextButton.icon(
                              onPressed: () => _hapus(tugas),
                              icon: const Icon(Icons.delete),
                              label: const Text('Hapus'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tambah,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Tugas'),
      ),
    );
  }
}

class HalamanForm extends StatefulWidget {
  final Tugas? tugas;
  final int idBaru;

  const HalamanForm({
    super.key,
    this.tugas,
    required this.idBaru,
  });

  @override
  State<HalamanForm> createState() => _HalamanFormState();
}

class _HalamanFormState extends State<HalamanForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _judulController;
  late final TextEditingController _mataKuliahController;

  DateTime? _tenggat;

  bool get _modeEdit => widget.tugas != null;

  @override
  void initState() {
    super.initState();

    _judulController = TextEditingController(
      text: widget.tugas?.judul ?? '',
    );

    _mataKuliahController = TextEditingController(
      text: widget.tugas?.mataKuliah ?? '',
    );

    _tenggat = widget.tugas?.tenggat;
  }

  @override
  void dispose() {
    _judulController.dispose();
    _mataKuliahController.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final tanggal = await showDatePicker(
      context: context,
      initialDate: _tenggat ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (tanggal != null) {
      setState(() {
        _tenggat = tanggal;
      });
    }
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final hasil = Tugas(
      id: widget.tugas?.id ?? widget.idBaru,
      judul: _judulController.text.trim(),
      mataKuliah: _mataKuliahController.text.trim(),
      tenggat: _tenggat!,
    );

    Navigator.pop(context, hasil);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _modeEdit ? 'Ubah Tugas' : 'Tambah Tugas',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(
                  labelText: 'Judul Tugas',
                  hintText: 'Masukkan judul tugas',
                  prefixIcon: Icon(Icons.assignment),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul wajib diisi';
                  }

                  if (value.trim().length < 3) {
                    return 'Judul minimal 3 karakter';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _mataKuliahController,
                decoration: const InputDecoration(
                  labelText: 'Mata Kuliah',
                  hintText: 'Masukkan nama mata kuliah',
                  prefixIcon: Icon(Icons.school),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Mata kuliah wajib diisi';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 18),
              FormField<DateTime>(
                validator: (_) {
                  if (_tenggat == null) {
                    return 'Tenggat waktu wajib diisi';
                  }

                  return null;
                },
                builder: (field) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _pilihTanggal,
                        icon: const Icon(Icons.calendar_month),
                        label: Text(
                          _tenggat == null
                              ? 'Pilih Tenggat Waktu'
                              : 'Tenggat: ${_tenggat!.day.toString().padLeft(2, '0')}/${_tenggat!.month.toString().padLeft(2, '0')}/${_tenggat!.year}',
                        ),
                      ),
                      if (field.hasError)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 12,
                            top: 5,
                          ),
                          child: Text(
                            field.errorText!,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .error,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 30),
              FilledButton.icon(
                onPressed: _simpan,
                icon: const Icon(Icons.save),
                label: Text(
                  _modeEdit
                      ? 'Simpan Perubahan'
                      : 'Simpan Tugas',
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
