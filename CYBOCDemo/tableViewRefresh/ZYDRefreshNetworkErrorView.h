//
//  ZYDRefreshNetworkErrorView.h
//  CYBOCDemo
//
//  Created by admin on 2018/3/14.
//  Copyright © 2018年 zhiyun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshNoNetworkViewBlock)();
@interface ZYDRefreshNetworkErrorView : UIView

@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) UIImageView *tipImageView;
@property(nonatomic, copy) RefreshNoNetworkViewBlock refreshNoNetworkViewBlock;

@end

