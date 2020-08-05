//
//  SFSlider.h
//  SFPlayer
//
//  Created by apple on 2020/8/3.
//  Copyright © 2020 随风流年. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SFSlider;

NS_ASSUME_NONNULL_BEGIN

typedef void(^SFSliderValueChangeBlock)(SFSlider *slider);
typedef void(^SFSliderFinishChangeBlock)(SFSlider *slider);
typedef void(^SFSliderDraggingBlock)(SFSlider *slider);

@interface SFSlider : UIView
/** 取值范围 0 ~ 1 */
@property (nonatomic, assign)           CGFloat         value;
/** 中间值 取值范围 0 ~ 1 */
@property (nonatomic, assign)           CGFloat         middleValue;
/** 线的宽度 */
@property (nonatomic, assign)           CGFloat         lineWidth;
/** 滑动杆的直径 */
@property (nonatomic, assign)           CGFloat         sliderDiameter;
/** 滑竿的颜色 */
@property (nonatomic, strong)           UIColor         *sliderColor;
/** 颜色的最大值 */
@property (nonatomic, strong)           UIColor         *maxColor;
/** 颜色最小值 */
@property (nonatomic, strong)           UIColor         *minColor;
/** 颜色中间值 */
@property (nonatomic, strong)           UIColor         *middleColor;

@property (nonatomic, copy)             SFSliderValueChangeBlock valueChangeBlock;
@property (nonatomic, copy)             SFSliderFinishChangeBlock finishChangeBlock;
@property (nonatomic, copy)             SFSliderDraggingBlock dragBlock;

@end

NS_ASSUME_NONNULL_END
