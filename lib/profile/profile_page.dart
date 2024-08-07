import 'package:flutter/material.dart';
import 'package:flutter_application_1/login_platform.dart';
import 'package:flutter_application_1/profile/editprofile_screen.dart';
import 'package:flutter_application_1/profile/retutorial.dart';
import 'package:flutter_application_1/profile/sign_out_social.dart';
import 'package:flutter_application_1/profile/signout.dart';
import 'package:flutter_application_1/profile/withdrawal_screen.dart';
import 'package:flutter_application_1/login_screen.dart';
import 'package:flutter_application_1/userauthmanager.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static String? nickname;
  static int? age;
  static int? gender;
  bool isLoading = true;
  LoginPlatform _loginPlatform = LoginPlatform.none; // Add this line

  @override
  void initState() {
    super.initState();
    _loadLoginPlatform();

    if (nickname == null || age == null || gender == null) {
      userData();
    } else {
      setState(() {
        isLoading = false;
      });
    }

    // userData();
  }

  Future<void> _loadLoginPlatform() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _loginPlatform = LoginPlatform.values[prefs.getInt('loginPlatform') ?? 4];
    });
  }

  Future<void> userData() async {
    String? token = await getAccessToken();
    var url = Uri.parse('http://potato.seatnullnull.com/users');

    // Function to make the get request
    Future<http.Response> makeGetRequest(String token) {
      return http.get(
        url,
        headers: <String, String>{
          'access': '$token',
          'Content-Type': 'application/json',
        },
      );
    }

    try {
      var response = await makeGetRequest(token!);

      if (response.statusCode == 200) {
        print(response.body);
        var data = json.decode(response.body);
        setState(() {
          nickname = data['name'];
          age = data['age'];
          gender = data['gender'];
          isLoading = false;
        });
      } else if (response.statusCode == 401) {
        // Token expired, attempt to refresh the token
        print('Access token expired. Refreshing token...');

        // Refresh the access token
        bool isRefreshed = await refreshAccessToken();
        if (isRefreshed) {
          // Retry the get request with the new token
          token = await getAccessToken();
          response = await makeGetRequest(token!);

          if (response.statusCode == 200) {
            print(response.body);
            var data = json.decode(response.body);
            setState(() {
              nickname = data['name'];
              age = data['age'];
              gender = data['gender'];
              isLoading = false;
            });
          } else {
            throw Exception('Failed to fetch user data after refreshing token');
          }
        } else {
          throw Exception('Failed to refresh access token');
        }
      } else {
        throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      print('Network error occurred: $e');
    }
  }

  void _updateUserProfile(String newNickname, int newAge, int newGender) {
    setState(() {
      nickname = newNickname;
      age = newAge;
      gender = newGender;
    });
  }

  void _resetUserProfile() {
    setState(() {
      nickname = null;
      age = null;
      gender = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(const Color(0xFFF26647)),
            ))
          : ListView(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Image.asset(
                  'assets/profile.png',
                  width: 30,
                  height: MediaQuery.of(context).size.height * 0.13,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Text(
                  nickname ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.03,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepOrangeAccent),
                ),
                SizedBox(height: 40),
                _buildRoundedTile('Edit profile', Icons.arrow_forward_ios,
                    onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileUpdatePage(
                        currentnickname: nickname ?? '',
                        currentage: age ?? -100,
                        currentgender: gender ?? -1,
                        onProfileUpdate: _updateUserProfile,
                      ),
                    ),
                  );
                }),
                _buildRoundedTile('Tutorial', Icons.arrow_forward_ios,
                    onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RetutorialScreen(),
                    ),
                  );
                }),
                _buildRoundedTile('Log out', Icons.arrow_forward_ios,
                    onTap: () {
                  _showLogoutDialog(context);
                }),
                _buildRoundedTile('Delete account', Icons.arrow_forward_ios,
                    onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WithdrawalScreen(
                        nickname: nickname ?? '',
                        onProfileReset: _resetUserProfile,
                      ),
                    ),
                  );
                }),
              ],
            ),
    );
  }

  Widget _buildRoundedTile(String title, IconData icon,
      {required Function onTap}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.02,
              fontWeight: FontWeight.w500),
        ),
        trailing: Icon(icon),
        onTap: () => onTap(),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.all(0),
          title: Container(
            padding: EdgeInsets.only(left: 24, top: 24, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('', style: TextStyle(fontSize: 18)),
                IconButton(
                  icon: Icon(Icons.close, size: 30),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          content: Text(
            'Are you sure you want to \nlog out?',
            style: TextStyle(fontSize: 18),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Log out', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                print(
                    'Current login platform: $_loginPlatform'); // Add this line
                await SignOutService.signOut(_loginPlatform);
                signout();
                _resetUserProfile(); // Reset user data on sign out
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('loginPlatform');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xfff26647),
              ),
            ),
          ],
        );
      },
    );
  }
}
