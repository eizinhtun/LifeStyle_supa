// @dart=2.9
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

///
class VolumeSlider extends StatelessWidget {
  final _volume = ValueNotifier<int>(100);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Text(
          "Volume",
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        Expanded(
          child: ValueListenableBuilder<int>(
            valueListenable: _volume,
            builder: (context, volume, _) {
              return Slider(
                inactiveColor: Colors.transparent,
                value: volume.toDouble(),
                min: 0.0,
                max: 100.0,
                divisions: 10,
                label: '$volume',
                onChanged: (value) {
                  _volume.value = value.round();
                  context.ytController.setVolume(volume);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
