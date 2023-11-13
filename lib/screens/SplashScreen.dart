import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:video_player_test/screens/videoList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/videoListModel.dart';
import '../utils/customdialog.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Dio dio = Dio();
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
    checkInternetConnection();
    //fetchData();
  }

  void saveToLocalStorage(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = json.encode(data); // Convert to JSON string
    await prefs.setString('response_data', jsonData);
  }

  Future<String> getFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedData = prefs.getString('response_data');
    //print(storedData);
    return storedData ?? "";
  }

  Future<void> checkInternetConnection() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      _connectivityResult = connectivityResult;
    });

    String storedData = await getFromStorage();
    if (connectivityResult == ConnectivityResult.none && storedData == "") {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: 'No internet connection',
              titleColor: const Color(0xffED1E54),
              descriptions:
                  'Please check your internet connection and try again.',
              text: 'OK',
              functionCall: () {
                Navigator.pop(context);
                checkInternetConnection();
              },
              img: 'assets/dialog_error.svg',
            );
          });
    } else if (connectivityResult == ConnectivityResult.none &&
        storedData != "") {
      useLocalData();
    } else {
      fetchData();
    }
  }

  void fetchData() async {
    try {
      Response response = await dio.get('https://app.et/devtest/list.json');
      ModelForVidesClass object = ModelForVidesClass();
      object = ModelForVidesClass.fromJson(response.data);

      saveToLocalStorage(response.data);

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => VideoList(
                  listOfVideos: object,
                )),
      );
    } catch (e) {
      useLocalData();
    }
  }

  void useLocalData() async {
    String storedData = await getFromStorage();
    Map<String, dynamic> parsedData = json.decode(storedData);
    ModelForVidesClass fromLocal = ModelForVidesClass();
    fromLocal = ModelForVidesClass.fromJson(parsedData);

    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => VideoList(
                listOfVideos: fromLocal,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/sp.png",
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
