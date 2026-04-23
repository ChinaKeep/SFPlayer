# SFPlayer
###一个基于AVFoundation的简易视频播放器，适合于简单视频播放和需要自定义播放器的项目

## Project Structure

```text
SFPlayer/
├── SFPlayer.podspec              # Library entry
├── Sources/
│   ├── Core                      # Player core abstractions
│   ├── UI                        # Control UI components
│   ├── Container                 # Feed/list container helpers
│   └── Resources                 # Bundled assets
└── Example/SFPlayerDemo          # Standalone demo source
```

仓库已经按组件形式拆分，Demo 与库代码分离：
- `Core`: 播放器核心能力
- `UI`: 控件层（进度条、底部控制栏）
- `Container`: 列表/Cell 场景支持

## Installation

### CocoaPods

```ruby
pod 'SFPlayer', '~> 1.0'
```

### Subspecs (Componentized)

```ruby
# Core player + default controls
pod 'SFPlayer/Core'

# UI controls only (for custom integration)
pod 'SFPlayer/UI'

# Feed/list container helpers (depends on Core)
pod 'SFPlayer/Container'
```

### Requirements

- iOS 12.0+
- ARC
- Frameworks: `UIKit`, `AVFoundation`
- `SDWebImage` (only required when using `Container`)

## Demo

Demo 已独立放在 `Example/SFPlayerDemo`，不参与 Pod 打包，方便你单独维护示例工程逻辑。

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
