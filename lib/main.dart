import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp()); // Memulai aplikasi Flutter
}

// Kelas MyApp sebagai root widget aplikasi
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer App', // Judul aplikasi
      theme: ThemeData(
        primarySwatch: Colors.blue, // Tema aplikasi
      ),
      home: TimerPage(), // Halaman utama aplikasi
    );
  }
}

// Kelas TimerPage sebagai StatefulWidget untuk halaman timer
class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState(); // Membuat instance dari _TimerPageState
}

// Kelas _TimerPageState sebagai state dari TimerPage
class _TimerPageState extends State<TimerPage> {
  final TextEditingController _controller = TextEditingController(); 
  Timer? _timer; 
  int _timeInSeconds = 0; 
  int _inputTime = 0; 

  @override
  void dispose() {
    _timer?.cancel(); // Membatalkan timer jika ada
    _controller.dispose(); // Memastikan controller di dispose ketika tidak digunakan
    super.dispose();
  }

  // Memulai timer
  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel(); // Membatalkan timer jika sudah berjalan
    }
    setState(() {
      _timeInSeconds = _inputTime * 60; // Mengatur waktu awal dalam detik
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeInSeconds > 0) {
        setState(() {
          _timeInSeconds--; // Mengurangi waktu setiap detik
        });
      } else {
        _timer!.cancel(); // Membatalkan timer jika waktu habis
        _showTimeIsUpDialog(); // Memunculkan dialog "Waktu Habis!"
      }
    });
  }

  // Menghentikan timer
  void _stopTimer() {
    _timer?.cancel(); // Membatalkan timer jika ada
  }

  // Melanjutkan timer
  void _continueTimer() {
    if (_timer != null) {
      int remainingTime = _timeInSeconds; // Mengambil sisa waktu sebelumnya
      _timer!.cancel(); // Membatalkan timer sebelumnya
      setState(() {
        _timeInSeconds = remainingTime; // Mengatur ulang waktu
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_timeInSeconds > 0) {
          setState(() {
            _timeInSeconds--; // Mengurangi waktu setiap detik
          });
        } else {
          _timer!.cancel(); // Membatalkan timer jika waktu habis
          _showTimeIsUpDialog(); // Memunculkan dialog "Waktu Habis!"
        }
      });
    }
  }

  // Mengatur ulang timer
  void _resetTimer() {
    _stopTimer(); // Menghentikan timer
    setState(() {
      _timeInSeconds = 0; // Mengatur ulang waktu
      _controller.clear(); // Membersihkan input pada TextField
    });
  }

  // Mengonversi waktu dari detik menjadi format menit:detik
  String _printDuration(int seconds) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(seconds ~/ 60); // Menit
    final remainingSeconds = twoDigits(seconds % 60); // Detik
    return "$minutes:$remainingSeconds"; // Format menit:detik
  }

  // Method untuk menampilkan dialog "Waktu Habis!"
  Future<void> _showTimeIsUpDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Tidak bisa menutup dialog dengan mengetuk di luar dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Waktu Habis!'), // Judul dialog
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Waktu yang Anda tetapkan telah habis.'), // Isi dialog
                Text('Silakan atur ulang waktu.'), // Isi dialog
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'), // Tombol OK
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.timer), // Menambahkan ikon timer di sebelah judul
            SizedBox(width: 5), // Memberikan jarak horizontal antara ikon dan judul
            Text('Timer App'), // Menambahkan judul "Timer App"
          ],
        ),
      ),
      body: Card(
        margin: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Fadhila Amalia Fatihah\n222410102084', // Nama dan NIM
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Masukkan Menit', // Label TextField
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _inputTime = int.tryParse(value) ?? 0; // Mendapatkan waktu yang dimasukkan pengguna
                    _timeInSeconds = _inputTime * 60; // Mengatur waktu dalam detik
                  });
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _startTimer, // Tombol untuk memulai timer
                    child: const Text('START'),
                  ),
                  ElevatedButton(
                    onPressed: _stopTimer, // Tombol untuk menghentikan timer
                    child: const Text('STOP'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _resetTimer, // Tombol untuk mengatur ulang timer
                    child: const Text('RESET'),
                  ),
                  ElevatedButton(
                    onPressed: _continueTimer, // Tombol untuk melanjutkan timer
                    child: const Text('CONTINUE'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(
                _printDuration(_timeInSeconds), // Tampilan waktu
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
