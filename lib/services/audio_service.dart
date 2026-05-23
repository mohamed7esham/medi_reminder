import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static AudioPlayer? _player;

  static Future<void> playAlarm() async {
    _player ??= AudioPlayer();

    await _player!.setReleaseMode(ReleaseMode.loop);

    await _player!.play(AssetSource('sounds/alarm.mp3'), volume: 1);
  }

  static Future<void> stopAlarm() async {
    await _player?.stop();
    _player = null;
  }
}
