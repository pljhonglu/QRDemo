//
//  DetailViewController.m
//  玩转二维码
//
//  Created by pljhonglu on 13-11-13.
//  Copyright (c) 2013年 pljhonglu. All rights reserved.
//

#import "DetailViewController.h"
#import "NSString+Additional.h"
#import "QRCodeGenerator.h"
#import "DataManager.h"


@interface DetailViewController ()

@end

@implementation DetailViewController
{
    UIImage *_QRImage;
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

    [self createShareNavWithTitle:@"二维码详情" action:@selector(shareBtnClick)];
    
    if (_model == nil) {
        _QRImage = [QRCodeGenerator qrImageForString:_string imageSize:170];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDate *date = [NSDate date];
            DataModel *model = [[DataModel alloc]init];
            model.type = _type;
            model.content = _string;
            model.image = _QRImage;
            //        model.imagePath = path;
            model.date = date;
            
            [[DataManager shareDataManager] addDataToCreTable:model];
        });
    }else{
        _string = _model.content;
        _type = _model.type;
        _QRImage = _model.image;
    }
    
    
    
    UIImageView *BGview = [[UIImageView alloc]initWithFrame:CGRectMake(70, 5, 180, 180)];
    BGview.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 170, 170)];
    imageView.image = _QRImage;
    [BGview addSubview:imageView];
    [self.view addSubview:BGview];
    
    UITextView *view = [[UITextView alloc]initWithFrame:CGRectMake(10, 195, 300, 80)];
    view.editable = NO;
    view.text = _string;
    [self.view addSubview:view];
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 285, 300, 50)];
    [button setImage:[UIImage imageNamed:@"detail_btn_nor.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"detail_btn_pre.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(saveQR) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

}

- (void)saveQR{
    NSLog(@"保存到相册");
    UIImageWriteToSavedPhotosAlbum(_QRImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);

}
- (void)shareBtnClick{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"通过短息",@"通过邮件", nil];
    [actionSheet showInView:self.view];
}

// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"分享点击 %d",buttonIndex);
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://800888"]];
    }else if (buttonIndex == 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://admin@hzlzh.com"]];
    }
}
@end
