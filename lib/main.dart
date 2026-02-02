import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: SimpleTrainingApp()));
}

class Sample {
  final String imageUrl;
  final String answer;
  Sample(this.imageUrl, this.answer);

  factory Sample.fromList(List<String> list) {
    return Sample(list[0], list[1]);
  }
}

class SimpleTrainingApp extends StatefulWidget {
  const SimpleTrainingApp({super.key});
  @override
  State<SimpleTrainingApp> createState() => _SimpleTrainingAppState();
}

const String appTitle = 'SR,SSRどっちでしょう？';

class _SimpleTrainingAppState extends State<SimpleTrainingApp> {
  final List<List<String>> data = [
    ["https://pbs.twimg.com/media/Do0nmYEUwAE1yqI?format=jpg&name=4096x4096", "SR"],
    ["https://pbs.twimg.com/media/Do0qRGnUYAILHEc?format=jpg&name=4096x4096", "SR"],
    ["https://pbs.twimg.com/media/ERM5OISU8AAtgkv?format=jpg&name=4096x4096", "SR"],
    ["https://pbs.twimg.com/media/EX4iqCHWkAAibxZ?format=jpg&name=4096x4096", "SR"],
    ["https://pbs.twimg.com/media/EoDSi8LUUAAkLFu?format=jpg&name=4096x4096", "SR"],
    ["https://pbs.twimg.com/media/D_GClh1UYAA_mYN?format=jpg&name=4096x4096", "SR"],
    ["https://pbs.twimg.com/media/DpIPQlPWsAArcYD?format=jpg&name=4096x4096", "SR"],
    ["https://pbs.twimg.com/media/FVr4_zvVIAA_xdk?format=jpg&name=4096x4096", "SSR"],
    ["https://pbs.twimg.com/media/EZU7CANUYAAuT-N?format=jpg&name=4096x4096", "SSR"],
    ["https://pbs.twimg.com/media/EUcpTd-U8AA_osc?format=jpg&name=4096x4096", "SSR"],
    ["https://pbs.twimg.com/media/D6MHfz2UwAIW-Z9?format=jpg&name=4096x4096", "SSR"],
    ["https://pbs.twimg.com/media/E56ewtEUUAU24GN?format=jpg&name=4096x4096", "SSR"],
    ["https://pbs.twimg.com/media/Ef7rEoSUYAEnprH?format=jpg&name=4096x4096", "SR"],
    ["https://pbs.twimg.com/media/FivVip1UcAEvVme?format=jpg&name=4096x4096", "SR"],
    ["https://pbs.twimg.com/media/G-NRxbKXIAAJQ2D?format=jpg&name=4096x4096", "SSR"],
    ["https://pbs.twimg.com/media/EVS1JV0UYAAluOo?format=jpg&name=medium", "SSR"],
    ["https://pbs.twimg.com/media/EfHsamiUwAEJPJh?format=jpg&name=4096x4096", "SSR"]
      ];

  late final List<Sample> _samples;
  int _index = 0;
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
    _samples = data.map((e) => Sample.fromList(e)).toList();
    _samples.shuffle(Random());
  }

  void _onTap() {
    setState(() {
      if (_showAnswer) {
        _showAnswer = false;

        // 最後まで行ったら再シャッフルして先頭へ
        if (_index == _samples.length - 1) {
          _samples.shuffle(Random());
          _index = 0;
        } else {
          _index++;
        }
      } else {
        _showAnswer = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_samples.isEmpty) {
      return const Scaffold(body: Center(child: Text('データがありません')));
    }

    final sample = _samples[_index];

    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTap,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                sample.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (c, w, p) => p == null ? w : const Center(child: CircularProgressIndicator()),
                errorBuilder: (e1, e2, e3) => const Center(child: Text('画像を読み込めません')),
              ),
            ),

            if (_showAnswer)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    sample.answer,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            Positioned(
              top: 10,
              right: 10,
              child: _hint(_showAnswer ? 'タップで次へ' : 'タップで正解表示'),
            ),

            Positioned(
              top: 10,
              left: 10,
              child: _hint('${_index + 1}/${_samples.length}'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hint(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
