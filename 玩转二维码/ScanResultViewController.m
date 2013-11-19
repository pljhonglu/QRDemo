//
//  ScanResultViewController.m
//  玩转二维码
//
//  Created by pljhonglu on 13-11-14.
//  Copyright (c) 2013年 pljhonglu. All rights reserved.
//

#import "ScanResultViewController.h"
#import "StringRegex.h"
#import "MainFirstViewModel.h"
#import "InfoView.h"
#import "DataModel.h"
#import "DataManager.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "HistoryViewController.h"

@interface ScanResultViewController ()

@end

typedef enum{
    MeCard = 0,
    Url,
    Text
} ResultType;
@implementation ScanResultViewController
{
    UIView *_textView;
    UIView *_urlView;
    UIView *_cardView;
    
    MainFirstViewModel *_contactmodel;
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
    
    [self createResultNavWithTitle:@"扫描结果" action:@selector(historyBtnClicked)];
    
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    lable.backgroundColor = [UIColor whiteColor];
    lable.textAlignment = NSTextAlignmentCenter;
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd hh:mm";
    NSString *dateStr = [formatter stringFromDate:date];
    lable.text = [NSString stringWithFormat:@"保存于: %@",dateStr];
    lable.textColor = [UIColor blackColor];
    [self.view addSubview:lable];
    
    ResType type = [self getTypeOfResult:_result];
    if (type == MeCard) {
        [self createCardViewWithContent:_result];
    }else if (type == Url){
        UIView *view = [self createUrlViewWithContent:_result];
        view.frame = CGRectMake(10, 55, view.frame.size.width, view.frame.size.height);
        [self.view addSubview:view];
    }else if (type == Text){
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 55, 300, 150)];
        textView.text = _result;
        textView.delegate = self;
        [self.view addSubview:textView];
    }
    
    //保存到数据库
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DataModel *model = [[DataModel alloc]init];
        model.content = _result;
        model.image = _image;
        model.date = [NSDate date];
        if (type == MeCard) {
            model.type = @"名片";
        }else if (type == Url){
            model.type = @"网址";
        }else if (type == Text){
            model.type = @"文本";
        }
        [[DataManager shareDataManager] addDataToScanTable:model];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy-MM-dd hh:mm";
            NSString *dateStr = [formatter stringFromDate:date];
            lable.text = [NSString stringWithFormat:@"保存于: %@",dateStr];
        });
    });
}


- (void)createCardViewWithContent:(NSString *)content{
    content = [content substringFromIndex:7];
    NSLog(@"%@",content);
    
    _contactmodel = [[MainFirstViewModel alloc]init];
    _contactmodel.name = [StringRegex getInfo:@"N" content:_result];
    _contactmodel.phone = [StringRegex getInfo:@"TEL" content:_result];
    _contactmodel.company = [StringRegex getInfo:@"ORG" content:_result];
    _contactmodel.job = [StringRegex getInfo:@"JOB" content:_result];
    _contactmodel.email = [StringRegex getInfo:@"EMAIL" content:_result];
    _contactmodel.webSite = [StringRegex getInfo:@"URL" content:_result];
    _contactmodel.address = [StringRegex getInfo:@"ADR" content:_result];
    _contactmodel.remark = [StringRegex getInfo:@"NOTE" content:_result];
    
    
    InfoView *view = [[InfoView alloc]initWithFrame:CGRectMake(0, 45, 320, 370)];
    [view bundingModel:_contactmodel];
    [view setEnableEdit];
    [view addButton];
    _cardView = view;
    [self.view addSubview:view];
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-150, 410, 300, 45)];
    [button setImage:[UIImage imageNamed:@"scan_save_nor.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"scan_save_pre.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(addToContact) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (UIView *)createUrlViewWithContent:(NSString *)str{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 45)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_web_text.png"]];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 45)];
    title.backgroundColor = [UIColor clearColor];
    title.text = @"网址";
    title.font = [UIFont systemFontOfSize:23];
    [view addSubview:title];

    UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(65, 0, 210, 45)];
    content.text = str;
    content.textAlignment = NSTextAlignmentLeft;
    content.backgroundColor = [UIColor clearColor];
    content.textColor = [UIColor blackColor];
    [view addSubview:content];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(270, 0, 30, 45)];
    [button setImage:[UIImage imageNamed:@"scanres_url_nor.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"scanres_url_pre.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(goToUrl) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:button];

    return view;

}
- (ResType)getTypeOfResult:(NSString *)result{
    if (result.length <= 7) {
        return Text;
    }
    NSString *subStr = [result substringToIndex:7];
    NSLog(@"%@",subStr);
    if ([subStr compare:@"MECARD:" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        return MeCard;
    }
    if ([StringRegex checkUrl:result]) {
        return Url;
    }
    return Text;
}
#pragma mark action
-(void)historyBtnClicked{
    HistoryViewController *vc = [[HistoryViewController alloc]init];
    vc.type = ScanHistory;
    vc.isMainView = NO;
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
//    [self.navigationController pushViewController:vc animated:YES];
}
- (void)goToUrl{
//    NSString *url = [NSString stringWithFormat:@"http://%@",_result];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_result]];
}
- (void)addToContact
{
    printf("--------addToContact----Execute!!!------\n");
    ABAddressBookRef iPhoneAddressBook = ABAddressBookCreate();
    ABRecordRef newPerson = ABPersonCreate();
    CFErrorRef error = NULL;
    //name
//    ABRecordSetValue(newPerson, kABPersonFirstNameProperty, @"John", &error);
    ABRecordSetValue(newPerson, kABPersonLastNameProperty, (__bridge CFTypeRef)(_contactmodel.name), &error);
    //phone number
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(_contactmodel.phone), kABPersonPhoneMainLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone,&error);
/*
    // org 保存不进去
    ABRecordSetValue(newPerson, kABPersonOrganizationProperty, (__bridge CFTypeRef)(_contactmodel.company), &error);
    // job 保存不进去
    ABRecordSetValue(newPerson, kABPersonJobTitleProperty, (__bridge CFTypeRef)(_contactmodel.job), &error);
    
    //email 保存不进去
    ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFTypeRef)(_contactmodel.email), kABWorkLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonEmailProperty, multiEmail, &error);
    CFRelease(multiEmail);

    //website 崩
    ABRecordSetValue(newPerson, kABPersonURLProperty, (__bridge CFTypeRef)(_contactmodel.webSite), &error);

    //remark
    
    //address 保存不进去
    ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
    [addressDictionary setObject:_contactmodel.address forKey:(NSString *) kABPersonAddressStreetKey];
    [addressDictionary setObject:@"Chicago" forKey:(NSString *)kABPersonAddressCityKey];
    [addressDictionary setObject:@"IL" forKey:(NSString *)kABPersonAddressStateKey];
    [addressDictionary setObject:@"60654" forKey:(NSString *)kABPersonAddressZIPKey];
    ABMultiValueAddValueAndLabel(multiAddress, (__bridge CFTypeRef)(addressDictionary), kABWorkLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonAddressProperty, multiAddress,&error);
    CFRelease(multiAddress);
*/
    ABAddressBookAddRecord(iPhoneAddressBook, newPerson, &error);
    ABAddressBookSave(iPhoneAddressBook, &error);
    CFRelease(multiPhone);
    if (iPhoneAddressBook) {
        CFRelease(iPhoneAddressBook);
    }
    if (error != NULL)
    {
        NSLog(@"Danger Will Robinson! Danger!");
    }else{
        [self showAlert:@"联系人保存成功"];
    }
}

- (void)showAlert:(NSString *)title{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}
@end
