//
//  CYBTableViewDemoViewController.m
//  CYBOCDemo
//
//  Created by admin on 2018/3/9.
//  Copyright © 2018年 zhiyun. All rights reserved.
//

#import "CYBTableViewDemoViewController.h"
#import "UITableView+Common.h"
#import "UITableView+DragToLoadData.h"
typedef enum{
    loadTypeSuccess = 0,
    loadTypeNoData = 1,
    loadTypeFail = 2
} loadType;

@interface CYBTableViewDemoViewController ()
@property (nonatomic,strong) NSMutableArray *data;
@property (assign) loadType loadType;
@end

@implementation CYBTableViewDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading thUITableViewCellStyleDefaulte view.
    __weak typeof(self)weekSelf = self;
    [self.tableView addRefresh:^{
        [weekSelf loadData:weekSelf.loadType];
    }];
    [self.tableView beginRefresh];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - loadData
-(void)loadData:(loadType)type{
    if (_data.count>0) {
        [_data removeAllObjects];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (loadTypeSuccess == type) {
            for (int index = 0 ; index < 3;  index++) {
                NSString *str = @"这是一条数据!";
                [_data addObject:str];
            }
        }else if(loadTypeFail == type){
            self.tableView.loadErrorType = TBLoadErrorTypeNetWork;
        }else if (loadTypeNoData == type){
            self.tableView.loadErrorType = TBLoadErrorTypeNoData;
            
        }
        [self.tableView endRefresh];
        [self.tableView reloadData];
    });
}
#pragma mark - tableview
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    cell.textLabel.text = [_data objectAtIndex: indexPath.row];
    return cell;
}
#pragma mark - lazy
-(NSMutableArray *)data{
    if (!_data) {
        _data = [[NSMutableArray alloc]init];
    }
    return _data;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - actions
- (IBAction)reloadData:(id)sender {
    self.loadType = loadTypeSuccess;
    [self.tableView beginRefresh];
}

- (IBAction)reloadNoData:(id)sender {
    self.loadType = loadTypeNoData;
    [self.tableView beginRefresh];
}

- (IBAction)reloadDataFail:(id)sender {
    self.loadType = loadTypeFail;
    [self.tableView beginRefresh];
}
@end
