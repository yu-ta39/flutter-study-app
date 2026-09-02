import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const StudyApp());
}

class StudyApp extends StatelessWidget {
  const StudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StudyHome(),
    );
  }
}

class StudyHome extends StatefulWidget {
  @override
  State<StudyHome> createState() => _StudyHomeState();
}

class _StudyHomeState extends State<StudyHome> {
  List<String> subjects = [];
  List<int> studyTimes = []; // 勉強時間（秒）
  bool studying = false;
  late Timer timer;
  int currentSeconds = 0;

  final TextEditingController subjectController = TextEditingController();

  void startStudy() {
    setState(() {
      studying = true;
      currentSeconds = 0;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        currentSeconds++;
      });
    });
  }

  void stopStudy() {
    timer.cancel();
    setState(() {
      studying = false;
      studyTimes.add(currentSeconds);
    });
  }

  int get totalStudyTime {
    return studyTimes.fold(0, (sum, t) => sum + t);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("勉強管理アプリ（初心者用）")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 科目追加
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: subjectController,
                    decoration: const InputDecoration(
                      labelText: "科目名を入力",
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      subjects.add(subjectController.text);
                      subjectController.clear();
                    });
                  },
                  child: const Text("追加"),
                )
              ],
            ),

            const SizedBox(height: 20),

            // 科目一覧
            const Text("科目一覧", style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (_, i) {
                  return ListTile(
                    title: Text(subjects[i]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          subjects.removeAt(i);
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // 勉強時間記録
            Text("今日の合計勉強時間：${totalStudyTime ~/ 3600}時間 ${totalStudyTime ~/ 60 % 60}分"),

            const SizedBox(height: 10),

            studying
                ? Column(
              children: [
                Text("勉強中：${currentSeconds ~/ 3600} ： "
                    "${currentSeconds ~/ 60 % 60}："
                    "${currentSeconds % 60}"
                ),
                ElevatedButton(
                  onPressed: stopStudy,
                  child: const Text("終了"),
                ),
              ],
            )
                : ElevatedButton(
              onPressed: startStudy,
              child: const Text("勉強開始"),
            ),
          ],
        ),
      ),
    );
  }
}
