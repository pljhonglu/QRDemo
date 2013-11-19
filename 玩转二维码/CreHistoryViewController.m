//
//  CreHistoryViewController.m
//  玩转二维码
//
//  Created by pljhonglu on 13-11-11.
//  Copyright (c) 2013年 pljhonglu. All rights reserved.
//

#import "CreHistoryViewController.h"
#import "DataManager.h"
#import "CreHistoryCell.h"
#import "DetailViewController.h"


#define CellHeight 50.0f
@interface CreHistoryViewController ()

@end

@implementation CreHistoryViewController
{
    UITableView *_tableView;
    NSArray *_dataArray;
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
    
    [self createNavWithTitle:@"生成历史" type:NavRight_None action:nil];
    
    [self loadData];
    
    CGFloat top = 0;
    CGFloat height = self.view.frame.size.height - 20;
    if (IOS7) {
        top = -30;
        height = height - 44 - TopOffset + 80;
    }
//    CGFloat maxHeight = self.view.frame.size.height - 44 + TopOffset;
//    CGFloat height = (CellHeight*_dataArray.count) > maxHeight? maxHeight:CellHeight*_dataArray.count;
    _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, top, 320, height) style:UITableViewStyleGrouped];
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:_tableView.frame];
    [_tableView setBackgroundView:bgView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}

- (void)loadData{
    _dataArray = [[DataManager shareDataManager] resaultOfCreTable];
}

#pragma mark delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"identify";
    CreHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[CreHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    [cell bundingData:[_dataArray objectAtIndex:indexPath.row]];
//    cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    
    DetailViewController *vc = [[DetailViewController alloc]init];
    vc.model = [_dataArray objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}
@end
