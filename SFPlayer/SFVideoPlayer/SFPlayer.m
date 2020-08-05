//
//  SFPlayer.m
//  SFPlayer
//
//  Created by apple on 2020/7/31.
//  Copyright © 2020 随风流年. All rights reserved.
//

#import "SFPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "SFBottonBarView.h"
#import "SFSlider.h"

@interface SFPlayer()

/** 视频播放器 */
@property (nonatomic, strong)           AVPlayerItem            *playerItem;
@property (nonatomic, strong)           AVPlayerLayer           *playerLayer;
@property (nonatomic, strong)           AVPlayer                *player;

@property (nonatomic, strong)           UIWindow                *keyWindow;
/** 是否是小窗口播放*/
@property (nonatomic, assign)           BOOL                    smallWindowPlaying;
/**是否全屏播放*/
@property (nonatomic, assign)           BOOL                    fullScreenPlaying;
/** 菊花*/
@property (nonatomic, strong)           UIActivityIndicatorView         *indicatorView;
/** 播放按钮*/
@property (nonatomic, strong)           UIButton            *playOrPauseButton;
@property (nonatomic, assign)           BOOL                 isOriginalFrame;
/** 设置初始化frame 方便后期调整播放器大小*/
@property (nonatomic, assign)           CGRect              playerOriginalFrame;
/** 当前播放的时间*/
@property (nonatomic, assign)           CGFloat             currentTime;
/** 播放的总时长*/
@property (nonatomic, assign)           CGFloat             totalDuration;
/** 下方的播放器控制视图*/
@property (nonatomic, strong)           SFBottonBarView              *bottonBarView;
/** 下方控制视图的显示与隐藏*/
@property (nonatomic, assign)           BOOL                    bottomBarHidden;
/** 是否在拖拽滑竿*/
@property (nonatomic, assign)           BOOL                    inOperation;
/** 当前播放的单元格的Frame*/
@property (nonatomic, assign)           CGRect                  currentPlayCellRect;

@end

