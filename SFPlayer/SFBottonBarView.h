//
//  SFBottonBarView.h
//  SFPlayer
//
//  Created by apple on 2020/8/3.
//  Copyright © 2020 随风流年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFSlider.h"

typedef void(^BottomSliderChangeBlock)(SFSlider * _Nullable slider);
typedef void(^BottomSliderFinishBlock)(SFSlider * _Nullable slider);
typedef void(^BottomSliderDragBlock)(SFSlider * _Nullable slider);
typedef void(^BottomFullScreenBtnBlock)(UIButton *fullScreenBtn);

NS_ASSUME_NONNULL_BEGIN

@interface SFBottonBarView : UIView

@property (nonatomic, copy) BottomSliderChangeBlock valueChangeBlock;
@property (nonatomic, copy) BottomSliderFinishBlock finishChangeBlock;
@property (nonatomic, copy) BottomSliderDragBlock   draggingSliderBlock;
@property (nonatomic, copy) BottomFullScreenBtnBlock  screenBtnBlock;


@property (nonatomic, strong)           SFSlider             *slider;
@property (nonatomic, strong)           UILabel              *timeLbl;
@property (nonatomic, strong)           UIButton             *fullScreenBtn;
@property (nonatomic, strong)           UILabel              *totalTimeLbl;
@end

NS_ASSUME_NONNULL_END
