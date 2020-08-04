//
//  SFPlayer.h
//  SFPlayer
//
//  Created by apple on 2020/7/31.
//  Copyright © 2020 随风流年. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SFPlayer;

typedef void(^SFVideoCompletedPlayingBlock)(SFPlayer * _Nullable player);
NS_ASSUME_NONNULL_BEGIN


@interface SFPlayer : UIView
/// videoURL 视频路径
@property (nonatomic, strong)           NSString           * videoURL;
@property (nonatomic, copy)             SFVideoCompletedPlayingBlock            completedPlayingBlock;

/// 播放或者暂停
- (void)playOrPause;
/// dealloc
- (void)destructPlayer;

 
@end

NS_ASSUME_NONNULL_END
