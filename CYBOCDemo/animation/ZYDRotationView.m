//
//  ZYDRotationView.m
//  CYBOCDemo
//
//  Created by admin on 2018/3/9.
//  Copyright © 2018年 zhiyun. All rights reserved.
//

#import "ZYDRotationView.h"

@implementation ZYDRotationView

-(instancetype)init{
    if (self = [super init]) {
        [self setUI];
    }
    return self;
}
-(instancetype)initWithImage:(UIImage *)image{
    if (self = [self init]) {
        self.image = image;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 
 */
-(void)setUI{
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat:M_PI *2];
    animation.duration = 2;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT;
    [self.layer addAnimation:animation forKey:nil];
}
@end
