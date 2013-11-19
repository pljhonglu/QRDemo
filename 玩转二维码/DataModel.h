//
//  DataModel.h
//  玩转二维码
//
//  Created by pljhonglu on 13-11-14.
//  Copyright (c) 2013年 pljhonglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject
@property (nonatomic) NSInteger key;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) UIImage *image;
//@property (nonatomic,strong) NSString *imagePath;
@property (nonatomic,strong) NSDate *date;
@end
