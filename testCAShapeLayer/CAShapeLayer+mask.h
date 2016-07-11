//
//  CAShapeLayer+mask.h
//  testCAShapeLayer
//
//  Created by 王迎博 on 16/7/11.
//  Copyright © 2016年 王迎博. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


@interface CAShapeLayer (mask)

+ (instancetype)creatViewMaskWithView:(UIView *)view;

@end
