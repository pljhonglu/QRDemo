//
//  BaseViewController.h
//  玩转二维码
//
//  Created by pljhonglu on 13-11-11.
//  Copyright (c) 2013年 pljhonglu. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define IOS7   ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
//
//#define TopOffset (IOS7? 20:0)


typedef enum{
    NavRight_MoreItem,
    NavRight_HistoryItem,
    NavRight_None
} NavType;

@interface BaseViewController : UIViewController

- (void)createNavWithTitle:(NSString *)title type:(NavType)type action:(SEL)selector;
- (void)createShareNavWithTitle:(NSString *)title action:(SEL)selector;
- (void)createResultNavWithTitle:(NSString *)title action:(SEL)selector;
- (void)createHistoryNavWithTitle:(NSString *)title;

@end
