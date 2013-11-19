//
//  InfoView.h
//  玩转二维码
//
//  Created by pljhonglu on 13-11-13.
//  Copyright (c) 2013年 pljhonglu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainFirstViewModel.h"

@interface InfoView : UIScrollView<UITextFieldDelegate>
- (void)bundingModel:(MainFirstViewModel *)model;

- (NSString *)getMeCardString;
- (void)setEnableEdit;
- (void)addButton;

@end
