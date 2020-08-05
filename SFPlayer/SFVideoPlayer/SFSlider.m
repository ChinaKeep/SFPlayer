//
//  SFSlider.m
//  SFPlayer
//
//  Created by apple on 2020/8/3.
//  Copyright © 2020 随风流年. All rights reserved.
//

#import "SFSlider.h"

// 滑动的距离
static CGFloat panDistance;

@interface SFLayerDelegate : NSObject
@property (nonatomic, assign)               CGFloat         centerY;
///滑动点的直径
@property (nonatomic, assign)               CGFloat         sliderDiameter;
@property (nonatomic, assign)               CGFloat         lineWidth;
@property (nonatomic, assign)               CGFloat         middleValue;

@property (nonatomic, assign)               CGFloat         lineLength;
@property (nonatomic, strong)               UIColor         *maxColor;
@property (nonatomic, strong)               UIColor         *middleColor;
@property (nonatomic, strong)               UIColor         *minColor;
@property (nonatomic, strong)               UIColor         *sliderColor;


@end

@implementation SFLayerDelegate
//自定义layer的代理方法
- (void)drawLayer:(CALayer *)layer inContext:(nonnull CGContextRef)ctx{
    //最大值
    //划线方法
    CGMutablePathRef maxPath = CGPathCreateMutable();
    // 设置七点
    CGPathMoveToPoint(maxPath, NULL, panDistance + self.sliderDiameter, self.centerY);
    //设置终点
    CGPathAddLineToPoint(maxPath, nil, self.lineLength, self.centerY);
    //设置线的颜色
    CGContextSetStrokeColorWithColor(ctx, self.maxColor.CGColor);
    //设置线宽
    CGContextSetLineWidth(ctx, self.lineWidth);
    //在画布上添加线
    CGContextAddPath(ctx, maxPath);
    //闭合路径
    CGPathCloseSubpath(maxPath);
    //渲染
    CGContextStrokePath(ctx);
    //释放
    CGPathRelease(maxPath);
    
    //中间值，中间变化值
    CGMutablePathRef middlePath = CGPathCreateMutable();
    CGPathMoveToPoint(middlePath, NULL, 0, self.centerY);
    CGPathAddLineToPoint(middlePath, nil, self.middleValue * self.lineLength, self.centerY);
    CGContextSetStrokeColorWithColor(ctx, self.middleColor.CGColor);
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextAddPath(ctx, middlePath);
    CGPathCloseSubpath(middlePath);
    CGContextStrokePath(ctx);
    CGPathRelease(middlePath);
    
    //最小值
    CGMutablePathRef minPath = CGPathCreateMutable();
    CGPathMoveToPoint(minPath, NULL, 0, self.centerY);
    CGPathAddLineToPoint(minPath, nil, panDistance, self.centerY);
    CGContextSetStrokeColorWithColor(ctx, self.minColor.CGColor);
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextAddPath(ctx, minPath);
    CGPathCloseSubpath(minPath);
    CGContextStrokePath(ctx);
    CGPathRelease(minPath);
       
    CGMutablePathRef pointPath = CGPathCreateMutable();
    //添加一个适合的圆在矩形的内部
    CGPathAddEllipseInRect(pointPath, nil, CGRectMake(panDistance, self.centerY - (self.sliderDiameter / 2), self.sliderDiameter, self.sliderDiameter));
    CGContextSetFillColorWithColor(ctx, self.sliderColor.CGColor);
    CGContextAddPath(ctx, pointPath);
    CGPathCloseSubpath(pointPath);
    CGContextFillPath(ctx);
    CGPathRelease(pointPath);
}

@end


@interface SFSlider()
{
    CALayer *_lineLayer;
    SFLayerDelegate *_delegate;
}

@end


