//
//  SFVideoCell.h
//  SFPlayer
//
//  Created by apple on 2020/8/3.
//  Copyright © 2020 随风流年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFVideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (nonatomic, strong)   SFVideoModel        *videoModel;

@end

NS_ASSUME_NONNULL_END
