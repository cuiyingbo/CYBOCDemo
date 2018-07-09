//
//  UITableView+DragToLoadData.m
//  Football
//
//  Created by weichen on 15/11/17.
//  Copyright © 2015年 bet007. All rights reserved.
//

#import "UITableView+DragToLoadData.h"
#define btn_color      [UIColor colorWithRed:0xf5/255.0 green:0x7b/255.0 blue:0x3f/255.0 alpha:1.0]

typedef void (^endRefreshBlock)();
@interface UIScrollView()
@property (nonatomic,strong) id target;
@property (nonatomic,assign) SEL action;
@end
@implementation UITableView(DragToLoadData)

- (void)addDragDown:(id)target withAction:(SEL)action{
    [self addDragDown:target withAction:action autoEnd:YES];
}
- (void)addDragDown:(id)target withAction:(SEL)action autoEnd:(BOOL)autoEndRefresh{
//    MJRefreshCustomHeader *header = [MJRefreshCustomHeader headerWithRefreshingBlock:^(){
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(){
        if (autoEndRefresh) {
            [self.mj_header endRefreshing];
        }
        if ([target respondsToSelector:action]) {
            [target performSelector:action];
        }
    }];
//    header.normalView.image = [UIImage imageNamed:@"img_ball_zq"];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.mj_header = header;
}
/**
 通过嵌套block调用停止下拉状态

 @param exeBlock 下拉事件
 */
-(void)addDragDown:(void (^)(endRefreshBlock)) Block {
    
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(){
        endRefreshBlock stopSefresh = ^(){
            [self.mj_header endRefreshing];
        };
        Block(stopSefresh);
    }];

}

-(void)resetNoMoreDataWithCurPage:(int)pageIndex pageCount:(int)pageCount{
    [self resetNoMoreDataWithCurPage:pageIndex pageCount:pageCount withNoDataTips:nil];
}
-(void)resetNoMoreDataWithCurPage:(int)pageIndex pageCount:(int)pageCount withNoDataTips:(NSString*)tips{
    NSString * noDataTips = nil;
    if (pageCount <= 1) {
        noDataTips = @"";
    }else if (tips) {
        noDataTips = tips;
    }  else{
        noDataTips = NOMOREDATA_TIPS;
    }
    if (pageIndex >= pageCount) {
        MJRefreshAutoGifFooter *footer = (MJRefreshAutoGifFooter *)self.mj_footer;
        [footer setTitle:noDataTips forState:MJRefreshStateNoMoreData];
        [self.mj_footer endRefreshingWithNoMoreData];
    }else if(pageIndex == 1){
        [self.mj_footer resetNoMoreData];
    }
}
- (void)addDragUp:(id)target withAction:(SEL)action{
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^(){
        [self.mj_footer endRefreshing];
        if ([target respondsToSelector:action]) {
            [target performSelector:action];
        }
        
    }];
    self.mj_footer = footer;
}
-(void)headerStartRefresh{
    [self.mj_header beginRefreshing];
}
-(void)footerEndRefreshing{
    [self.mj_footer endRefreshing];
    
}
-(void)headerEndRefreshing{
    [self.mj_header endRefreshing];
}
-(void)removeFooter{
    [self.mj_footer endRefreshingWithNoMoreData];
    
}
-(void)addFooterWithTarget:(id)target action:(SEL) action{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
    
}
- (void)deleteFooterLine{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self setTableFooterView:view];
}

- (void) tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount
{
    if (rowCount == 0) {
        // Display a message when the table is empty
        // 没有数据的时候，UILabel的显示样式
        UILabel *messageLabel = [UILabel new];
        
        messageLabel.text = message;
        messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        
        self.backgroundView = messageLabel;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}

- (void) tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount withStyle:(UITableViewCellSeparatorStyle) sepStyle;
{
    if (rowCount == 0) {
        // Display a message when the table is empty
        // 没有数据的时候，UILabel的显示样式
        UILabel *messageLabel = [UILabel new];
        
        messageLabel.text = message;
        messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        
        self.backgroundView = messageLabel;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.backgroundView = nil;
        self.separatorStyle = sepStyle;
    }
}

- (void) tableViewDisplayWithImageView:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount withStyle:(UITableViewCellSeparatorStyle) sepStyle;
{
    if (rowCount == 0) {
        // Display a message when the table is empty
        // 没有数据的时候，UILabel的显示样式
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
//        NSString *imgName=[[PropertyColorDao instance].TableNoDataStyle valueForKey:keyBackgroundImage];
        UIImage *img=[UIImage imageNamed:@"list_nothing.png"];
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width-img.size.width)/2, (self.bounds.size.width-img.size.width)/2-40, img.size.width, img.size.height)];
        imgView.image=img;
        [view addSubview:imgView];
        
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(0, imgView.frame.origin.y+imgView.frame.size.height+3, self.bounds.size.width, 21)];
        lab.textAlignment=NSTextAlignmentCenter;
        lab.font=[UIFont systemFontOfSize:14.0f];
        lab.textColor=[UIColor lightGrayColor];
        lab.text=message;
        [view addSubview:lab];
        
        self.backgroundView = view;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.backgroundView = nil;
        self.separatorStyle = sepStyle;
    }
}
- (void) tableViewDisplayWithImageView:(UIImage *)image msg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount withStyle:(UITableViewCellSeparatorStyle) sepStyle;
{
    if (rowCount == 0) {
        // Display a message when the table is empty
        // 没有数据的时候，UILabel的显示样式
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        //        NSString *imgName=[[PropertyColorDao instance].TableNoDataStyle valueForKey:keyBackgroundImage];
        UIImage *img=image;
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width-img.size.width)/2, (self.bounds.size.height-img.size.height)/2-70, img.size.width, img.size.height)];
        imgView.image=img;
        [view addSubview:imgView];
        
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(0, imgView.frame.origin.y+imgView.frame.size.height+3, self.bounds.size.width, 21)];
        lab.textAlignment=NSTextAlignmentCenter;
        lab.font=[UIFont systemFontOfSize:14.0f];
        lab.textColor=[UIColor lightGrayColor];
        lab.text=message;
        [view addSubview:lab];
        self.backgroundView = view;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.backgroundView = nil;
        self.separatorStyle = sepStyle;
    }
}

