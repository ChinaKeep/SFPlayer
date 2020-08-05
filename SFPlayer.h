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
@property (nonatomic, strong)           NSString                                 * videoURL;
/** 视频的回调 */
@property (nonatomic, copy)             SFVideoCompletedPlayingBlock             completedPlayingBlock;
/** 当前所在行*/
@property (nonatomic, strong)           NSIndexPath                              * currentIndexPath;
/** 当前所在父 UITableView */
@property (nonatomic, strong)           UITableView                              * superTableView;

/// 播放或者暂停
- (void)playOrPause;
/// 播放器释放
- (void)destructPlayer;
/**
 *  UIScrollView 的代理方法scrollViewDidScroll调用
 *  @param support          是否支持小窗口播放
 *
 **/
- (void)playingVideoWithSamllWindow:(BOOL)support;

@end

NS_ASSUME_NONNULL_END
