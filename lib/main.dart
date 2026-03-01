import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _recorder = AudioRecorder();
  final _player = AudioPlayer();

  bool isRecording = false;
  String? filePath;

  Future<void> startRecording() async {
    await Permission.microphone.request();

    final dir = await getApplicationDocumentsDirectory();
    filePath = "${dir.path}/audio_test.m4a";

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
      ),
      path: filePath!,
    );

    setState(() {
      isRecording = true;
    });
  }

  Future<void> stopRecording() async {
    await _recorder.stop();
    setState(() {
      isRecording = false;
    });
  }

  Future<void> playRecording() async {
    if (filePath != null && File(filePath!).existsSync()) {
      await _player.setFilePath(filePath!);
      await _player.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Microfono iOS")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: isRecording ? null : startRecording,
              child: const Text("Start"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: isRecording ? stopRecording : null,
              child: const Text("Stop"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: playRecording,
              child: const Text("Play"),
            ),
          ],
        ),
      ),
    );
  }
}