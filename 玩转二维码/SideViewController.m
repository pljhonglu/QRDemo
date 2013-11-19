//
//  SideViewController.m
//  玩转二维码
//
//  Created by pljhonglu on 13-11-11.
//  Copyright (c) 2013年 pljhonglu. All rights reserved.
//

#import "SideViewController.h"
#import "MainViewController.h"
#import "HistoryViewController.h"
#import "ScanViewController.h"
#import "PPRevealSideViewController.h"

@interface SideViewController ()

@end

@implementation SideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"side_bg.png"]];
    
    NSArray *btn_nor = @[@"side_create_nor.png",@"side_history_nor.png",@"side_scanRQ_nor.png",@"side_scanHis_nor.png"];
    NSArray *btn_pre = @[@"side_create_pre.png",@"side_history_pre.png",@"side_scanRQ_pre.png",@"side_scanHis_pre.png"];
    //238 208
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(10, TopOffset+10, 300, 300)];
//    contentView.backgroundColor = [UIColor redColor];
    for (int i = 0; i<btn_nor.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((i%2)*110, (i/2)*100, 100, 90);
        [btn setImage:[UIImage imageNamed:btn_nor[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:btn_pre[i]] forState:UIControlStateHighlighted];
        btn.tag = i;
        [btn addTarget:self action:@selector(sideBtnOnclick:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btn];
    }
    [self.view addSubview:contentView];
}
- (void)sideBtnOnclick:(UIButton *)button{
    
    NSArray *className = @[@"MainViewController",@"HistoryViewController",@"ScanViewController",@"HistoryViewController"];
    Class class = NSClassFromString(className[button.tag]);
    if (class) {
        BaseViewController *VC = [[class alloc]init];
        if (button.tag == 1) {
            HistoryViewController *historyVC = (HistoryViewController *)VC;
            historyVC.type = CreHistory;
            historyVC.isMainView = YES;
        }else if (button.tag == 3){
            HistoryViewController *historyVC = (HistoryViewController *)VC;
            historyVC.type = ScanHistory;
            historyVC.isMainView = YES;
        }
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:VC];
        [self.revealSideViewController popViewControllerWithNewCenterController:nav animated:YES];
    }
}



@end