@implementation SFSlider
- (instancetype)init{
    if (self = [super init]) {
        // 滑动改变进度
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        [self addGestureRecognizer:panGesture];
        //点击改变进度
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tapGesture];
        [tapGesture requireGestureRecognizerToFail:panGesture];
        
        _delegate = [[SFLayerDelegate alloc]init];
        _delegate.maxColor = self.maxColor;
        _delegate.middleColor = self.middleColor;
        _delegate.minColor = self.minColor;
        _delegate.sliderDiameter = self.sliderDiameter;
        _delegate.sliderColor = self.sliderColor;//滑竿颜色
        _delegate.lineWidth = self.lineWidth;

        _lineLayer = [CALayer layer];
        _lineLayer.delegate = _delegate;
        [self.layer addSublayer:_lineLayer];
        [_lineLayer setNeedsDisplay];
        
        [self addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"middleValue" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    _delegate.centerY = self.frame.size.height / 2.0f;
    _delegate.lineLength = self.frame.size.width;
    
    _lineLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [_lineLayer setNeedsDisplay];
}
#pragma mark --- 手势方法 ---
- (void)panAction:(UIPanGestureRecognizer *)panGesture{
    CGFloat x = [panGesture translationInView:self].x;
    panDistance += x;
    // 设置极限值
    panDistance = panDistance >= 0 ? panDistance : 0;
    panDistance = panDistance <= (self.frame.size.width - self.sliderDiameter) ? panDistance : (self.frame.size.width - self.sliderDiameter);
    [panGesture setTranslation:CGPointZero inView:self];
    
    self.value = panDistance / (self.frame.size.width - self.sliderDiameter);
    
    if (panGesture.state == UIGestureRecognizerStateEnded && self.finishChangeBlock) {
        self.finishChangeBlock(self);
        
    }else if((panGesture.state == UIGestureRecognizerStateChanged || UIGestureRecognizerStateBegan) && self.dragBlock){
        self.dragBlock(self);
    }
}
- (void)tapAction:(UITapGestureRecognizer *)tapGesture{
    CGPoint location = [tapGesture locationInView:self];
    panDistance = location.x;
    self.value = panDistance / (self.frame.size.width - self.sliderDiameter);
    if (self.finishChangeBlock) {
        self.finishChangeBlock(self);
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"value"]) {
        [_lineLayer setNeedsDisplay];
        if (self.valueChangeBlock) {
            self.valueChangeBlock(self);
        }
    }
    if ([keyPath isEqualToString:@"middleValue"]) {
        [_lineLayer setNeedsDisplay];
    }
}
#pragma mark --- set方法 ---
//生成成员变量，调用get方法
@synthesize sliderColor = _sliderColor;
@synthesize lineWidth = _lineWidth;
@synthesize minColor = _minColor;
@synthesize middleColor = _middleColor;
@synthesize maxColor = _maxColor;
@synthesize sliderDiameter = _sliderDiameter;

//滑动杆的颜色
- (void)setSliderColor:(UIColor *)sliderColor{
    _sliderColor = sliderColor;
}
- (UIColor *)sliderColor{
    if (!_sliderColor) {
        return UIColor.whiteColor;
    }
    return _sliderColor;
}
- (void)setSliderDiameter:(CGFloat)sliderDiameter {
    _sliderDiameter = sliderDiameter;
    _delegate.sliderDiameter = sliderDiameter;
}

- (CGFloat)sliderDiameter {
    if (!_sliderDiameter) {
        return 10.0f;
    }
    return _sliderDiameter;
}

- (void)setMinColor:(UIColor *)minColor {
    _minColor = minColor;
    _delegate.minColor = minColor;
}
//最小的颜色
- (UIColor *)minColor {
    if (!_minColor) {
        return [UIColor greenColor];
    }
    return _minColor;
}

- (void)setMaxColor:(UIColor *)maxColor {
    _maxColor = maxColor;
    _delegate.maxColor = maxColor;
}
//最大的颜色，就是么有进度是滑竿的颜色
- (UIColor *)maxColor {
    if (!_maxColor) {
        return [UIColor darkGrayColor];
    }
    return _maxColor;
}

- (void)setMiddleColor:(UIColor *)middleColor {
    _middleColor = middleColor;
    _delegate.middleColor = middleColor;
}

- (UIColor *)middleColor {
    if (!_middleColor) {
//        return  [UIColor lightGrayColor];
        return  [UIColor redColor];
    }
    return _middleColor;
}

- (CGFloat)lineWidth {
    if (!_lineWidth) {
        return 1.0f;
    }
    return _lineWidth;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    _delegate.lineWidth = lineWidth;
}

-(void)setMiddleValue:(CGFloat)middleValue {
    _middleValue = middleValue;
    _delegate.middleValue = middleValue;
}

- (void)setValue:(CGFloat)value {
    _value = value;
    panDistance = value * (self.frame.size.width - self.sliderDiameter);
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"value"];
    [self removeObserver:self forKeyPath:@"middleValue"];
}

@end
