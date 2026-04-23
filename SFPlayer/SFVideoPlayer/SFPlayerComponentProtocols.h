//
//  SFPlayerComponentProtocols.h
//  SFPlayer
//
//  Created by keep on 2026/4/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SFPlayer;

typedef NS_ENUM(NSUInteger, SFPlayerPlaybackState) {
    SFPlayerPlaybackStateIdle,
    SFPlayerPlaybackStatePlaying,
    SFPlayerPlaybackStatePaused,
    SFPlayerPlaybackStateBuffering,
    SFPlayerPlaybackStateCompleted,
    SFPlayerPlaybackStateFailed
};

@protocol SFPlayerPlaybackDelegate <NSObject>

@optional
- (void)player:(SFPlayer *)player didChangePlaybackState:(SFPlayerPlaybackState)state;
- (void)playerDidFinishPlayback:(SFPlayer *)player;

@end

/// Optional contract for custom controls. The player module can drive your own control view.
@protocol SFPlayerControlViewProtocol <NSObject>

@required
- (UIView *)controlView;
- (void)sf_setLoading:(BOOL)loading;
- (void)sf_setPlaying:(BOOL)playing;
- (void)sf_updateCurrentTime:(NSTimeInterval)currentTime
                totalTime:(NSTimeInterval)totalTime
                 progress:(CGFloat)progress
           bufferProgress:(CGFloat)bufferProgress;

@optional
- (void)sf_setFullscreen:(BOOL)fullscreen;

@end

NS_ASSUME_NONNULL_END
