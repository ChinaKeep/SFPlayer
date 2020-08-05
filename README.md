# SFPlayer
###一个基于AVFoundation的简易视频播放器，适合于简单视频播放和需要自定义播放器的项目
##### 使用方法
```
/// 播放或者暂停
- (void)playOrPause;
/// 播放器释放
- (void)destructPlayer;
/// videoURL 视频路径
- (void)setVideoURL:(NSString *)videoURL
/** 视频的回调 */
SFVideoCompletedPlayingBlock
```
- 小屏播放
![小屏播放](B6E72FD36244D4CDB2604A39ADB7CA47.png)

- 大屏播放
![播放界面](IMG_3394(20200805-103059).JPEG)
