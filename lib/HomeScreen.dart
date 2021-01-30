import 'dart:io' show Platform;

import 'package:finstaller/scripts/LinuxScriptRunner.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var currentPlatform = "Void";
  Color progressColor = Color(0xff383CC1);
  String startStatus = "false";
  String ot = "Welcome to Flutter Installer";

  linuxScriptExecuter() async {
    var script = new LinuxScriptRunner();
    // print(script.preRequistCheck());
    if (await script.preRequistCheck()) {
      setState(() {
        ot = ot + "\n" + "Internet Connection Found";
      });
      if (await script.checkIfFlutterExist()) {
        setState(() {
          ot = ot +
              "\n" +
              "Flutter sdk not found" +
              "All PreRequist Condition met Starting Fetching Process" +
              "\n Fetching Sdk from github.......";
        });
        if (await script.fetchSdk()) {
          setState(() {
            ot = ot + "\n" + "Sdk Fetched";
          });
        } else {
          setState(() {
            ot = ot +
                "\n" +
                "All PreRequist Condition are not met process terminated";
          });
        }
      } else {
        setState(() {
          ot = ot + "\n" + "Flutter Sdk Already Installed Process Terminated";
        });
      }
    } else {
      setState(() {
        ot = ot + "\n" + "404 Please check Your Internet Connection";
      });
    }
  }

  platformChecker() async {
    if (Platform.isLinux) {
      setState(() {
        startStatus = "true";
      });
      linuxScriptExecuter();
      print("Found its Linux");
    } else if (Platform.isMacOS) {
      setState(() {
        startStatus = "true";
      });
      print("Found its MacOs");
    } else if (Platform.isWindows) {
      setState(() {
        startStatus = "true";
      });
      print("Found its Windows");
    } else {
      setState(() {
        startStatus = "false";
      });
      print("Platform not supported");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff383CC1),
        actions: [
          Expanded(
            child: Center(
              child: FittedBox(
                fit: BoxFit.fill,
                alignment: Alignment.center,
                child: Text("Flutter Installer"),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            color: Color(0xff1B98F5),
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.49,
                    width: MediaQuery.of(context).size.width * 1,
                    color: Color(0xff120E43),
                    child: Text(
                      ot,
                      style: TextStyle(color: Color(0xff1B98F5)),
                    )),
                Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.01,
                    width: MediaQuery.of(context).size.width * 1,
                    color: Colors.white,
                    child: startStatus == "true"
                        ? LinearProgressIndicator(
                            backgroundColor: Colors.lightBlue,
                          )
                        : FittedBox(
                            fit: BoxFit.fill,
                            alignment: Alignment.center,
                            child: Text("WelCome To Flutter Installer"),
                          )),
                Container(
                    height: MediaQuery.of(context).size.height * 0.50,
                    width: MediaQuery.of(context).size.width * 1,
                    color: Color(0xff383CC1),
                    child: Container(
                      color: Color(0xff3944F7),
                      alignment: Alignment.center,
                      child: MaterialButton(
                          color: Color(0xff2827CC),
                          child: FittedBox(
                            alignment: Alignment.center,
                            fit: BoxFit.contain,
                            child: Text(
                              "Install Flutter",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.03),
                            ),
                          ),
                          onPressed: () {
                            platformChecker();
                          }),
                    )),
              ],
            )),
      ),
    );
  }
}
