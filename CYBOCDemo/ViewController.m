//
//  ViewController.m
//  CYBOCDemo
//
//  Created by admin on 2018/2/26.
//  Copyright © 2018年 zhiyun. All rights reserved.
//

#import "ViewController.h"
#import "ZYDLoadView.h"
#import "ZYDRotationView.h"
#import "CYBTableViewDemoViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ZYDRotationView * rotationView =[[ZYDRotationView alloc]init];
    rotationView.image = [UIImage imageNamed:@"img_header"];
    rotationView.frame = CGRectMake(0, 0, 40, 40);
    [self.view addSubview:rotationView];
    ZYDRotationView * rotationView2 = [[ZYDRotationView alloc]initWithImage:[UIImage imageNamed:@"img_header"]];
    rotationView2.frame = CGRectMake(50, 0, 100, 50);
    [self.view addSubview:rotationView2];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)showloading:(id)sender {
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_header"]];
    [[ZYDLoadView shareInstance] starLoad];
}

- (IBAction)tableViewDemo:(id)sender {
    CYBTableViewDemoViewController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"CYBTableViewDemoViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
