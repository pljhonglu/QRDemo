//
//  MainViewController.m
//  玩转二维码
//
//  Created by pljhonglu on 13-11-11.
//  Copyright (c) 2013年 pljhonglu. All rights reserved.
//

#import "MainViewController.h"
#import "MainFirstViewModel.h"
#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "InfoView.h"
#import "StringRegex.h"

#define PlaceHold @"点击输入框，编辑文本内容"
@interface MainViewController ()

@end

@implementation MainViewController
{
    UIView *_toolView;
    InfoView *_scrollView;
    UIView *_contentView;

    // page 2
    __weak UIResponder *_textView;
    UILabel *_textViewPlaceHolder;
    UITextView *_page2View;
    
    // page3
    UITextField *_page3View;
    
    
    // page 4
    ABPeoplePickerNavigationController *picker;
    
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
    [self createNavWithTitle:@"二维码生成" type:NavRight_MoreItem action:@selector(moreBtnClick)];
    
//    CGRect frame = self.view.frame;
//    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, frame.size.height)];
//    [self.view addSubview:_contentView];
    
    _contentView = [self createFirstViewWithModel:nil];
    [self.view addSubview:_contentView];
}

- (UIView *)createSecondView{
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, frame.size.height)];
    
    UIControl *control = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, 320, frame.size.height)];
    [control addTarget:self action:@selector(cancelKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    
    _page2View = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, 300, 120)];
    _page2View.delegate = self;
    [control addSubview:_page2View];
    _textView = _page2View;
    
    //其次在UITextView上面覆盖个UILable,UILable设置为全局变量。
    _textViewPlaceHolder = [[UILabel alloc]init];
    _textViewPlaceHolder.font = [UIFont systemFontOfSize:13];
    _textViewPlaceHolder.frame =CGRectMake(15, 15, 200, 20);
    _textViewPlaceHolder.text = PlaceHold;
    _textViewPlaceHolder.enabled = NO;//lable必须设置为不可用
    _textViewPlaceHolder.backgroundColor = [UIColor clearColor];
    [control addSubview:_textViewPlaceHolder];

    //169 76
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(118, 140, 84, 38)];
    [button setImage:[UIImage imageNamed:@"main_text_btn_nor.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"main_text_btn_pre.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(secondBtnClick) forControlEvents:UIControlEventTouchUpInside];

    [control addSubview:button];
    
    [contentView addSubview:control];
    
    return contentView;
}
-(UIView *)createThirdView{
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, frame.size.height)];
    
    UIControl *controlView = [[UIControl alloc]initWithFrame:contentView.frame];
    [controlView addTarget:self action:@selector(cancelKeyBoard) forControlEvents:UIControlEventTouchUpInside];

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 300, 40)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_web_text.png"]];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 40)];
    title.backgroundColor = [UIColor clearColor];
    title.text = @"网址";
    title.font = [UIFont systemFontOfSize:23];
    
    _page3View = [[UITextField alloc]initWithFrame:CGRectMake(65, 0, 235, 40)];
    _page3View.placeholder = @"例如:www.1000phone.com";
    _page3View.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _page3View.delegate = self;
    _textView = _page3View;
    
    [view addSubview:title];
    [view addSubview:_page3View];
    
    [controlView addSubview:view];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(118, 100, 84, 38)];
    [button setImage:[UIImage imageNamed:@"main_text_btn_nor.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"main_text_btn_pre.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(thirdBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [controlView addSubview:button];

    
    [contentView addSubview:controlView];
    return contentView;
}

- (UIView *)createForthView{
    if(!picker){
    
        picker = [[ABPeoplePickerNavigationController alloc] init];
        
        picker.peoplePickerDelegate = self;
    }
    
    [self presentViewController:picker animated:YES completion:Nil];
    return Nil;
}

-(UIView *)createFirstViewWithModel:(MainFirstViewModel *)model{
    CGRect frame = [UIScreen mainScreen].bounds;
//    NSLog(@"frame = %@",NSStringFromCGRect(frame));

    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, frame.size.height)];
    
    _scrollView = [[InfoView alloc]initWithFrame:CGRectMake(0, 0, 320, 370)];
    if (model != nil) {
        [((InfoView *)_scrollView) bundingModel:model];
    }
    [contentView addSubview:_scrollView];

    //键盘弹起通知,订阅系统键盘升起时的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //键盘收起通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

//    NSLog(@"%d",TopOffset);
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-94-20, 320, 50)];
    bottomView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bottom_bar.png"]];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width/2-75, 5, 150, 45)];
    [button setImage:[UIImage imageNamed:@"main_btn_nor.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"main_btn_pre.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(firstBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:button];
    [contentView addSubview:bottomView];
    return contentView;
}


-(void)moreBtnClick{
    static BOOL isSelected = NO;
    if (!isSelected) {
        //初始化隐藏的工具条
        NSArray *toolBtn_nor = @[@"more_mp_nor.png",@"more_text_nor.png",@"more_web_nor.png",@"more_con_nor.png"];
        NSArray *toolBtn_pre = @[@"more_mp_pre.png",@"more_text_pre.png",@"more_web_pre.png",@"more_con_pre.png"];
        
        _toolView = [[UIView alloc]initWithFrame:CGRectMake(20, -40, 280, 44)];
        _toolView.backgroundColor = [UIColor grayColor];
        for ( int i = 0; i<toolBtn_nor.count; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(70*i, 0, 70, 44)];
            [btn setImage:[UIImage imageNamed:toolBtn_nor[i]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:toolBtn_pre[i]] forState:UIControlStateHighlighted];
            btn.tag = i;
            [btn addTarget:self action:@selector(ToolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_toolView addSubview:btn];
        }
        
        [self.view addSubview:_toolView];
        [self.view bringSubviewToFront:_toolView];

        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = _toolView.frame;
            _toolView.frame = CGRectMake(frame.origin.x, 0, frame.size.width, frame.size.height);
        }];
    }else{
        [self.view bringSubviewToFront:_toolView];
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = _toolView.frame;
            _toolView.frame = CGRectMake(frame.origin.x,-frame.size.height, frame.size.width, frame.size.height);
            
        } completion:^(BOOL finished) {
            if (finished) {
                [_toolView removeFromSuperview];
            }
        }];
    }
    isSelected = !isSelected;
}

