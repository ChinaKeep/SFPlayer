//
//  SFVideoModel.h
//  SFPlayer
//
//  Created by apple on 2020/8/3.
//  Copyright © 2020 随风流年. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFVideoModel : NSObject
@property (nonatomic, copy)           NSString          *title;
@property (nonatomic, copy)           NSString          *playCount;
@property (nonatomic, copy)           NSString          *mp4_url;
@property (nonatomic, copy)           NSString          *m3u8Hd_url;
@property (nonatomic, copy)           NSString          *topicImg;
@property (nonatomic, copy)           NSString          *cover;


@end

NS_ASSUME_NONNULL_END
