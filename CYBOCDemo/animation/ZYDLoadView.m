//
//  ZYDLoadView.m
//  CYBOCDemo
//
//  Created by admin on 2018/2/26.
//  Copyright © 2018年 zhiyun. All rights reserved.
//

#import "ZYDLoadView.h"

NSString *const ZYDLoadingImage  = @"icon_football";
CGFloat const ZYDLoadViewWidth = 80;
CGFloat const ZYDLoadViewHeight = 80;
CGFloat const ZYDLoadingImageWidth = 40;
CGFloat const ZYDLoadingImageHeight = 40;
CGFloat const ZYDLoadingImageX = (ZYDLoadViewWidth - ZYDLoadingImageWidth)/2;



@implementation ZYDLoadView{
    BOOL isShowing ;
}
-(instancetype)init{
    if (self = [super init]) {
        isShowing = NO;
        [self setUI];
    }
    return self;
}
+(instancetype) shareInstance{
    static ZYDLoadView * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZYDLoadView alloc]init];
    });
    return  instance;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect {
    
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setUI];
}
-(void)setUI{
    UIImageView *loadImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:ZYDLoadingImage]];
    loadImg.frame = CGRectMake(ZYDLoadingImageX, 0, ZYDLoadingImageWidth, ZYDLoadingImageHeight);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat:M_PI *2];
    animation.duration = 2;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT;
    [loadImg.layer addAnimation:animation forKey:nil];
    [self addSubview:loadImg];
    
}
-(void) starLoad{
    if (isShowing) {
        return;
    }
    isShowing = YES;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //实现模糊效果
    UIBlurEffect *blurEffrct =[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    //毛玻璃视图
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
    visualEffectView.frame =  CGRectMake(0, 0, ZYDLoadViewWidth,ZYDLoadViewHeight);
    visualEffectView.center = window.center;
    visualEffectView.alpha = 0.8;

    self.frame = CGRectMake(0, 0, ZYDLoadViewWidth,ZYDLoadViewHeight);
    self.backgroundColor  = [UIColor clearColor];
    [visualEffectView.contentView addSubview:self];


    [window addSubview:visualEffectView];
//    self.frame =  CGRectMake(0, 0, ZYDLoadViewWidth,ZYDLoadViewHeight);
//    self.center = window.center;
//    self.backgroundColor  = [UIColor clearColor];
//    [window addSubview:self];
}

-(void) endLoad{
    if (!isShowing) {
        return;
    }
    [self removeFromSuperview];
    isShowing = NO;
}
@end
