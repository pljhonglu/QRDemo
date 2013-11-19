//
//  BaseViewController.m
//  玩转二维码
//
//  Created by pljhonglu on 13-11-11.
//  Copyright (c) 2013年 pljhonglu. All rights reserved.
//

#import "BaseViewController.h"
#import "PPRevealSideViewController.h"
#import "SideViewController.h"


@interface BaseViewController ()

@end

@implementation BaseViewController
{
    UILabel *_titltLable;
}

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
    //解决 PPRevealSideViewController 导致状态栏变黑
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //iOS7 NavigationBar覆盖内容
    if (IOS7) {
        self.navigationController.navigationBar.translucent = NO;
        self.tabBarController.tabBar.translucent = NO;
    }
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];

    _titltLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    _titltLable.text = @"生成二维码";
    _titltLable.backgroundColor = [UIColor clearColor];
    _titltLable.textAlignment = NSTextAlignmentCenter;
    _titltLable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = _titltLable;
    
    
}
-(void)createHistoryNavWithTitle:(NSString *)title{
    _titltLable.text = title;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 44);
    [leftBtn setImage:[UIImage imageNamed:@"detail_left_nor.png"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"detail_left_pre.png"] forState:UIControlStateHighlighted];
    [leftBtn setImage:[UIImage imageNamed:@"detail_left_pre.png"] forState:UIControlStateSelected];
    [leftBtn addTarget:self action:@selector(returnByDisMiss) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)createNavWithTitle:(NSString *)title type:(NavType)type action:(SEL)selector{
    _titltLable.text = title;

    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 44);
    [leftBtn setImage:[UIImage imageNamed:@"main_top_left_nor.png"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"main_top_left_highlighted.png"] forState:UIControlStateHighlighted];
    [leftBtn setImage:[UIImage imageNamed:@"main_top_left_highlighted.png"] forState:UIControlStateSelected];
    [leftBtn addTarget:self action:@selector(sideBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;

    if (type == NavRight_MoreItem) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(0, 0, 40, 44);
        [rightBtn setImage:[UIImage imageNamed:@"main_top_more_nor.png"] forState:UIControlStateNormal];
        [rightBtn setImage:[UIImage imageNamed:@"main_top_more_highted.png"] forState:UIControlStateHighlighted];
        [rightBtn setImage:[UIImage imageNamed:@"main_top_more_highted.png"] forState:UIControlStateSelected];
        [rightBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = rightItem;
    }else if (type == NavRight_HistoryItem){
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(0, 0, 40, 44);
        [rightBtn setImage:[UIImage imageNamed:@"scan_topright_nor.png"] forState:UIControlStateNormal];
        [rightBtn setImage:[UIImage imageNamed:@"scan_topright_pre.png"] forState:UIControlStateHighlighted];
        [rightBtn setImage:[UIImage imageNamed:@"scan_topright_pre.png"] forState:UIControlStateSelected];
        [rightBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = rightItem;
    }else if (type == NavRight_None){
        
    }
}

- (void)createShareNavWithTitle:(NSString *)title action:(SEL)selector{
    _titltLable.text = title;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 44);
    [leftBtn setImage:[UIImage imageNamed:@"detail_left_nor.png"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"detail_left_pre.png"] forState:UIControlStateHighlighted];
    [leftBtn setImage:[UIImage imageNamed:@"detail_left_pre.png"] forState:UIControlStateSelected];
    [leftBtn addTarget:self action:@selector(retureButnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;

    
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(0, 0, 40, 44);
//    [rightBtn setImage:[UIImage imageNamed:@"detail_right_nor.png"] forState:UIControlStateNormal];
//    [rightBtn setImage:[UIImage imageNamed:@"detail_right_pre.png"] forState:UIControlStateHighlighted];
//    [rightBtn setImage:[UIImage imageNamed:@"detail_right_pre.png"] forState:UIControlStateSelected];
//    [rightBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;

}
- (void)createResultNavWithTitle:(NSString *)title action:(SEL)selector{
    _titltLable.text = title;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 44);
    [leftBtn setImage:[UIImage imageNamed:@"detail_left_nor.png"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"detail_left_pre.png"] forState:UIControlStateHighlighted];
    [leftBtn setImage:[UIImage imageNamed:@"detail_left_pre.png"] forState:UIControlStateSelected];
    [leftBtn addTarget:self action:@selector(retureButnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 44);
    [rightBtn setImage:[UIImage imageNamed:@"scan_topright_nor.png"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"scan_topright_pre.png"] forState:UIControlStateHighlighted];
    [rightBtn setImage:[UIImage imageNamed:@"scan_topright_pre.png"] forState:UIControlStateSelected];
    [rightBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
- (void)returnByDisMiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)retureButnClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)sideBtnClick{
    SideViewController *sideVC = [[SideViewController alloc]init];
    [self.revealSideViewController pushViewController:sideVC onDirection:PPRevealSideDirectionLeft withOffset:90.0f animated:YES];
}

@end