//
//  SFPlayerController.h
//  SFPlayer
//
//  Created by keep on 2026/4/23.
//

#import <Foundation/Foundation.h>

#import "SFPlayer.h"
#import "SFPlayerComponentProtocols.h"
#import "SFPlayerConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

/// Facade controller to reduce direct coupling to SFPlayer internals.
@interface SFPlayerController : NSObject

@property (nonatomic, strong, readonly) SFPlayer *playerView;
@property (nonatomic, strong) SFPlayerConfiguration *configuration;
@property (nullable, nonatomic, weak) id<SFPlayerPlaybackDelegate> delegate;

- (instancetype)initWithPlayerView:(SFPlayer *)playerView
                     configuration:(nullable SFPlayerConfiguration *)configuration NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

- (void)playWithURL:(NSString *)videoURL;
- (void)pause;
- (void)resume;
- (void)stop;

/// Forward scroll events from list containers.
- (void)handleContainerScroll;

@end

NS_ASSUME_NONNULL_END
