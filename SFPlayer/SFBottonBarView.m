//
//  SFBottonBarView.m
//  SFPlayer
//
//  Created by apple on 2020/8/3.
//  Copyright © 2020 随风流年. All rights reserved.
//

#import "SFBottonBarView.h"

@interface SFBottonBarView()

@end


@implementation SFBottonBarView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupBottonBarUI];
        [self setupBottomBarConstraint];
        [self updateConstraintsIfNeeded];
    }
    return self;
}
- (instancetype)init{
    if (self = [super init]) {
        [self setupBottonBarUI];
        [self setupBottomBarConstraint];
        [self updateConstraintsIfNeeded];
    }
    return self;
}
- (void)setupBottonBarUI{
    [self addSubview:self.timeLbl];
    [self addSubview:self.fullScreenBtn];
    [self addSubview:self.totalTimeLbl];
    [self addSubview:self.slider];
    
    __weak typeof(self) weakSelf = self;
    self.slider.valueChangeBlock = ^(SFSlider * _Nonnull slider) {
        weakSelf.valueChangeBlock(slider);
    };
    self.slider.finishChangeBlock = ^(SFSlider * _Nonnull slider) {
        weakSelf.finishChangeBlock(slider);
    };
    self.slider.dragBlock = ^(SFSlider * _Nonnull slider) {
        weakSelf.draggingSliderBlock(slider);
    };
}
- (void)setupBottomBarConstraint{
    [self setupFullScreenBtnConstraint];
    [self setupTotalTimeConstraint];
    [self setupSliderConstraint];
    [self setupTimeLabelConstraint];
}
- (void)setupTimeLabelConstraint{
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.timeLbl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.timeLbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.timeLbl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.timeLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:65.f];
    [self addConstraints:@[left,top,bottom,width]];
}

- (void)setupFullScreenBtnConstraint{
    
    NSLayoutConstraint *btnWidth = [NSLayoutConstraint constraintWithItem:self.fullScreenBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:40.0f];
        
    NSLayoutConstraint *btnHeight = [NSLayoutConstraint constraintWithItem:self.fullScreenBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:40.0f];
        
    NSLayoutConstraint *btnRight = [NSLayoutConstraint constraintWithItem:self.fullScreenBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:0];
       
    NSLayoutConstraint *btnCenterY = [NSLayoutConstraint constraintWithItem:self.fullScreenBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
        
    [self addConstraints:@[btnWidth, btnHeight, btnRight, btnCenterY]];
}
- (void)setupTotalTimeConstraint{
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.totalTimeLbl attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.fullScreenBtn attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0];
         
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.totalTimeLbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
          
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.totalTimeLbl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
         
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.totalTimeLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:65.0f];
    [self addConstraints:@[right, top, bottom, width]];
}

- (void)setupSliderConstraint{
    NSLayoutConstraint *sliderLeft = [NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.timeLbl attribute:NSLayoutAttributeRight multiplier:1.0f constant:0];
    sliderLeft.priority = UILayoutPriorityDefaultLow;
    NSLayoutConstraint *sliderRight = [NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.totalTimeLbl attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0];
    NSLayoutConstraint *sliderTop = [NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
    NSLayoutConstraint *sliderBottom = [NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
    [self addConstraints:@[sliderLeft, sliderRight, sliderTop, sliderBottom]];
}
- (UILabel *)timeLbl{
    if (!_timeLbl) {
        _timeLbl = [[UILabel alloc]init];
        _timeLbl.translatesAutoresizingMaskIntoConstraints = NO;
        _timeLbl.text = @"00:00:00";
        _timeLbl.font = [UIFont systemFontOfSize:12.f];
        _timeLbl.textColor = UIColor.whiteColor;
    }
    return _timeLbl;
}
- (UIButton *)fullScreenBtn{
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fullScreenBtn.translatesAutoresizingMaskIntoConstraints = NO;
        _fullScreenBtn.contentMode = UIViewContentModeCenter;
        [_fullScreenBtn setImage:[UIImage imageNamed:@"ImageResources.bundle/full"] forState:UIControlStateNormal];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"ImageResources.bundle/exfull"] forState:UIControlStateSelected];
        [_fullScreenBtn addTarget:self action:@selector(actionFullScreen) forControlEvents:UIControlEventTouchDown];
        
    }
    return _fullScreenBtn;
}
- (UILabel *)totalTimeLbl{
    if (!_totalTimeLbl) {
        _totalTimeLbl = [[UILabel alloc]init];
        _totalTimeLbl.translatesAutoresizingMaskIntoConstraints = NO;
        _totalTimeLbl.text = @"00:00:00";
        _totalTimeLbl.font = [UIFont systemFontOfSize:12.f];
        _totalTimeLbl.textColor = UIColor.whiteColor;
        _totalTimeLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLbl;
}
- (SFSlider *)slider{
    if (!_slider) {
        _slider = [[SFSlider alloc]init];
        _slider.value = 0.0f;
        _slider.middleValue = 0.0f;
        _slider.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _slider;
}
- (void)actionFullScreen {
    if (self.screenBtnBlock) {
        self.screenBtnBlock(self.fullScreenBtn);
    }
}
@end


