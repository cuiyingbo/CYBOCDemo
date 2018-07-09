//
//  ZYDRefreshRequestErrorView.m
//  CYBOCDemo
//
//  Created by admin on 2018/3/14.
//  Copyright © 2018年 zhiyun. All rights reserved.
//

#import "ZYDRefreshRequestErrorView.h"

@implementation ZYDRefreshRequestErrorView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.tipLabel];
        [self addSubview:self.tipImageView];
        UITapGestureRecognizer * tabGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        [self addGestureRecognizer:tabGesture];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.tipImageView.frame = CGRectMake((self.frame.size.width - 100)/2, 74, 100, 100);
    self.tipLabel.frame = CGRectMake(0, self.tipImageView.frame.origin.y + self.tipImageView.frame.size.height + 20, self.frame.size.width, 20);
}

- (UIImageView *)tipImageView {
    if (!_tipImageView) {
        _tipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tb_requestError"]];
    }
    return _tipImageView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.text = @"加载失败，点击页面重试";
        _tipLabel.font = [UIFont systemFontOfSize:15];
        _tipLabel.textColor = [UIColor grayColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

-(void)tapGesture:(UITapGestureRecognizer *) gestureRecognizer{
    !self.refreshRequestErrorViewBlock ?: self.refreshRequestErrorViewBlock();
    
}


@end
