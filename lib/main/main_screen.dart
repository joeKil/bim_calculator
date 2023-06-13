import 'package:bim_calculator/result/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _formKey = GlobalKey<FormState>(); // 간단히 말하면 이 폼의 키를 가지고있음.
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  // 화면이 시작되는 부분
  void initState() {
    super.initState();

    load();
  }

  @override
  // 종료되는 시점
  void dispose() async {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  // 저장을 하나의 메서드로 만듦
  Future save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('height', double.parse(_heightController.text));
    await prefs.setDouble('weight', double.parse(_weightController.text));
  }

  Future load() async {
    final prefs = await SharedPreferences.getInstance();
    // save에 있는 height이 key, save를하면 height을 받아서 값을 저장할 수 있음.
    // 저장을 하는 경우 load할 때 값이 없을 수 있음 그래서 ?를 써준다.
    final double? height = prefs.getDouble('height');
    final double? weight = prefs.getDouble('weight');

    if (height != null && weight != null) {
      _heightController.text = '$height';
      _weightController.text = '$weight';
      print('키 : $height, 몸무게 : $weight');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('비만도 계산기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          // 폼을 쓰려면 폼에 키라는걸 설정해줘야함
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '키',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '키를 입력하세요';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '몸무게',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '몸무게를 입력하세요';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // 검사하는 로직
                  if (_formKey.currentState?.validate() == false) {
                    // 처리 로직 작성 공간
                    return;
                  }

                  // 저장 여기에 이쯤에서하면 더 안전함 save가 언제 끝날지 모르니까.
                  save();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultScreen(
                        // 위에 선언되어있는건 더블이라 글자를 받으려면 변환해줘야함
                        height: double.parse(_heightController.text),
                        weight: double.parse(_weightController.text),
                      ),
                    ),
                  );
                },
                child: const Text('결과'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
