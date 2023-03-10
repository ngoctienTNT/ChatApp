import 'package:audioplayers/audioplayers.dart';
import 'package:chat_app/chat/models/messages.dart';
import 'package:chat_app/chat/widgets/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowAudioMessage extends StatefulWidget {
  const ShowAudioMessage(
      {Key? key, required this.check, required this.messages})
      : super(key: key);

  final bool check;
  final Messages messages;

  @override
  State<ShowAudioMessage> createState() => _ShowAudioMessageState();
}

class _ShowAudioMessageState extends State<ShowAudioMessage> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isLoading = true;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    initAudio().then((value) => setState(() => isLoading = false));
  }

  Future initAudio() async {
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() => isPlaying = state == PlayerState.playing);
    });

    audioPlayer.onDurationChanged.listen((event) {
      setState(() => duration = event);
    });

    audioPlayer.onPositionChanged.listen((event) {
      if (compareDuration(event, duration)) {
        audioPlayer.stop();
      }
      setState(() => position = event);
    });

    audioPlayer.setReleaseMode(ReleaseMode.loop);
    await audioPlayer.setSource(UrlSource(widget.messages.content.recording!));
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MessageWidget(
      messages: widget.messages,
      check: widget.check,
      child: Container(
        alignment: widget.check ? Alignment.centerRight : Alignment.centerLeft,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.green.shade400,
          child: SizedBox(
            height: 50,
            width: Get.width / 2,
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () async {
                          if (isPlaying) {
                            await audioPlayer.pause();
                          } else {
                            await audioPlayer.resume();
                          }
                          setState(() => isPlaying = !isPlaying);
                        },
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          "${formatTime(position)} / ${formatTime(duration)}",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(":");
  }

  bool compareDuration(Duration duration1, Duration duration2) {
    if (duration1.inHours != duration2.inHours) {
      return false;
    }
    if (duration1.inMinutes != duration2.inMinutes) {
      return false;
    }
    if (duration1.inSeconds != duration2.inSeconds) {
      return false;
    }
    return true;
  }
}
