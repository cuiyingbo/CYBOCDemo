//
//  CYBTableViewDemoViewController.h
//  CYBOCDemo
//
//  Created by admin on 2018/3/9.
//  Copyright © 2018年 zhiyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYBTableViewDemoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)reloadData:(id)sender;
- (IBAction)reloadNoData:(id)sender;
- (IBAction)reloadDataFail:(id)sender;

@end
