//
//  HistoryViewController.h
//  玩转二维码
//
//  Created by pljhonglu on 13-11-15.
//  Copyright (c) 2013年 pljhonglu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef enum{
    CreHistory,
    ScanHistory
} typeOfView;

@interface HistoryViewController :BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic)BOOL isMainView;
@property (nonatomic)typeOfView type;
@end