#pragma mark action
- (void)ToolBtnClick:(UIButton *)button{
    [_contentView removeFromSuperview];
    _contentView  = nil;
    if (button.tag == 0) {
        _contentView = [self createFirstViewWithModel:nil];
    }else if (button.tag == 1){
        _contentView = [self createSecondView];
    }else if (button.tag == 2){
        _contentView = [self createThirdView];
    }else if (button.tag == 3){
        _contentView = [self createForthView];
    }
    [self.view addSubview:_contentView];
    
    [self moreBtnClick];
}
- (void)keyboardWillShow:(NSNotification *)notifycation
{
    NSDictionary *userInfo = notifycation.userInfo;
    NSValue *keyBoardRectValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyBoardRect = [keyBoardRectValue CGRectValue];
    
    CGRect contentRect = _scrollView.frame;
    contentRect.origin.y += (64);
    
    CGRect rect = CGRectIntersection(keyBoardRect, contentRect);
    contentRect.size.height -= rect.size.height;
    
    contentRect.origin.y -= (64);
    
    [UIView animateWithDuration:0.25 animations:^{
        _scrollView.frame = contentRect;
    }completion:^(BOOL finished) {
    }];
}
- (void)keyboardWillHide:(NSNotification *)notifycation
{
    CGRect rect = _scrollView.frame;
//    NSLog(@"%@",NSStringFromCGRect(rect));
    //    rect.size.height += (216-44-20);
    [UIView animateWithDuration:0.25 animations:^{
        _scrollView.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 370);
    }];
}
- (void)cancelKeyBoard{
    [_textView resignFirstResponder];
}
- (void)firstBtnClick{
    NSString *string = [_scrollView getMeCardString];
    if (string == nil) {
        return;
    }
    [self createQR:string type:@"名片"];
}
- (void)secondBtnClick{
    if (_page2View.text == nil || _page2View.text.length == 0) {
        [self showAlert:@"内容不能为空"];
        return;
    }
    [self createQR:_page2View.text type:@"文本"];
}
- (void)thirdBtnClick{
    NSString *str =  _page3View.text;
    if ([StringRegex checkUrl:str]) {
        [self createQR:str type:@"网址"];
    }else{
        NSString *url = [NSString stringWithFormat:@"http://%@",str];
        [self createQR:url type:@"网址"];
//        [self showAlert:@"请填写正确的网址"];
    }
}

- (void)createQR:(NSString *)string type:(NSString *)type{
    [_textView resignFirstResponder];//取消第一响应，关键盘
    DetailViewController *vc = [[DetailViewController alloc]init];
    vc.string = string;
    vc.type = type;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)showAlert:(NSString *)title{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];//取消第一响应，关键盘
    return YES;
}


-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        _textViewPlaceHolder.text = PlaceHold;
    }else{
        _textViewPlaceHolder.text = @"";
    }
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    
    MainFirstViewModel *model = [[MainFirstViewModel alloc]init];
    NSString *name = [self getName:person];
    model.name = name;
