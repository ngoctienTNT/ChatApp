import 'package:chat_app/chat/services/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:chat_app/chat/screens/video_call/signaling.dart';
import 'package:chat_app/chat/models/chat_room.dart';
import 'package:get/get.dart';

class VideoCall extends StatefulWidget {
  const VideoCall({Key? key, this.chatRoom, this.id, this.yourToken})
      : super(key: key);
  final ChatRoom? chatRoom;
  final String? id;
  final String? yourToken;

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  Signaling signaling = Signaling();
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  TextEditingController textEditingController = TextEditingController(text: '');
  bool isOpenCamera = true;
  bool isOpenMic = true;
  bool loading = true;
  bool isIncomingCall = false;
  String token = "";
  String myToken = "";

  @override
  void initState() {
    initVideoCall().then((value) => setState(() => loading = false));
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Map<String, dynamic> data = message.data;

      if (data["status"] == "disable_video_call") {
        signaling.hangUp(_localRenderer);
        Get.back();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  Future initVideoCall() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    signaling.openUserMedia(_localRenderer, _remoteRenderer);

    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });
    await FirebaseMessaging.instance
        .getToken()
        .then((value) => myToken = value!);
    if (widget.chatRoom != null) await startVideoCall();

    if (widget.id != null) {
      isIncomingCall = true;
      // await signaling.joinRoom(widget.id!, _remoteRenderer);
    }
  }

  Future startVideoCall() async {
    await signaling.createRoom(_remoteRenderer).then((roomID) async {
      bool check =
          widget.chatRoom!.user1.id == FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(check ? widget.chatRoom!.user2.id : widget.chatRoom!.user1.id)
          .get()
          .then((value) async {
        token = value.data()!["token"];
        await sendPushMessage(
          title:
              check ? widget.chatRoom!.user1.name : widget.chatRoom!.user2.name,
          body: "Đang gọi cho bạn",
          id: roomID,
          status: 'video_call',
          token: token,
          myToken: myToken,
        );
      });
    }).then((value) => null);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            isIncomingCall ? localVideo() : removeVideo(),
            if (!isIncomingCall)
              Positioned(
                right: 10,
                top: 20,
                child: SizedBox(
                  height: Get.width * 0.3 * 15 / 9,
                  width: Get.width * 0.3,
                  child: localVideo(),
                ),
              ),
            isIncomingCall ? incomingCall() : callAway(),
            Positioned(
              right: 10,
              top: 10,
              child: IconButton(
                onPressed: () {
                  signaling.switchCamera();
                },
                icon: const Icon(Icons.cameraswitch),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget localVideo() {
    return RTCVideoView(
      _localRenderer,
      mirror: true,
      objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
    );
  }

  Widget removeVideo() {
    return RTCVideoView(
      _remoteRenderer,
      objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
    );
  }

  Widget callAway() {
    return Positioned(
      bottom: 20,
      child: SizedBox(
        width: Get.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 60,
              width: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(90),
                  ),
                ),
                onPressed: () {
                  signaling.openUserMedia(
                    _localRenderer,
                    _remoteRenderer,
                    video: !isOpenCamera,
                    audio: isOpenMic,
                  );
                  setState(() => isOpenCamera = !isOpenCamera);
                },
                child: Icon(
                  isOpenCamera ? Icons.video_call : Icons.videocam_off,
                ),
              ),
            ),
            const SizedBox(width: 30),
            SizedBox(
              height: 80,
              width: 80,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(90),
                  ),
                ),
                onPressed: () {
                  print("your token${widget.yourToken}");
                  sendPushMessage(
                    title: "",
                    body: "",
                    id: "",
                    status: 'disable_video_call',
                    token: widget.yourToken ?? token,
                    myToken: myToken,
                  );
                  signaling.hangUp(_localRenderer);
                  Get.back();
                },
                child: const Icon(Icons.phone_disabled),
              ),
            ),
            const SizedBox(width: 30),
            SizedBox(
              height: 60,
              width: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                onPressed: () {
                  signaling.muteMic();
                  // signaling.openUserMedia(
                  //   _localRenderer,
                  //   _remoteRenderer,
                  //   video: isOpenCamera,
                  //   audio: !isOpenMic,
                  // );
                  setState(() => isOpenMic = !isOpenMic);
                },
                child: Icon(isOpenMic ? Icons.mic : Icons.mic_off),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget incomingCall() {
    return Positioned(
      bottom: 20,
      child: SizedBox(
        width: Get.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(90),
                  ),
                ),
                onPressed: () async {
                  await signaling.joinRoom(widget.id!, _remoteRenderer);
                  setState(() => isIncomingCall = false);
                },
                child: const Icon(Icons.call),
              ),
            ),
            SizedBox(
              height: 80,
              width: 80,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(90),
                  ),
                ),
                onPressed: () {
                  print("your token${widget.yourToken}");
                  sendPushMessage(
                    title: "",
                    body: "",
                    id: "",
                    status: 'disable_video_call',
                    token: widget.yourToken ?? token,
                    myToken: myToken,
                  );
                  signaling.hangUp(_localRenderer);
                  Get.back();
                },
                child: const Icon(Icons.phone_disabled),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget test() {
    return Column(
      children: [
        const SizedBox(height: 8),
        Wrap(
          children: [
            ElevatedButton(
              onPressed: () {
                signaling.openUserMedia(_localRenderer, _remoteRenderer);
              },
              child: const Text("Open camera & microphone"),
            ),
            const SizedBox(
              width: 8,
            ),
            ElevatedButton(
              onPressed: () async {
                roomId = await signaling.createRoom(_remoteRenderer);
                textEditingController.text = roomId!;
                setState(() {});
              },
              child: const Text("Create room"),
            ),
            const SizedBox(
              width: 8,
            ),
            ElevatedButton(
              onPressed: () {
                // Add roomId
                signaling.joinRoom(
                  textEditingController.text,
                  _remoteRenderer,
                );
              },
              child: const Text("Join room"),
            ),
            const SizedBox(
              width: 8,
            ),
            ElevatedButton(
              onPressed: () {
                signaling.hangUp(_localRenderer);
              },
              child: const Text("Hangup"),
            )
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                RTCVideoView(_remoteRenderer),
                Positioned(
                  right: 10,
                  top: 10,
                  child: SizedBox(
                    height: 80,
                    width: 60,
                    child: RTCVideoView(_localRenderer, mirror: true),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8)
      ],
    );
  }
}
