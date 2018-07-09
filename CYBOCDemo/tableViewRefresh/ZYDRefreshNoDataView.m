//
//  ZYDRefreshNoDataView.m
//  CYBOCDemo
//
//  Created by admin on 2018/3/14.
//  Copyright © 2018年 zhiyun. All rights reserved.
//

#import "ZYDRefreshNoDataView.h"

@implementation ZYDRefreshNoDataView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.tipLabel];
        [self addSubview:self.tipButton];
        [self addSubview:self.tipImageView];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.tipImageView.frame = CGRectMake((self.bounds.size.width - 150)/2, 130, 150, 150);
    self.tipLabel.frame = CGRectMake(0, self.tipImageView.frame.origin.y + self.tipImageView.frame.size.height + 20, self.frame.size.width, 20);
    
}

-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.text = @"暂无数据";
        _tipLabel.font = [UIFont systemFontOfSize:15];
        _tipLabel.textColor = [UIColor grayColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}
-(UIImageView *)tipImageView{
    
    if (!_tipImageView) {
        _tipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tb_noData"]];
    }
    return _tipImageView;
}


@end
