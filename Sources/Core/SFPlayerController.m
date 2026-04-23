//
//  SFPlayerController.m
//  SFPlayer
//
//  Created by keep on 2026/4/23.
//

#import "SFPlayerController.h"

@interface SFPlayerController ()

@property (nonatomic, strong, readwrite) SFPlayer *playerView;

@end

@implementation SFPlayerController

- (instancetype)initWithPlayerView:(SFPlayer *)playerView
                     configuration:(SFPlayerConfiguration *)configuration {
    self = [super init];
    if (self) {
        _playerView = playerView;
        _configuration = configuration ?: [SFPlayerConfiguration defaultConfiguration];
        [self bindPlayerCallbacks];
    }
    return self;
}

- (void)playWithURL:(NSString *)videoURL {
    self.playerView.videoURL = videoURL;
    if (!self.configuration.autoPlay) {
        [self.playerView playOrPause];
    }
}

- (void)pause {
    [self.playerView playOrPause];
    if ([self.delegate respondsToSelector:@selector(player:didChangePlaybackState:)]) {
        [self.delegate player:self.playerView didChangePlaybackState:SFPlayerPlaybackStatePaused];
    }
}

- (void)resume {
    [self.playerView playOrPause];
    if ([self.delegate respondsToSelector:@selector(player:didChangePlaybackState:)]) {
        [self.delegate player:self.playerView didChangePlaybackState:SFPlayerPlaybackStatePlaying];
    }
}

- (void)stop {
    [self.playerView destructPlayer];
    if ([self.delegate respondsToSelector:@selector(player:didChangePlaybackState:)]) {
        [self.delegate player:self.playerView didChangePlaybackState:SFPlayerPlaybackStateIdle];
    }
}

- (void)handleContainerScroll {
    [self.playerView playingVideoWithSamllWindow:self.configuration.enableSmallWindowPlayback];
}

#pragma mark - Private

- (void)bindPlayerCallbacks {
    __weak typeof(self) weakSelf = self;
    self.playerView.completedPlayingBlock = ^(SFPlayer * _Nullable player) {
        if ([weakSelf.delegate respondsToSelector:@selector(playerDidFinishPlayback:)]) {
            [weakSelf.delegate playerDidFinishPlayback:weakSelf.playerView];
        }
        if ([weakSelf.delegate respondsToSelector:@selector(player:didChangePlaybackState:)]) {
            [weakSelf.delegate player:weakSelf.playerView didChangePlaybackState:SFPlayerPlaybackStateCompleted];
        }
    };
}

@end
