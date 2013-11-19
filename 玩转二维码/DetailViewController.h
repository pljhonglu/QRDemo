//
//  DetailViewController.h
//  玩转二维码
//
//  Created by pljhonglu on 13-11-13.
//  Copyright (c) 2013年 pljhonglu. All rights reserved.
//

#import "BaseViewController.h"
#import "DataModel.h"

@interface DetailViewController : BaseViewController<UIActionSheetDelegate>
@property (nonatomic,strong) NSString *string;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) DataModel *model;
@end
