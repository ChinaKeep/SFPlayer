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
    // Initialization code
}

- (void)setVideoModel:(SFVideoModel *)videoModel{
    _videoModel = videoModel;
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.cover]];
}

@end