@implementation SFPlayer
- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = UIColor.blackColor;
        self.keyWindow = [UIApplication sharedApplication].keyWindow;
        
        //screen orientation change
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
        
        // 控制底层视图的显示与隐藏
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showOrHiddenBottomBar)];
        [self addGestureRecognizer:tap];
        //初始化隐藏控制器
        self.bottomBarHidden = YES;
        //进去前后台的监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.playerLayer.frame = self.bounds;
    if (!self.isOriginalFrame) {
        self.playerOriginalFrame = self.frame;
        
        self.playOrPauseButton.frame = CGRectMake((self.playerOriginalFrame.size.width - 60)/2,(self.playerOriginalFrame.size.height - 60)/2,60,60);
        
        self.indicatorView.center = CGPointMake(self.playerOriginalFrame.size.width / 2, self.playerOriginalFrame.size.height / 2);
        
        self.bottonBarView.frame = CGRectMake(0, self.playerOriginalFrame.size.height - 50, self.playerOriginalFrame.size.width, 50);
        
        self.isOriginalFrame = YES;
        
    }
}
/** 设置视频的播放路径*/
- (void)setVideoURL:(NSString *)videoURL{
    _videoURL = videoURL;
    [self.layer addSublayer:self.playerLayer];
    [self insertSubview:self.indicatorView belowSubview:self.playOrPauseButton];
    
    [self.indicatorView startAnimating];
    [self playOrPauseButtonClick:self.playOrPauseButton];
    //底层的控制视图
    [self addSubview:self.bottonBarView];
    [self insertSubview:self.playOrPauseButton aboveSubview:self.indicatorView];
    //进度控制的block
    __weak typeof(self) weakSelf = self;
    self.bottonBarView.valueChangeBlock = ^(SFSlider * _Nullable slider) {
        [weakSelf sliderValueChanged:slider];
    };
    self.bottonBarView.finishChangeBlock = ^(SFSlider * _Nullable slider) {
        [weakSelf sliderFinishChange:slider];
    };
    self.bottonBarView.draggingSliderBlock = ^(SFSlider * _Nullable slider) {
        [weakSelf sliderDragingChange:slider];
    };
    //全屏的block
    self.bottonBarView.screenBtnBlock = ^(UIButton *fullScreenBtn) {
        [weakSelf fullScreenAction];
    };
}
- (void)playOrPause{
    [self playOrPauseButtonClick:self.playOrPauseButton];
}
- (void)destructPlayer{
    [self.player pause];
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    [self removeFromSuperview];
}
- (void)playOrPauseButtonClick:(UIButton *)btn{
    if (self.player.rate == 0.0) {
        btn.selected = YES;
        [self.player play];
    }else if(self.player.rate == 1.0f){
        [self.player pause];
        btn.selected = NO;
    }
}
- (void)showOrHiddenBottomBar{
    if (self.bottomBarHidden) {
        [self showBottomBarView];
    }else{
        [self hiddenBottomBarView];
    }
}
// 显示底部操作视图
- (void)showBottomBarView{
    [UIView animateWithDuration:0.5f animations:^{
        self.bottonBarView.layer.opacity = 0.7f;
        self.playOrPauseButton.layer.opacity = 0.7f;
    } completion:^(BOOL finished) {
        if (finished) {
            self.bottomBarHidden = !self.bottomBarHidden;
            [self performBlock:^{
                if (!self.bottomBarHidden && !self.inOperation) {
                    [self hiddenBottomBarView];
                }
            } afterDelay:5.0f];
        }
    }];
}
// 隐藏底部操作视图
- (void)hiddenBottomBarView{
    self.inOperation = NO;
    [UIView animateWithDuration:0.5f animations:^{
        self.bottonBarView.layer.opacity = 0.0f;
        self.playOrPauseButton.layer.opacity = 0.0f;
    } completion:^(BOOL finished) {
        if (finished) {
            self.bottomBarHidden = !self.bottomBarHidden;
        }
    }];
}

//定义完成时的block
- (void)performBlock:(void(^)(void))block afterDelay:(NSTimeInterval)delay{
    [self performSelector:@selector(callBlockAfterDelay:) withObject:block afterDelay:delay];
}
- (void)callBlockAfterDelay:(void(^)(void))block{
    block();
}
#pragma mark --- Slider变化 ---
- (void)sliderValueChanged:(SFSlider *)slider{
    self.bottonBarView.timeLbl.text = [self getTimeFormatted:slider.value * self.totalDuration];
}
- (void)sliderFinishChange:(SFSlider *)slider{
    self.inOperation = NO;
    [self performBlock:^{
        if (!self.bottomBarHidden && !self.inOperation) {
            [self hiddenBottomBarView];
        }
    } afterDelay:5.0f];
    [self.player pause];
    CMTime currentTime = CMTimeMake(slider.value * self.totalDuration, 1);
    if (slider.middleValue) {
        [self.player seekToTime:currentTime completionHandler:^(BOOL finished) {
            [self.player play];
            self.playOrPauseButton.selected = YES;
        }];
    }
}
- (void)sliderDragingChange:(SFSlider *)slider{
    self.inOperation = YES;
    [self.player pause];
}

