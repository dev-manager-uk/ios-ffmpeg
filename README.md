## iOS issue with FFMPEG 

Requires: Mac/XCode/cocoapods

$ sudo gem install cocoapods

$ cd /path/to/project/ios-ffmpeg

$ pod install

- Open DemoFFMEG.xcworkspace

(NOT DemoFFMEG.xcodeproj)

- Build and Run the app

- In the center of app you can see PLAY button

- Press PLAY button

- This calls fmmpeg command 

- Bottom rigth of xcode are logs

Logs with ! are from ffmpeg
Logs with ???? are status and logs from AVItem


 ## Description:
 
We can't get AVPLAYER/AVQueuePlayer/AVPlayer to work with FFMPEG

Currently we get error from AVPlayer (AVPlayerItem):

some : Error Domain=AVFoundationErrorDomain Code=-11850 "Operation Stopped" UserInfo={NSLocalizedFailureReason=The server is not correctly configured., NSLocalizedDescription=Operation Stopped, NSUnderlyingError=0x6000032a01e0 {Error Domain=NSOSStatusErrorDomain Code=-12939 "(null)"}}


+"The HTTP server sending the media resource is not configured as expected. This might mean that the server does not support byte range requests."

some links:

https://developer.apple.com/documentation/avfoundation/averror/code/serverincorrectlyconfigured?changes=_9

https://stackoverflow.com/questions/33823411/avplayer-fails-to-play-video-sometimes

https://stackoverflow.com/questions/32996396/safari-9-0-can-not-play-mp4-video-on-the-storage-server

