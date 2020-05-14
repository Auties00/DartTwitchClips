import 'dart:io';

import 'package:TwitchClips/path_utils.dart';
import 'package:TwitchClips/twitch_clip_finder.dart';

void main(List<String> arguments) async {
  print('[Debug] Benvenuto nel compilatore automatico di clip twitch!');
  await findAndDownloadClips('en', 'fortnite');
  print('[Debug] Cancello i files...');
  PathUtils().clean();
  print('[Debug] Files cancellati!');
  exit(0);
}
