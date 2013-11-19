//
//  ScanResultViewController.h
//  玩转二维码
//
//  Created by pljhonglu on 13-11-14.
//  Copyright (c) 2013年 pljhonglu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ScanResultViewController :BaseViewController<UITextViewDelegate>

@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSString *result;
@end
