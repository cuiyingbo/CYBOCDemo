//
//  UITableView+DragToLoadData.h
//  Football
//
//  Created by weichen on 15/11/17.
//  Copyright © 2015年 bet007. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJRefresh.h"

#define TABLE_TIPS @"暂无相关数据"
#define NOMOREDATA_TIPS @"数据已加载完毕"
typedef enum{
    NoData_BottomBtn_style_nomal = 1,
    NoData_BottomBtn_style_corner = 2
}NoData_BottomBtn_style;

@interface UITableView(DragToLoadData)

/**添加下拉刷新
 */
- (void)addDragDown:(id)target withAction:(SEL) action;

-(void)headerStartRefresh;
/**添加下拉刷新
 */
- (void)addDragDown:(id)target withAction:(SEL)action autoEnd:(BOOL)autoEndRefresh;
/**添加上拉刷新
 */
- (void)addDragUp:(id)target withAction:(SEL)action;

/**溢出加载更多上啦
 */
//-(void) footerEndWithPageIndex:(int)curPage pageCount:(int)pageCount;
/**清除多余的分隔线
 */
- (void)deleteFooterLine;

-(void)footerEndRefreshing;
-(void)headerEndRefreshing;
-(void)removeFooter;
-(void)addFooterWithTarget:(id)target action:(SEL) action;
/*
 *根据页数，决定是否加载完毕
 */
-(void)resetNoMoreDataWithCurPage:(int)pageIndex pageCount:(int)pageCount;
/**没有数据时，提示
 */
-(void)resetNoMoreDataWithCurPage:(int)pageIndex pageCount:(int)pageCount withNoDataTips:(NSString*)tips;
/**没有数据时，提示
 */

- (void) tableViewDisplayWithImageView:(UIImage *)image msg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount withStyle:(UITableViewCellSeparatorStyle) sepStyle;
- (void) tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount;
/**增加了sepStyle当有数据的时候使用这种分隔
 */
- (void) tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount withStyle:(UITableViewCellSeparatorStyle) sepStyle;

- (void) tableViewDisplayWithImageView:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount withStyle:(UITableViewCellSeparatorStyle) sepStyle;

- (void) tableViewDisplayWithImageView:(NSString *) message  ifNecessaryForRowCount:(NSUInteger) rowCount withStyle:(UITableViewCellSeparatorStyle) sepStyle clickItem:(NSString *)title  target:(id)target selector:(SEL)action style:(NoData_BottomBtn_style)style;
@end
