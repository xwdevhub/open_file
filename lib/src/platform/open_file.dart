import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_file/src/common/open_result.dart';
import 'windows.dart' as windows;
import 'linux.dart' as linux;

class OpenFile {
  static const MethodChannel _channel = const MethodChannel('open_file');

  OpenFile._();

  ///[filePath] On web you need to pass the file name to determine the file type
  ///[linuxDesktopName] like 'xdg'/'gnome'
  static Future<OpenResult> open(String? filePath,
      {String? type,
      String? uti,
      String linuxDesktopName = "xdg",
      bool linuxByProcess = false,
      Uint8List? webData}) async {
    assert(filePath != null);
    if (!Platform.isMacOS && !Platform.isIOS && !Platform.isAndroid) {
      int _result;
      var _windowsResult;
      if (Platform.isLinux) {
        var filePathLinux = Uri.file(filePath!);
        if (linuxByProcess) {
          _result =
              Process.runSync('xdg-open', [filePathLinux.toString()]).exitCode;
        } else {
          _result = linux
              .system(['$linuxDesktopName-open', filePathLinux.toString()]);
        }
      } else if (Platform.isWindows) {
        _windowsResult = windows.shellExecute('open', filePath!);
        _result = _windowsResult <= 32 ? 1 : 0;
      } else {
        _result = -1;
      }
      return OpenResult(
          type: _result == 0 ? ResultType.done : ResultType.error,
          message: _result == 0
              ? "done"
              : _result == -1
                  ? "This operating system is not currently supported"
                  : "there are some errors when open $filePath${Platform.isWindows ? "   HINSTANCE=$_windowsResult" : ""}");
    }

    Map<String, String?> map = {
      "file_path": filePath!,
      "type": type,
      "uti": uti,
    };
    final _result = await _channel.invokeMethod('open_file', map);
    final resultMap = json.decode(_result) as Map<String, dynamic>;
    return OpenResult.fromJson(resultMap);
  }

  static Future close() async {
    if (!Platform.isIOS) {
      return;
    }

    Map<String, String?> map = {};
    await _channel.invokeMethod('close_file', map);
  }
}
