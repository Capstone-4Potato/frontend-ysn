import 'package:flutter/material.dart';
import 'package:flutter_application_1/profile/tutorial.dart';
import 'package:flutter_application_1/token.dart';
//import 'package:flutter_application_1/vulnerablesoundtest/starting_teat_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserInputForm extends StatefulWidget {
  final String socialId;

  const UserInputForm({Key? key, required this.socialId}) : super(key: key);

  @override
  _UserInputFormState createState() => _UserInputFormState();
}

class _UserInputFormState extends State<UserInputForm> {
  final _formKey = GlobalKey<FormState>();
  late String birthYear;
  late int gender;
  late String nickname;
  late int age;

  void calculateAge() {
    int currentYear = DateTime.now().year;
    int birthYearInt = int.parse(birthYear);
    age = currentYear - birthYearInt + 1;
  }

  Future<void> signup() async {
    Uri url = Uri.parse('http://potato.seatnullnull.com/users');
    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'socialId': widget.socialId,
          'age': age,
          'gender': gender,
          'name': nickname,
        }),
      );
      //print(1234567);
      switch (response.statusCode) {
        case 200:
          print(response.body);
          String? accessToken = response.headers['access'];
          print(accessToken);
          if (accessToken != null) {
            await saveAccessToken(accessToken); // Save access token
          }
          break;
        case 401:
          print('로그아웃 설정');
          break;
        case 500:
          print(response.body);
          // 오류 처리 로직, 예를 들어 사용자에게 오류 알림 등
          break;
        default:
          print('알 수 없는 오류가 발생했습니다. 상태 코드: ${response.statusCode}');
          // 기타 상태 코드에 대한 처리
          break;
      }
    } catch (e) {
      print('네트워크 오류가 발생했습니다: $e');
      // 네트워크 예외 처리 로직
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                SizedBox(height: 30),
                Text(
                  'Almost done!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'For effective Korean pronunciation correction, we provide voices \ntailored to your age and gender.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 40),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Birth Year',
                    fillColor: Colors.white, // 내부 배경색을 흰색으로 설정
                    filled: true, // 배경색 채우기 활성화
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ), // 모서리를 더 둥글게
                    focusedBorder: OutlineInputBorder(
                      // 포커스 상태일 때의 테두리 스타일
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Color(0xFFF26647), // 테두리 색상 변경
                        width: 1.5, // 테두리 너비
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    birthYear = value!;
                    calculateAge();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your birth year.';
                    }
                    int? year = int.tryParse(value);
                    if (year == null) {
                      return 'Please enter your birth year.';
                    } else if (year > DateTime.now().year) {
                      return 'Please enter your birth year.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    fillColor: Colors.white, // 내부 배경색을 흰색으로 설정
                    filled: true, // 배경색 채우기 활성화
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // 포커스 상태일 때의 테두리 스타일
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Color(0xFFF26647), // 테두리 색상 변경
                        width: 1.5, // 테두리 너비
                      ),
                    ),
                  ),
                  items: <int>[0, 1].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value == 0 ? 'Male' : 'Female'),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      gender = newValue!;
                    });
                  },
                  onSaved: (value) {
                    gender = value!;
                  },
                  validator: (value) {
                    if (value == null /*|| value.isEmpty*/) {
                      return 'Please select your gender.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nickname',
                    fillColor: Colors.white, // 내부 배경색을 흰색으로 설정
                    filled: true, // 배경색 채우기 활성화
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // 포커스 상태일 때의 테두리 스타일
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Color(0xFFF26647), // 테두리 색상 변경
                        width: 1.5, // 테두리 너비
                      ),
                    ),
                  ),
                  onSaved: (value) {
                    nickname = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your nickname.';
                    } else if (value.length < 3) {
                      return 'Nickname must be at least 3 characters.';
                    } else if (value.length > 8) {
                      return 'Nickname must be at most 8 characters.';
                    } else if (value.contains(' ')) {
                      return 'Nickname cannot contain spaces.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      signup(); // 서버로 데이터 제출

                      //튜토리얼로 이동
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TutorialScreen()),
                        (route) => false,
                      );
                    }
                  },
                  child: Text('Submit',
                      style: TextStyle(
                          fontSize: 20, color: Colors.white)), // 텍스트 크기 조정
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF26647), // 버튼 배경색 설정
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}