//    NSLog(@"通讯录选中一个联系人：%@",name);

    NSString *phone = [self getPhone:person];
    model.phone = phone;
//    NSLog(@"电话：%@",phone);

    NSString *email = [self getEmail:person];
    model.email = email;
//    NSLog(@"email : %@",email);
    
    NSString *company = [self getCompany:person];
    model.company = company;
//    NSLog(@"company: %@",company);
    
    NSString *job = [self getJob:person];
    model.job = job;
//    NSLog(@"job : %@",job);
    
    NSString *webSite = [self getWebSite:person];
    model.webSite = webSite;
//    NSLog(@"web site: %@",webSite);
    
    NSString *address = [self getAddress:person];
    model.address = address;
//    NSLog(@"address : %@",address);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [_contentView removeFromSuperview];
    _contentView  = nil;
    _contentView = [self createFirstViewWithModel:model];
    [self.view addSubview:_contentView];
    
    return NO;
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
//    NSLog(@"2222222");
    return YES;
}


#pragma mark record helper
/*
 *  返回指定联系人的名字
 */
- (NSString *)getName:(ABRecordRef)person{
    return  (__bridge NSString*)ABRecordCopyCompositeName(person);

}

/**
 *  获取某联系人的电话
 *  如果没有则返回 nil
 */
- (NSString *)getPhone:(ABRecordRef)person{
    //读取电话多值
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);

    if (phones){ //如果数据存在
        int count = ABMultiValueGetCount(phones); //返回电话总数
        for (CFIndex i = 0; i < count; i++) {
            NSString *phoneLabel       = (__bridge NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
            //转化为多个电话数据为字符串
            if ([phoneLabel isEqualToString:@"_$!<Mobile>!$_"]) {
                NSString *phoneNumber      = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phones, i);
                CFRelease(phones);
                return phoneNumber;
            }
        }
    }
    //释放内存，返回数据
    CFRelease(phones);
    return nil;
}
/*
 *  获取指定联系人的 email
 *  如果没有则返回 nil
 */
- (NSString *)getEmail:(ABRecordRef)person
{
    //读取邮箱多值
    ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
    NSString *value = nil;
    if (emails){ //如果有邮箱数据
        value = (__bridge NSString *)ABMultiValueCopyValueAtIndex(emails, 0);
    }
    //释放内存，返回数据
    CFRelease(emails);
    return value;
}

// 获取公司
- (NSString *)getCompany:(ABRecordRef)person{
    CFStringRef phones = ABRecordCopyValue(person, kABPersonOrganizationProperty);
    return (__bridge NSString *)phones;
}
// 获取职务
- (NSString *)getJob:(ABRecordRef)person{
    CFStringRef job = ABRecordCopyValue(person, kABPersonJobTitleProperty);

    return (__bridge NSString *)job;
}

// 获取网址
- (NSString *)getWebSite:(ABRecordRef)person{
    ABMultiValueRef websites = ABRecordCopyValue(person, kABPersonURLProperty);
    NSString *website = nil;
    if (websites){ //如果有邮箱数据
        website = (__bridge NSString *)ABMultiValueCopyValueAtIndex(websites, 0);
    }
    return website;
}
// 获取地址
- (NSString *)getAddress:(ABRecordRef)person{
    //读取地址多值
    ABMultiValueRef address = ABRecordCopyValue(person, kABPersonAddressProperty);
    NSMutableString *string = [[NSMutableString alloc]initWithCapacity:50];
    
    NSDictionary* personaddress =(__bridge NSDictionary*) ABMultiValueCopyValueAtIndex(address, 0);
    
    NSString* country = [personaddress valueForKey:(NSString *)kABPersonAddressCountryKey];
    if(country != nil)
        [string appendString:country];
    
    NSString* city = [personaddress valueForKey:(NSString *)kABPersonAddressCityKey];
    if(city != nil)
        [string appendString:city];
    
    NSString* state = [personaddress valueForKey:(NSString *)kABPersonAddressStateKey];
    if(state != nil)
        [string appendString:state];
    
    NSString* street = [personaddress valueForKey:(NSString *)kABPersonAddressStreetKey];
    if(street != nil)
        [string appendString:street];
    
    NSString* zip = [personaddress valueForKey:(NSString *)kABPersonAddressZIPKey];
    if(zip != nil)
        [string appendString:zip];
    
    NSString* coutntrycode = [personaddress valueForKey:(NSString *)kABPersonAddressCountryCodeKey];
    if(coutntrycode != nil)
        [string appendString:coutntrycode];
    
    if (string.length == 0) {
        return nil;
    }
    return string;
}
@end
