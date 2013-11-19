//
//  StringRegex.m
//  玩转二维码
//
//  Created by pljhonglu on 13-11-15.
//  Copyright (c) 2013年 pljhonglu. All rights reserved.
//

#import "StringRegex.h"

@implementation StringRegex
+(BOOL)checkUrl:(NSString *)url
{
    //设置正则表达式
    NSString *urlRegex = @"[a-zA-z]+://.*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    //判断email内容是否符合正则要求
    return [urlTest evaluateWithObject:url];
}
+(NSString *)getInfo:(NSString *)key content:(NSString *)content{
    NSString *search = [NSString stringWithFormat:@"(?<=%@:)(.*?)(?=;)",key];
    NSRange range = [content rangeOfString:search options:NSRegularExpressionSearch];
    if (range.location == NSNotFound) {
        return nil;
    }
    NSString *str = [content substringWithRange:range];
    NSLog(@"%@",str);
    return str;
    
}
@end