#pragma mark --- Screen Orientation ---
- (void)fullScreenAction{
    if (!self.fullScreenPlaying) {
        [self adjustOrientationToLeftFullScreen];
    }else{
        [self adjustToSmallScreen];
    }
}
- (void)statusBarOrientationChange:(NSNotification *)notification{
    if (self.smallWindowPlaying) return;
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationLandscapeLeft) {
        [self adjustOrientationToLeftFullScreen];
    }else if (orientation == UIDeviceOrientationLandscapeRight){
        [self adjustOrientationToRightFullScreen];
    }else if (orientation == UIDeviceOrientationPortrait){
        [self adjustToSmallScreen];
    }
}
- (void)adjustOrientationToLeftFullScreen{
    self.bottonBarView.fullScreenBtn.selected = YES;
    self.fullScreenPlaying = YES;
    [self.keyWindow addSubview:self];
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    [self updateConstraintsIfNeeded];
    [self updateConstraints];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeRotation(M_PI/2);
        self.frame = self.keyWindow.bounds;
        self.bottonBarView.frame = CGRectMake(0, self.keyWindow.bounds.size.width - 50, self.keyWindow.bounds.size.height, 50);
        self.playOrPauseButton.frame = CGRectMake((self.keyWindow.bounds.size.height - 60)/2 , (self.keyWindow.bounds.size.width - 60)/2, 60, 60);
        self.indicatorView.center = CGPointMake(self.keyWindow.bounds.size.height / 2, self.keyWindow.bounds.size.width / 2.0f);
    }];
    [self setStatusBarHidden:YES];
}
- (void)adjustOrientationToRightFullScreen{
    self.bottonBarView.fullScreenBtn.selected = YES;
    self.fullScreenPlaying = YES;
    [self.keyWindow addSubview:self];
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeRight] forKey:@"orientation"];
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeRotation(-M_PI/2);
        self.frame = self.keyWindow.bounds;
        
        self.bottonBarView.frame = CGRectMake(0, self.keyWindow.bounds.size.width - 50, self.keyWindow.bounds.size.height, 50);
        self.playOrPauseButton.frame  = CGRectMake((self.keyWindow.bounds.size.height - 60)/2, (self.keyWindow.bounds.size.width - 60)/2.0, 60, 60);
        self.indicatorView.center = CGPointMake(self.keyWindow.bounds.size.height / 2, self.keyWindow.bounds.size.width / 2);
    }];
    [self setStatusBarHidden:YES];
}
- (void)adjustToSmallScreen{
    self.fullScreenPlaying = NO;
    self.bottonBarView.fullScreenBtn.selected = NO;
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    //小屏播放时，设置视频的位置
    if (self.superTableView) {
        UITableViewCell *cell = [self.superTableView cellForRowAtIndexPath:self.currentIndexPath];
        [cell.contentView addSubview:self];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = self.playerOriginalFrame;
        self.bottonBarView.frame = CGRectMake(0, self.playerOriginalFrame.size.height - 50, self.playerOriginalFrame.size.width, 50);
        self.playOrPauseButton.frame = CGRectMake((self.playerOriginalFrame.size.width - 60)/2.0, (self.playerOriginalFrame.size.height - 60)/2.0, 60, 60);
        self.indicatorView.center = CGPointMake(self.playerOriginalFrame.size.width / 2, self.playerOriginalFrame.size.height / 2.0f);
        [self updateConstraintsIfNeeded];
    }];
    [self setStatusBarHidden:NO];
}
#pragma mark --- 调整播放窗口 ---
- (void)playingVideoWithSamllWindow:(BOOL)support{
    self.currentPlayCellRect = [self.superTableView rectForRowAtIndexPath:self.currentIndexPath];
    
    CGFloat cellBottom = self.currentPlayCellRect.origin.y + self.currentPlayCellRect.size.height;
    CGFloat cellTop = self.currentPlayCellRect.origin.y;
    //如果超过了当前的Cell
    //向上滑动为正，向上滑动的距离超过了cell的底部
    if (self.superTableView.contentOffset.y > cellBottom) {
        if (!support) {
            [self destructPlayer];
            return;
        }
        [self adjustToSmallWindow];
        return;
    }
    //contentOffset.y 超出（0，0）分界线向下滑动为负，否则向下依旧为正， 向上滑动为正
    //超出自己所在的位置
    if (cellTop > self.superTableView.contentOffset.y + self.superTableView.frame.size.height) {
        if (!support) {
            [self destructPlayer];
            return;
        }
        [self adjustToSmallWindow];
        return;
    }
    if (self.superTableView.contentOffset.y < cellBottom) {
        if (!support) {
            return;
        }
        [self gotoOriginalWindow];
        return;
    }
    //在自己的范围内
    if (cellTop < self.superTableView.contentOffset.y + self.superTableView.frame.size.height) {
        if(!support) return;
        [self gotoOriginalWindow];
        return;
    }
}
- (void)adjustToSmallWindow{
    if ([self.superview isKindOfClass:[UIWindow class]])return;
    self.smallWindowPlaying = YES;
    self.playOrPauseButton.hidden = YES;
    self.bottonBarView.hidden = YES;
    //找到相对于keyWindow的坐标系
    CGRect tableViewFrame = [self.superTableView convertRect:self.superTableView.bounds toView:self.keyWindow];
    self.frame = [self convertRect:self.frame toView:self.keyWindow];
    [self.keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat width = self.playerOriginalFrame.size.width * 0.5;
        CGFloat height = self.playerOriginalFrame.size.height * 0.5;
        CGRect smallWindowFrame = CGRectMake(tableViewFrame.origin.x + tableViewFrame.size.width - width, tableViewFrame.origin.y + tableViewFrame.size.height - height, width, height);
        self.frame = smallWindowFrame;
        self.playerLayer.frame = self.bounds;
        self.indicatorView.center = CGPointMake(width / 2.0, height / 2.0);
    }];
    
}
- (void)gotoOriginalWindow{
    if (![self.superview isKindOfClass:[UIWindow class]])return;
    self.smallWindowPlaying = NO;
    self.playOrPauseButton.hidden = NO;
    self.bottonBarView.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(self.currentPlayCellRect.origin.x, self.currentPlayCellRect.origin.y, self.playerOriginalFrame.size.width, self.playerOriginalFrame.size.height);
        self.playerLayer.frame = self.bounds;
        self.indicatorView.center = CGPointMake(self.playerOriginalFrame.size.width / 2.0, self.playerOriginalFrame.size.height / 2.0);
    }completion:^(BOOL finished) {
        self.frame = self.playerOriginalFrame;
        UITableViewCell *cell = [self.superTableView cellForRowAtIndexPath:self.currentIndexPath];
        [cell.contentView addSubview:self];
    }];
}
- (void)addPlayerProgressObserver{
    AVPlayerItem *playerItem = self.player.currentItem;
    __weak typeof(self) weakSelf = self;
    ///周期性检测,每隔0.1秒检测
    [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.1f, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float currentTime = CMTimeGetSeconds(time);
        weakSelf.currentTime = currentTime;
        float totalTime = CMTimeGetSeconds([playerItem duration]);
        weakSelf.bottonBarView.timeLbl.text = [weakSelf getTimeFormatted:currentTime];
        if (currentTime) {
            //没有做操作处理（拖拽或者点击）
            if (!weakSelf.inOperation) {
                weakSelf.bottonBarView.slider.value = currentTime / totalTime;
            }
            if (weakSelf.bottonBarView.slider.value == 1.0f) {
                if (weakSelf.completedPlayingBlock) {
                    if (weakSelf.completedPlayingBlock) {
                        weakSelf.completedPlayingBlock(weakSelf);
                    }
                    weakSelf.completedPlayingBlock = nil;
                    [weakSelf setStatusBarHidden:NO];
                }else{
                    weakSelf.playOrPauseButton.selected = NO;
                    [weakSelf showOrHiddenBottomBar];
                    CMTime currentTime =  CMTimeMake(0, 1);
                    [weakSelf.player seekToTime:currentTime completionHandler:^(BOOL finished) {
                        weakSelf.bottonBarView.slider.value = 0.0f;
                    }];
                }
            }
        }
    }];
}
- (void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    //监控状态属性，注意AVPlayer也有一个status 属性，通过它可以监控到播放器状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //检测网络加载完成的视频进度
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}
#pragma mark --- 时间转换器 ---
- (NSString *)getTimeFormatted:(int)totalSeconds{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
}
- (void)setStatusBarHidden:(BOOL)hidden{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    statusBar.hidden  = hidden;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) {
            self.totalDuration = CMTimeGetSeconds(playerItem.duration);
            self.bottonBarView.totalTimeLbl.text = [self getTimeFormatted:self.totalDuration];
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array  = playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        self.bottonBarView.slider.middleValue  = totalBuffer / CMTimeGetSeconds(playerItem.duration);
        
        if (self.bottonBarView.slider.middleValue <= self.bottonBarView.slider.value
            || (totalBuffer - 1.0) < self.currentTime) {
            NSLog(@"正在缓冲中。。。。。");
            self.indicatorView.hidden = NO;
            [self.indicatorView startAnimating];
        }else{//缓冲好了，进行播放
            self.indicatorView.hidden = YES;
            if (self.playOrPauseButton.selected) {
                [self.player play];
            }
        }
    }
}
#pragma mark --- App 通知 ---
- (void)appWillResignActive:(NSNotification *)notification{
    [self playOrPauseButtonClick:self.playOrPauseButton];
}
- (void)appBecomeActive:(NSNotification *)notification{
    [self playOrPauseButtonClick:self.playOrPauseButton];
}
- (void)appWillEnterForeground:(NSNotification *)notification{
    NSLog(@"appWillEnterForeground");
}
- (void)appDidEnterBackground:(NSNotification *)notification{
    NSLog(@"appDidEnterBackground");
}
#pragma mark --- 懒加载 ---
- (AVPlayerLayer *)playerLayer{
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.backgroundColor = UIColor.blackColor.CGColor;
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    return _playerLayer;
}
- (AVPlayerItem *)playerItem{
    if (!_playerItem) {
        if ([self.videoURL rangeOfString:@"http"].location != NSNotFound) {
            /**
             ios8 用utf8编码
             urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
             iOS 8 以后用下面方法编码
             urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%^{}\"[]|\\<> "].invertedSet];
             */
            _playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:[self.videoURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet]]];
        }else{
            AVAsset *asset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:self.videoURL] options:nil];
            _playerItem = [AVPlayerItem playerItemWithAsset:asset];
        }
    }
    return _playerItem;
}
- (AVPlayer *)player{
    if (!_player) {
        AVPlayerItem *playerItem  = self.playerItem;
        _player = [AVPlayer playerWithPlayerItem:self.playerItem];
        /**进度检测*/
        [self addPlayerProgressObserver];
        /** 播放器状态的更改*/
        [self addObserverToPlayerItem:playerItem];
        NSError *error;
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:&error];
        if (error) {
            NSLog(@"error:%@",[error description]);
        }
        [session setActive:YES error:nil];
    }
    return _player;
}
- (UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView  = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self insertSubview:_indicatorView aboveSubview:self.playOrPauseButton];
    }
    return _indicatorView;
}
- (UIButton *)playOrPauseButton{
    if (!_playOrPauseButton) {
        _playOrPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playOrPauseButton.layer.opacity = 0.0f;
        _playOrPauseButton.contentMode = UIViewContentModeCenter;
        [_playOrPauseButton setBackgroundImage:[UIImage imageNamed:@"ImageResources.bundle/play"] forState:UIControlStateNormal];
        [_playOrPauseButton setBackgroundImage:[UIImage imageNamed:@"ImageResources.bundle/pause"] forState:UIControlStateSelected];
        [_playOrPauseButton addTarget:self action:@selector(playOrPauseButtonClick:) forControlEvents:UIControlEventTouchDown];
    }
    return _playOrPauseButton;
}
- (SFBottonBarView *)bottonBarView{
    if (!_bottonBarView) {
        _bottonBarView = [[SFBottonBarView alloc]init];
        _bottonBarView.backgroundColor = UIColor.blackColor;
        _bottonBarView.layer.opacity = 0.0f;
    }
    return _bottonBarView;
}
- (void)dealloc{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    
}
@end
