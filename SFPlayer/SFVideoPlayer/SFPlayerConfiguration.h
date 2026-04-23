//
//  SFPlayerConfiguration.h
//  SFPlayer
//
//  Created by keep on 2026/4/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFPlayerConfiguration : NSObject <NSCopying>

/// Automatically start playback after assigning `videoURL`.
@property (nonatomic, assign) BOOL autoPlay;
/// Whether small-window playback is enabled while scrolling.
@property (nonatomic, assign) BOOL enableSmallWindowPlayback;
/// Whether to hide controls after inactivity.
@property (nonatomic, assign) BOOL autoHideControls;
/// Delay used by custom controls to auto-hide.
@property (nonatomic, assign) NSTimeInterval autoHideControlsDelay;

+ (instancetype)defaultConfiguration;

@end

NS_ASSUME_NONNULL_END