- (void) tableViewDisplayWithImageView:(NSString *) message  ifNecessaryForRowCount:(NSUInteger) rowCount withStyle:(UITableViewCellSeparatorStyle) sepStyle clickItem:(NSString *)title  target:(id)target selector:(SEL)action style:(NoData_BottomBtn_style)style{
    if (rowCount == 0) {
        // Display a message when the table is empty
        // 没有数据的时候，UILabel的显示样式
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        //        NSString *imgName=[[PropertyColorDao instance].TableNoDataStyle valueForKey:keyBackgroundImage];
        UIImage *img=[UIImage imageNamed:@"list_nothing.png"];
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width-img.size.width)/2, (self.bounds.size.width-img.size.width)/2-40, img.size.width, img.size.height)];
        imgView.image=img;
        [view addSubview:imgView];
        
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(0, imgView.frame.origin.y+imgView.frame.size.height+3, self.bounds.size.width, 21)];
        lab.textAlignment=NSTextAlignmentCenter;
        lab.font=[UIFont systemFontOfSize:14.0f];
        lab.textColor=[UIColor lightGrayColor];
        lab.text=message;
        [view addSubview:lab];
        if (title) {
            if (NoData_BottomBtn_style_corner == style) {
                UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake((self.bounds.size.width - 100)/2, lab.frame.origin.y+lab.frame.size.height+3,100, 40)];
                
                btn.layer.cornerRadius = btn.frame.size.height/2;
                btn.titleLabel.textAlignment=NSTextAlignmentCenter;
                btn.titleLabel.font=[UIFont systemFontOfSize:14.0f];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn setBackgroundColor:btn_color];
                [btn setTitle:title forState:UIControlStateNormal];
                [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:btn];
            }else {
                
                UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0, lab.frame.origin.y+lab.frame.size.height+3, self.bounds.size.width, 21)];
                btn.titleLabel.textAlignment=NSTextAlignmentCenter;
                btn.titleLabel.font=[UIFont systemFontOfSize:14.0f];
                [btn setTitle:title forState:UIControlStateNormal];
                [btn setTitleColor:btn_color forState:UIControlStateNormal];
                [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:btn];

            }
        }
        
        self.backgroundView = view;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.backgroundView = nil;
        self.separatorStyle = sepStyle;
    }
}
- (void) tableViewDisplayWithImageView:(NSString *) message  ifNecessaryForRowCount:(NSUInteger) rowCount withStyle:(UITableViewCellSeparatorStyle) sepStyle withBottomButton:(UIButton *)btn{
    if (rowCount == 0) {
        // Display a message when the table is empty
        // 没有数据的时候，UILabel的显示样式
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        //        NSString *imgName=[[PropertyColorDao instance].TableNoDataStyle valueForKey:keyBackgroundImage];
        UIImage *img=[UIImage imageNamed:@"list_nothing.png"];
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width-img.size.width)/2, (self.bounds.size.width-img.size.width)/2-40, img.size.width, img.size.height)];
        imgView.image=img;
        [view addSubview:imgView];
        
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(0, imgView.frame.origin.y+imgView.frame.size.height+3, self.bounds.size.width, 21)];
        lab.textAlignment=NSTextAlignmentCenter;
        lab.font=[UIFont systemFontOfSize:14.0f];
        lab.textColor=[UIColor lightGrayColor];
        lab.text=message;
        [view addSubview:lab];
        
        [btn setFrame:CGRectMake(0, (self.bounds.size.width - 100)/2,100, 50)];
        btn.layer.cornerRadius = btn.frame.size.height/2;
        btn.titleLabel.textAlignment=NSTextAlignmentCenter;
        btn.titleLabel.font=[UIFont systemFontOfSize:14.0f];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:btn_color];
        [view addSubview:btn];
        
    
        
        self.backgroundView = view;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.backgroundView = nil;
        self.separatorStyle = sepStyle;
    }
}



@end
