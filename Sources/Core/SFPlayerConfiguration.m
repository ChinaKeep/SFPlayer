//
//  SFPlayerConfiguration.m
//  SFPlayer
//
//  Created by keep on 2026/4/23.
//

#import "SFPlayerConfiguration.h"

@implementation SFPlayerConfiguration

+ (instancetype)defaultConfiguration {
    SFPlayerConfiguration *configuration = [[self alloc] init];
    configuration.autoPlay = YES;
    configuration.enableSmallWindowPlayback = YES;
    configuration.autoHideControls = YES;
    configuration.autoHideControlsDelay = 5.0;
    return configuration;
}

- (id)copyWithZone:(NSZone *)zone {
    SFPlayerConfiguration *copy = [[[self class] allocWithZone:zone] init];
    copy.autoPlay = self.autoPlay;
    copy.enableSmallWindowPlayback = self.enableSmallWindowPlayback;
    copy.autoHideControls = self.autoHideControls;
    copy.autoHideControlsDelay = self.autoHideControlsDelay;
    return copy;
}

@end
