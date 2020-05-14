import 'dart:io';

class PathUtils {
  static final PathUtils _instance = PathUtils._internal();

  factory PathUtils() => _instance;
  Directory clipsDirectory;
  Directory resultDirectory;
  Directory tempDirectory;

  PathUtils._internal() {
    clipsDirectory = Directory('${_findUserHome()}\\twitch\\clips');
    if (!clipsDirectory.existsSync())
      clipsDirectory.createSync(recursive: true);

    resultDirectory = Directory('${_findUserHome()}\\twitch\\results');
    if (!resultDirectory.existsSync())
      resultDirectory.createSync(recursive: true);

    tempDirectory = Directory('${_findUserHome()}\\twitch\\temp');
    if (!tempDirectory.existsSync()) tempDirectory.createSync(recursive: true);
  }

  String _findUserHome() {
    var envVars = Platform.environment;
    if (Platform.isMacOS) {
      return envVars['HOME'];
    } else if (Platform.isLinux) {
      return envVars['HOME'];
    } else if (Platform.isWindows) {
      return envVars['UserProfile'];
    } else {
      throw UnsupportedError("This OS isn't supported!");
    }
  }

  void clean() {
    clipsDirectory.listSync().forEach((e) => e.deleteSync());
    tempDirectory.listSync().forEach((e) => e.deleteSync());
  }
}
