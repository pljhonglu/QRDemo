//
//  InfoView.m
//  玩转二维码
//
//  Created by pljhonglu on 13-11-13.
//  Copyright (c) 2013年 pljhonglu. All rights reserved.
//

#import "InfoView.h"
#import "StringRegex.h"

@implementation InfoView
{
    NSMutableArray *_textFields;
    BOOL _isEdit;//是否可编辑
}


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _isEdit = YES;
        
//        CGRect frame = [UIScreen mainScreen].bounds;
        NSLog(@"frame = %@",NSStringFromCGRect(frame));
        _textFields = [[NSMutableArray alloc]initWithCapacity:8];
        
        
//        self.frame = frame;
        self.contentSize = frame.size;
        
        UIView *content = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 370)];
        content.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_text_bg.png"]];
        
        NSArray *name = @[@"姓名:",@"电话:",@"公司:",@"职务:",@"邮箱:",@"网址:",@"地址:",@"备注:"];
        NSArray *placeHold = @[@"",@"",@"",@"",@"",@"",@"",@""];
        for (int i = 0; i<8; i++) {
            
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 10 + (i*44), 50, 40)];
            lable.backgroundColor = [UIColor clearColor];
            lable.text = name[i];
            lable.font = [UIFont boldSystemFontOfSize:17];
            
            UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(70, 10 + (i*44), 225, 40)];
            textfield.borderStyle = UITextBorderStyleNone;
            textfield.placeholder = placeHold[i];
            textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textfield.delegate = self;
            
            [_textFields addObject:textfield];
            [content addSubview:lable];
            [content addSubview:textfield];
        }
        [self addSubview:content];
    }
    return self;
}

- (void)bundingModel:(MainFirstViewModel *)model{

    UITextField *textField = [_textFields objectAtIndex:0];
    textField.text = model.name;
    textField = [_textFields objectAtIndex:1];
    textField.text = model.phone;
    textField = [_textFields objectAtIndex:2];
    textField.text = model.company;
    textField = [_textFields objectAtIndex:3];
    textField.text = model.job;
    textField = [_textFields objectAtIndex:4];
    textField.text = model.email;
    textField = [_textFields objectAtIndex:5];
    textField.text = model.webSite;
    textField = [_textFields objectAtIndex:6];
    textField.text = model.address;
    textField = [_textFields objectAtIndex:7];
    textField.text = model.remark;
}
- (void)setEnableEdit{
    _isEdit = NO;
}
-(void)addButton{
    UITextField *text = [_textFields objectAtIndex:1];
    CGRect rect = text.frame;
    rect.origin.x += 210;
    rect.size.width = 30;
//    NSLog(@"%@",NSStringFromCGRect(rect));
    UIButton *phone = [[UIButton alloc]initWithFrame:rect];
    [phone setImage:[UIImage imageNamed:@"scanres_phone_nor.png"] forState:UIControlStateNormal];
    [phone setImage:[UIImage imageNamed:@"scanres_phone_pre.png"] forState:UIControlStateHighlighted];
    [phone addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:phone];
    
    text = [_textFields objectAtIndex:5];
    CGRect rect2 = text.frame;
    rect2.origin.x += 210;
    rect2.size.width = 30;
//    NSLog(@"%@",NSStringFromCGRect(rect2));

    UIButton *url = [[UIButton alloc]initWithFrame:rect2];
    [url setImage:[UIImage imageNamed:@"scanres_url_nor.png"] forState:UIControlStateNormal];
    [url setImage:[UIImage imageNamed:@"scanres_url_pre.png"] forState:UIControlStateHighlighted];
    [url addTarget:self action:@selector(gotoUrl) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:url];
}



- (NSString *)getMeCardString{
    NSMutableString *string = [[NSMutableString alloc]initWithCapacity:200];
    [string appendString:@"MECARD:"];
    UITextField *textField = [_textFields objectAtIndex:0];
    if (textField.text == nil || textField.text.length == 0) {
        [self showAlert:@"姓名不能为空"];
        return nil;
    }
    [string appendFormat:@"N:%@;",textField.text];
    
    textField = [_textFields objectAtIndex:1];
    if (textField.text == nil || textField.text.length == 0) {
        [self showAlert:@"电话不能为空"];
        return nil;
    }
    [string appendFormat:@"TEL:%@;",textField.text];
    
    NSString *str;

    textField = [_textFields objectAtIndex:2];
    str = textField.text;
    if (str == nil || str.length == 0) {
        str = @"";
    }
    [string appendFormat:@"ORG:%@;",str];
    
    textField = [_textFields objectAtIndex:3];
    str = textField.text;
    if (str == nil || str.length == 0) {
        str = @"";
    }
    [string appendFormat:@"JOB:%@;",str];
    
    textField = [_textFields objectAtIndex:4];
    str = textField.text;
    if (str == nil || str.length == 0) {
        str = @"";
    }
    [string appendFormat:@"EMAIL:%@;",str];
    
    textField = [_textFields objectAtIndex:5];
    str = textField.text;
    if (str == nil || str.length == 0) {
        str = @"";
    }
    [string appendFormat:@"URL:%@;",str];
    
    textField = [_textFields objectAtIndex:6];
    str = textField.text;
    if (str == nil || str.length == 0) {
        str = @"";
    }
    [string appendFormat:@"ADR:%@;",str];
    
    textField = [_textFields objectAtIndex:7];
    str = textField.text;
    if (str == nil || str.length == 0) {
        str = @"";
    }
    [string appendFormat:@"NOTE:%@;",str];
    return string;
}
#pragma mark action
- (void)callPhone{
    UITextField *text = [_textFields objectAtIndex:1];
    
    if (text.text.length != 0) {
        NSString *tel = [NSString stringWithFormat:@"tel://%@",text.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];

    }
}

- (void)gotoUrl{
    UITextField *text = [_textFields objectAtIndex:5];
    NSString *url = [NSString stringWithFormat:@"http://%@",text.text];
    if (text.text.length != 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}
#pragma mark delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];//取消第一响应，关键盘
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return _isEdit;
}


- (void)showAlert:(NSString *)title{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

@end
