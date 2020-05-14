import 'dart:convert';
import 'dart:io';

import 'package:TwitchClips/path_utils.dart';
import 'package:TwitchClips/twitch_data.dart';
import 'package:http/http.dart' as http;

var pathUtils = PathUtils();

Future findAndDownloadClips(var language, var game) async {
  print('[Debug] Inzio ricerca clips...');
  var topClipsResponse = await http.get(
      'https://api.twitch.tv/kraken/clips/top?language=$language&limit=50&period=day&game=$game',
      headers: {
        'Client-ID': '',
        'Accept': 'application/vnd.twitchtv.v5+json'
      });
  var clipsToDownloadContainer =
      TwitchClipContainer.fromJson(json.decode(topClipsResponse.body));
  print('[Debug] Clips trovate, inzio il download...');

  double time = 0;
  for (TwitchClip entry in clipsToDownloadContainer.clips) {
    if (time >= 600) {
      break;
    }

    await _downloadClip(entry);
    time = time + entry.duration;
  }

  print(
      '[Debug] Download delle clips completato, inzio ad unirle in un unico video...');
  var sources = File('${pathUtils.tempDirectory.path}\\sources.txt');
  var writer = sources.openWrite();
  for (var entry in pathUtils.clipsDirectory.listSync()) {
    var tsPath = entry.path.replaceAll('.mp4', '.ts');
    Process.runSync(
        'ffmpeg -i "${entry.path}" -c copy -bsf:v h264_mp4toannexb -f mpegts "$tsPath"',
        []);
    writer.write("file '${tsPath}'");
    writer.write('\n');
  }

  await writer.close();
  var result = File('${pathUtils.resultDirectory.path}\\${game}_$language.mp4');
  Process.runSync(
      'ffmpeg -y -f concat -safe 0 -i "${sources.path}" -c copy -bsf:a aac_adtstoasc "${result.path}"',
      []);
  print('[TwitchIO] Compilation completata!');
}

Future _downloadClip(TwitchClip clip) async {
  var clipRequest = await http.post('https://clipr.xyz/api/grabclip',
      body: '{"clip_url":"${clip.url}"}',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json, text/plain, */*',
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36',
      });

  String clipDownloadLink =
      json.decode(clipRequest.body)['download_url'].replaceAll('//', '');
  await _downloadLink(clip.trackingId, clipDownloadLink);
}

Future _downloadLink(var name, var clipDownloadLink) async {
  var request =
      await HttpClient().getUrl(Uri.parse('https://$clipDownloadLink'));
  var response = await request.close();
  await response
      .pipe(File(pathUtils.clipsDirectory.path + '\\$name.mp4').openWrite());
}
