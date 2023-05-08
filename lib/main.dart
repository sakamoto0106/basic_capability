import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

void main() {
  runApp(SocialSkillApp());
}

class SocialSkillApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '社会人基礎力評価',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SocialSkillHomePage(),
    );
  }
}

class SocialSkillHomePage extends StatefulWidget {
  @override
  _SocialSkillHomePageState createState() => _SocialSkillHomePageState();
}

class _SocialSkillHomePageState extends State<SocialSkillHomePage> {
  final List<String> skills = [
    '主体性',
    '働きかけ力',
    '実行力',
    '課題発見力',
    '計画力',
    '創造力',
    '発信力',
    '傾聴力',
    '柔軟性',
    '情報把握',
    '規律性',
    'ストレスコントロール'
  ];
  List<int> scores = List.filled(12, 0);
  List<String> reasons = List.filled(12, '');

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 0; i < skills.length; i++) {
        scores[i] = prefs.getInt('score$i') ?? 0;
        reasons[i] = prefs.getString('reason$i') ?? '';
      }
    });
  }

  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < skills.length; i++) {
      prefs.setInt('score$i', scores[i]);
      prefs.setString('reason$i', reasons[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('社会人基礎力評価'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveData();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: skills.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(skills[index]),
              subtitle: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('点数：${scores[index]}',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(width: 15),
                      ElevatedButton(
                        onPressed: () {
                          _showScoreDialog(context, index);
                        },
                        child: Text('点数入力'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          _showReasonDialog(context, index);
                        },
                        child: Text('理由記入'),
                      ),
                    ],
                  ),
                  if (reasons[index].isNotEmpty)
                    SizedBox(width: 10),
                  Text('理由：${reasons[index]}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showScoreDialog(BuildContext context, int index) {
    TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(skills[index],
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'スコアを入力してください',
                  hintText: '1-10の範囲で入力してください',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('キャンセル'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  int score = int.tryParse(_controller.text) ?? 0;
                  if (score >= 1 && score <= 10) {
                    scores[index] = score;
                  }
                });
                Navigator.pop(context);
              },
              child: Text('決定'),
            ),
          ],
        );
      },
    );
  }

  void _showReasonDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('理由を記入'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                reasons[index] = value;
              });
            },
            decoration: InputDecoration(
              hintText: '理由を入力してください',
            ),
            maxLines: null,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('決定'),
            ),
          ],
        );
      },
    );
  }
}
