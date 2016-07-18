//
//  ViewController.m
//  testCAShapeLayer
//
//  Created by 王迎博 on 16/7/11.
//  Copyright © 2016年 王迎博. All rights reserved.
//

#import "ViewController.h"
#import "CAShapeLayer+mask.h"
#import "YBProgressView.h"
#import "YBWaveProgressView.h"

#define TOTAL_NUM 10

@interface ViewController ()
{
    BOOL isHave;
}
@property (nonatomic, weak) UIView *dynamicView;
@property (nonatomic, strong) CAShapeLayer *indicateLayer;
@property (nonatomic, strong) UIView *demoView;
@property (nonatomic,strong) YBWaveProgressView *bigCicleView;

/** 有动画效果的进度条*/
@property (nonatomic, strong) YBProgressView *progressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //测试view的mask属性
    [self addTestMask];
    
    //测试CAShapeLayer的drawRect属性
    [self addTestDrawRect];
    
    //测试画圆形的进度条
    [self addCycleProgress];
    
    //测试画有动画的进度条
    [self addAnimationProgress];
    
    //测试波浪进度条动画
    [self addWaveProgressView];
}



- (void)addWaveProgressView
{
    self.bigCicleView = [[YBWaveProgressView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 200, 120, 120)];
    self.bigCicleView.backgroundColor = [UIColor colorWithRed:0/255.0 green:152/255.0 blue:246/255.0 alpha:1];;
    [self.view addSubview:self.bigCicleView];
    
    [self.bigCicleView startAnimation];
}


/**
 *  测试画有动画的进度条
 */
- (void)addAnimationProgress
{
    
    self.progressView = [[YBProgressView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 50, 80, 80)];
    [self.view addSubview:self.progressView];
    
    kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
        LRLog(@"异步加载");
        self.view.userInteractionEnabled = NO;
        [self.progressView startCircleAnimation:^(BOOL isFinish) {
            self.view.userInteractionEnabled = YES;
            LRLog(@".......");
        }];
    })
    
    __block YBProgressView *targetView = self.progressView;
    kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            targetView.isCircleStop = YES;
        });
    })
    
}


/**
 *  测试画圆形的进度条
 */
- (void)addCycleProgress
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(40, 350, 100, 100)];
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:view];
    self.demoView = view;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = _demoView.bounds;
    shapeLayer.strokeEnd = 0.7f;
    shapeLayer.strokeStart = 0.1f;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:_demoView.bounds];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 2.0f;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    [_demoView.layer addSublayer:shapeLayer];
    
    CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnima.duration = 3.0f;
    pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnima.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnima.fillMode = kCAFillModeForwards;
    pathAnima.removedOnCompletion = NO;
    [shapeLayer addAnimation:pathAnima forKey:@"strokeEndAnimation"];
}


/**
 *  测试CAShapeLayer的drawRect属性
 */
- (void)addTestDrawRect
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(40, 200, 50, 100)];
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.cornerRadius = 25;
    [self.view addSubview:view];
    self.dynamicView = view;
    _dynamicView.clipsToBounds = YES;
}


/**
 *  调节控制音量条
 */
-(void)refreshUIWithVoicePower: (NSInteger)voicePower{
    CGFloat height = (voicePower)*(CGRectGetHeight(_dynamicView.frame)/TOTAL_NUM);
    [_indicateLayer removeFromSuperlayer];
    _indicateLayer = nil;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, CGRectGetHeight(_dynamicView.frame)-height, CGRectGetWidth(_dynamicView.frame), height) cornerRadius:0];
    _indicateLayer = [CAShapeLayer layer];
    _indicateLayer.path = path.CGPath;
    _indicateLayer.fillColor = [UIColor greenColor].CGColor;
    [_dynamicView.layer addSublayer:_indicateLayer];
}


/**
 *  测试view的mask属性
 */
- (void)addTestMask
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(40, 50, 80, 100)];
    view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:view];
    CAShapeLayer *layer = [CAShapeLayer creatViewMaskWithView:view];
    view.layer.mask = layer;
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    /**
     *  音量条的控制
     */
    if (isHave) {
        [self refreshUIWithVoicePower:0];
        isHave = NO;
    }else
    {
        [self refreshUIWithVoicePower:6];
        isHave = YES;
    }
    
    
    /**
     *  有动画的进度条
     */
    self.view.userInteractionEnabled = NO;
    [self.progressView startCircleAnimation:^(BOOL isFinish) {
        LRLog(@"整个动画结束了。。。");
        self.view.userInteractionEnabled = YES;
    }];
    __block YBProgressView *targetView = self.progressView;
    dispatch_time_t time_after = dispatch_time(DISPATCH_TIME_NOW, 2.0*NSEC_PER_SEC);
    dispatch_after(time_after, dispatch_get_main_queue(), ^{
        targetView.isCircleStop = YES;
        NSLog(@"耗时工作结束了！！！兄弟！！！");
    });
}

@end
