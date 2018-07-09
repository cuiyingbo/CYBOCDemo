//
//  UITableView+DataRefresh.m
//  CYBOCDemo
//
//  Created by admin on 2018/3/12.
//  Copyright © 2018年 zhiyun. All rights reserved.
//

#import "UITableView+Common.h"
#import "ZYDRefreshNoDataView.h"
#import "ZYDRefreshNetworkErrorView.h"
#import "ZYDRefreshRequestErrorView.h"
#import <objc/runtime.h>
static char loadErrorTypeKey;
static char noDataErrorViewKey;
static char netWorkErrorViewKey;
static char requestErrorViewKey;
static char isInitFinishKey;

@implementation UITableView (Common)
#pragma mark - reloaddata 方法替换
+ (void)load {
    //  只交换一次
    NSLog(@"UITableView (DataRefresh) +(void)load;");
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method reloadData    = class_getInstanceMethod(self, @selector(reloadData));
        Method newReloadData = class_getInstanceMethod(self, @selector(newReloadData));
        method_exchangeImplementations(reloadData, newReloadData);
        
    });
}


-(void)newReloadData{
    [self newReloadData];//执行原来的loaddata方法；
    if (!self.isInitFinish) {//第一次加载显示空页面
        self.isInitFinish = YES;
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSInteger numberOfSections = [self numberOfSections];
        BOOL havingData = NO;
        for (NSInteger i = 0; i < numberOfSections; i++) {
            if ([self numberOfRowsInSection:i] > 0) {
                havingData = YES;
                break;
            }
        }
        if (self.requestErrorView.superview) [self.requestErrorView removeFromSuperview];
        if (self.netWorkErrorView.superview) [self.netWorkErrorView removeFromSuperview];
        if (self.noDataErrorView.superview) [self.noDataErrorView removeFromSuperview];
        if (!havingData) {//只有空数据情况下，才显示加载错误页面
            if (self.loadErrorType == TBLoadErrorTypeNoData) {
                [self addSubview: self.noDataErrorView];
            }else if (self.loadErrorType == TBLoadErrorTypeRequest){
                [self addSubview: self.requestErrorView];
            }else if (self.loadErrorType == TBLoadErrorTypeNetWork){
                [self addSubview: self.netWorkErrorView];
            }else{
                [self addSubview: self.noDataErrorView];
            }
            self.loadErrorType = TBLoadErrorTypeDefault;//默认错误方式，只有指定错误类型才显示其他类型
        }
    });
    
    
}
#pragma mark- 下拉、上拉刷新
-(void)addRefresh:(void (^)(void)) refreshingBlock{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        refreshingBlock();
    }];
    NSArray * images = @[@"tb_gif1",@"tb_gif2",@"tb_gif3",@"tb_gif4",@"tb_gif5",@"tb_gif6",@"tb_gif7",@"tb_gif8"];
    
    NSMutableArray *imageList = [[NSMutableArray alloc]init];
    for (NSString *imageNmae in images) {
        UIImage *img = [UIImage imageNamed:imageNmae];
        [imageList addObject:img];
    }
    NSArray * finishImageList = [NSArray arrayWithObject:[imageList objectAtIndex:imageList.count-1]];
    [header setImages:imageList duration:2 forState:MJRefreshStateRefreshing];
    [header setImages:finishImageList forState:MJRefreshStatePulling];
    [header setImages:finishImageList  forState:MJRefreshStateIdle];
    [header setImages:imageList  forState:MJRefreshStatePulling];
    self.mj_header = header;
}
-(void)beginRefresh{
    [self.mj_header beginRefreshing];
}
-(void)endRefresh{
    [self.mj_header endRefreshing];
}
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return  [UIImage imageNamed:@"√"];
}
#pragma mark - 加载错误，空数据

#pragma mark - setter ,getter
-(UIView *)netWorkErrorView{
    ZYDRefreshNetworkErrorView *networkView = objc_getAssociatedObject(self, &netWorkErrorViewKey);
    if (!networkView) {
        networkView = [[ZYDRefreshNetworkErrorView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        __weak typeof(self)weekSelf = self;
        networkView.refreshNoNetworkViewBlock = ^{
            [weekSelf beginRefresh];
        };
    }
    self.netWorkErrorView = networkView;
    return networkView;
    
}
-(void)setNetWorkErrorView:(UIView *)netWorkErrorView{
    if(netWorkErrorView){
        objc_setAssociatedObject(self, &netWorkErrorViewKey, netWorkErrorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
}
-(UIView *)noDataErrorView{
    ZYDRefreshNoDataView *noDataView = objc_getAssociatedObject(self, &noDataErrorViewKey);
    if (!noDataView) {
        noDataView = [[ZYDRefreshNoDataView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    }
    self.noDataErrorView = noDataView;
    return noDataView;
    
}
-(void)setNoDataErrorView:(UIView *)noDataErrorView{
    if (noDataErrorView) {
        objc_setAssociatedObject(self, &noDataErrorViewKey, noDataErrorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
}
-(UIView *)requestErrorView{
    ZYDRefreshRequestErrorView *requestView = objc_getAssociatedObject(self, &requestErrorViewKey);
    if (!requestView) {
        requestView = [[ZYDRefreshRequestErrorView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        __weak typeof(self)weekSelf = self;
        requestView.refreshRequestErrorViewBlock = ^{
            [weekSelf beginRefresh];
        };
    }
    self.requestErrorView = requestView;
    return requestView;
}
-(void)setRequestErrorView:(UIView *)requestErrorView{
    if (requestErrorView) {
        objc_setAssociatedObject(self, &requestErrorViewKey, requestErrorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

-(TBLoadErrorType)loadErrorType{
    return [objc_getAssociatedObject(self, &loadErrorTypeKey) integerValue];
}
-(void)setLoadErrorType:(TBLoadErrorType)loadErrorType{
    
    //    if (self.noDataErrorView.superview) [self.noDataErrorView removeFromSuperview];
    //    if (self.requestErrorView.superview) [self.requestErrorView removeFromSuperview];
    //    if (self.netWorkErrorView.superview) [self.netWorkErrorView removeFromSuperview];
    //
    //    if (loadErrorType == TBLoadErrorTypeNoData) {
    //        self.backgroundView = self.noDataErrorView;
    //    }else if (loadErrorType == TBLoadErrorTypeRequest){
    //        self.backgroundView = self.requestErrorView;
    //    }else if (loadErrorType == TBLoadErrorTypeNetWork){
    //        self.backgroundView = self.netWorkErrorView;
    //    }else{
    //    }
    objc_setAssociatedObject(self, &loadErrorTypeKey, @(loadErrorType), OBJC_ASSOCIATION_ASSIGN);
    
}

/**
 设置已经加载完成数据了
 */
- (void)setIsInitFinish:(BOOL)finish {
    objc_setAssociatedObject(self, &isInitFinishKey, @(finish), OBJC_ASSOCIATION_ASSIGN);
}

/**
 是否已经加载完成数据
 */
- (BOOL)isInitFinish {
    id obj = objc_getAssociatedObject(self, &isInitFinishKey);
    return [obj boolValue];
}

/**
 设置空数据提示
 
 @param image image description
 @param tip tip description
 */
-(void)setNodataImage:(UIImage *) image tip:(NSString *) tip{
    ZYDRefreshNoDataView * view = (ZYDRefreshNoDataView*) self.noDataErrorView;
    view.tipLabel.text = tip;
    view.tipImageView.image = image;
}
@end

