//
//  StringRegex.h
//  玩转二维码
//
//  Created by pljhonglu on 13-11-15.
//  Copyright (c) 2013年 pljhonglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringRegex : NSObject

+(BOOL)checkUrl:(NSString *)url;

+(NSString *)getInfo:(NSString *)key content:(NSString *)content;
@end
