//
//  SFVideoCell.m
//  SFPlayer
//
//  Created by apple on 2020/8/3.
//  Copyright © 2020 随风流年. All rights reserved.
//

#import "SFVideoCell.h"
#import "UIImageView+WebCache.h"

@implementation SFVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    for (NSLayoutConstraint *constraint in self.videoImageView.constraints) {
        // The legacy xib pins trailing + centerX; fixed width causes conflicts on wider devices.
        if (constraint.firstAttribute == NSLayoutAttributeWidth && ABS(constraint.constant - 320.0f) < 0.1f) {
            constraint.active = NO;
        }
    }
}

- (void)setVideoModel:(SFVideoModel *)videoModel{
    _videoModel = videoModel;
    NSString *coverURLString = videoModel.cover;
    if ([coverURLString hasPrefix:@"http://"]) {
        coverURLString = [coverURLString stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
    }
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:coverURLString]];
    self.titleLbl.text = videoModel.title;
    self.count.text = videoModel.replyCount;
    
}

@end
