//
//  ViewController.m
//  testCAShapeLayer
//
//  Created by 王迎博 on 16/7/11.
//  Copyright © 2016年 王迎博. All rights reserved.
//

#import "ViewController.h"
#import "CAShapeLayer+mask.h"

#define TOTAL_NUM 10

@interface ViewController ()
{
    BOOL isHave;
}
@property (nonatomic, weak) UIView *dynamicView;
@property (nonatomic, strong) CAShapeLayer *indicateLayer;
@property (nonatomic, strong) UIView *demoView;

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
    if (isHave) {
        [self refreshUIWithVoicePower:0];
        isHave = NO;
    }else
    {
        [self refreshUIWithVoicePower:6];
        isHave = YES;
    }
}

@end
