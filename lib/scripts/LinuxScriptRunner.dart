import 'package:get/get_connect/http/src/http/io/file_decoder_io.dart';
import 'package:process_run/shell.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LinuxScriptRunner {
  var shell = Shell();

  preRequistCheck() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      print(_.message);
      return false;
    }
  }

  checkIfFlutterExist() async {
    try {
      var result = await shell.run('''
    fluttr --version
    ''');
      if (result.errText.isEmpty) {
        return false;
      }
      return true;
    } on ShellException catch (e) {
      print(e.message);
      return true;
    }
  }

  fetchSdk() async {
    Directory dDir = await getDownloadsDirectory();

    String dPath = dDir.path + "/.sdkenv";
    try {
      var hiddenDirGenerator = await shell.run('''
    mkdir $dPath
      ''');
      if (hiddenDirGenerator.errText.isEmpty) {
        print('Folder Not Found So new Generated');
      } else {
        print('folder already Exist');
      }
    } on ShellException catch (e) {
      print(e.message);
    }

    var cloneShell = shell.pushd(dPath);

    try {
      var removeOld = await cloneShell.run('''
      rm -rf flutter
      ''');
      if (removeOld.errText.isEmpty) {
        print("No Old Sdk Existed");
      } else {
        print("Old Downloaded Sdk Removed");
      }
    } on ShellException catch (e) {
      print(e.message);
    }

    try {
      var downloadOutput = await cloneShell.run('''
    git clone -b master https://github.com/flutter/flutter.git
    ''');
      if (downloadOutput.errText.isEmpty) {
        shellChecker(dPath);

        return true;
      }
      return false;
    } on ShellException catch (e) {
      print(e.message);
      return false;
    }
  }

  shellChecker(String dpath) async {
    var currentShell;
    var shellC = shellEnvironment.entries;
    shellC.forEach((element) {
      if (element.key == "SHELL") {
        currentShell = element.value;
        setEnvironmentPath(currentShell, dpath);
      }
    });
  }

  setEnvironmentPath(var currentShell, var dpath) async {
    final PATH = "PATH";
    final envShell = new Shell();
    var shellFileLocation;
    if (dpath.toString().contains("Downloads")) {
      var homePath =
          dpath.toString().replaceAll(new RegExp("Downloads/.sdkenv"), '');
      shellFileLocation = homePath.trim();
      // print(shellFileLocation);
      envShell.pushd(shellFileLocation);
    } else {
      print("startegy Failed");
    }

    if (currentShell.toString().contains("zsh")) {
      final filename = '$shellFileLocation.zshrc';
      new File(filename)
          .writeAsString("export PATH=$dpath/flutter/bin:$PATH",
              mode: FileMode.append)
          .then((value) => print(value.toString()));
    } else if (currentShell.toString().contains("bash")) {
      final filename = '$shellFileLocation.bashrc';
      new File(filename)
          .writeAsString("export PATH=$dpath/flutter/bin:$PATH",
              mode: FileMode.append)
          .then((value) => print(value.toString()));
    } else if (currentShell.toString().contains("fish")) {
      print("Work In Progress");
    } else {
      print("Valid Shell That are supported not found");
    }
  }

  checkInstallation() async {
    try {
      var result = await shell.run('''
    flutter --version
    ''');
      if (result.errText.isEmpty) {
        print("Flutter Installed Sucessfull");
      } else {
        print("Installation failed");
      }
    } on ShellException catch (e) {
      print(e.result);
    }
  }
}
