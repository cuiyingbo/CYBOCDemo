//
//  UITableView+DataRefresh.h
//  CYBOCDemo
//
//  Created by admin on 2018/3/12.
//  Copyright © 2018年 zhiyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
typedef enum:NSInteger{
    TBLoadErrorTypeDefault,
    TBLoadErrorTypeNoData,
    TBLoadErrorTypeRequest,
    TBLoadErrorTypeNetWork
} TBLoadErrorType;
@interface UITableView (Common)

/**
 空数据错误提示页面类型
 */
@property (nonatomic,assign) TBLoadErrorType loadErrorType;

/**
 暂无数据
 */
@property (nonatomic,strong) UIView * noDataErrorView;
/**
 网络异常
 */
@property (nonatomic,strong) UIView * netWorkErrorView;
/**
 数据加载失败
 */
@property (nonatomic,strong) UIView * requestErrorView;

@property (nonatomic,assign) BOOL isInitFinish;


/**
 空数据页面设置
 @param image 图片
 @param tip 提示语
 */
-(void)setNodataImage:(UIImage *) image tip:(NSString *) tip;

-(void)addRefresh:(void (^)(void)) refreshingBlock;

-(void)beginRefresh;

-(void)endRefresh;


//-(void)loadNoData;
//-(void)loadFail;
@end

