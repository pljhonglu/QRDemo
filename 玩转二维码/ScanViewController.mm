//
//  ScanViewController.m
//  玩转二维码
//
//  Created by pljhonglu on 13-11-11.
//  Copyright (c) 2013年 pljhonglu. All rights reserved.
//

#import "ScanViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <TwoDDecoderResult.h>
#import <QRCodeReader.h>
#import "ScanResultViewController.h"
#import "HistoryViewController.h"



@interface ScanViewController ()

@end

@implementation ScanViewController
{

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
    [self createNavWithTitle:@"扫描二维码" type:NavRight_HistoryItem action:@selector(historyBtnClicked)];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"4ebe108c056979016000018b.jpg"] ];
    

    if (![self isCameraAvailable]) {
        [self showAlert:@"您没有可用的摄像头"];
        //相册选择 button
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(50, 150, 200, 30);
        [button setTitle:@"从相册中选择" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pressPhotoLibraryButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        return;
    }
    [self initCapture];
    
    UIColor *bgColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 35, self.view.frame.size.height)];
    leftView.backgroundColor = bgColor;
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(35, 0, 250, 20)];
    topView.backgroundColor = bgColor;
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(285, 0, 35, self.view.frame.size.height)];
    rightView.backgroundColor = bgColor;
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(35, 270, 250, self.view.frame.size.height-270)];
    bottomView.backgroundColor = bgColor;
    [self.view addSubview:leftView];
    [self.view addSubview:topView];
    [self.view addSubview:rightView];
    [self.view addSubview:bottomView];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(35, 20, 250, 250)];
    imageView.image = [UIImage imageNamed:@"scan_border.png"];
    [self.view addSubview:imageView];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 310, 320, 30)];
    lable.backgroundColor = [UIColor clearColor];
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:15];
    lable.text = @"调整距离，使二维码图像清晰";
    [self.view addSubview:lable];

}

//点击相册选择后调用
- (void)pressPhotoLibraryButton:(UIButton *)button
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:^{
        self.isScanning = NO;
        [self.captureSession stopRunning];
    }];
}
#pragma mark action
- (void)historyBtnClicked{
    HistoryViewController *vc = [[HistoryViewController alloc]init];
    vc.type = ScanHistory;
    vc.isMainView = NO;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];

    [self presentViewController:nav animated:YES completion:nil];
//    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pressCancelButton:(UIButton *)button
{
    self.isScanning = NO;
    [self.captureSession stopRunning];
}

- (void)viewWillAppear:(BOOL)animated{
    self.isScanning = YES;
    [self.captureSession startRunning];
}
-(void)viewDidDisappear:(BOOL)animated{
    self.isScanning = NO;
    [self.captureSession stopRunning];    
}
- (void)initCapture
{
//#if HAS_AVFF
    
    self.captureSession = [[AVCaptureSession alloc] init];
    
    AVCaptureDevice* inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
    [self.captureSession addInput:captureInput];
    
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    [captureOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    NSString* key = (NSString *)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    [self.captureSession addOutput:captureOutput];
    
    NSString* preset = 0;
    if (NSClassFromString(@"NSOrderedSet") && // Proxy for "is this iOS 5" ...
        [UIScreen mainScreen].scale > 1 &&
        [inputDevice
         supportsAVCaptureSessionPreset:AVCaptureSessionPresetiFrame960x540]) {
            // NSLog(@"960");
            preset = AVCaptureSessionPresetiFrame960x540;
        }
    if (!preset) {
        // NSLog(@"MED");
        preset = AVCaptureSessionPresetMedium;
    }
    self.captureSession.sessionPreset = preset;
    
    if (!self.captureVideoPreviewLayer) {
        self.captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    }
    // NSLog(@"prev %p %@", self.prevLayer, self.prevLayer);
    self.captureVideoPreviewLayer.frame = self.view.bounds;
    self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer: self.captureVideoPreviewLayer];
    
    self.isScanning = YES;
    [self.captureSession startRunning];
//#endif
}

// 判断设备是否有摄像头
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

-(UIImage *)getSubImage:(UIImage *)theview frame:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(theview.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (!colorSpace)
    {
        NSLog(@"CGColorSpaceCreateDeviceRGB failure");
        return nil;
    }
    
    // Get the base address of the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // Get the data size for contiguous planes of the pixel buffer.
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    
    // Create a Quartz direct-access data provider that uses data we supply
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize,
                                                              NULL);
    // Create a bitmap image from data supplied by our data provider
    CGImageRef cgImage =
    CGImageCreate(width,
                  height,
                  8,
                  32,
                  bytesPerRow,
                  colorSpace,
                  kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little,
                  provider,
                  NULL,
                  true,
                  kCGRenderingIntentDefault);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    // Create and return an image object representing the specified Quartz image
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    return image;
}

- (void)decodeImage:(UIImage *)image
{
    NSMutableSet *qrReader = [[NSMutableSet alloc] init];
    QRCodeReader *qrcoderReader = [[QRCodeReader alloc] init];
    [qrReader addObject:qrcoderReader];

    Decoder *decoder = [[Decoder alloc] init];
    decoder.delegate = self;
    decoder.readers = qrReader;
    [decoder decodeImage:image];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];

//    获取到的图片是横向的，所以 x 为20，y 为25，但是为什么是宽高是500？难道是视网膜屏幕？
    image = [self getSubImage:image frame:CGRectMake(20, 35, 500, 500)];
    
    [self decodeImage:image];
}
//相册选择的代理方法
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __block UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:YES completion:^{
//        image = [self getSubImage:image frame:CGRectMake(35, 20, 250, 250)];

        [self decodeImage:image];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.isScanning = YES;
        [self.captureSession startRunning];
    }];
}

#pragma mark - DecoderDelegate

- (void)decoder:(Decoder *)decoder didDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset withResult:(TwoDDecoderResult *)result
{
    self.isScanning = NO;
    [self.captureSession stopRunning];
    
    ScanResultViewController *vc = [[ScanResultViewController alloc]init];
//    vc.image = subset;
    vc.result = result.text;
//    NSLog(@"%@",result.points);
    NSArray *array = result.points;
    
    //切出来这个二维码
    CGPoint RTpoint = [((NSValue *)[array objectAtIndex:2]) CGPointValue];
    CGPoint LTpoint = [((NSValue *)[array objectAtIndex:1]) CGPointValue];
    CGPoint LBpoint = [((NSValue *)[array objectAtIndex:0]) CGPointValue];
    CGFloat x = RTpoint.x>LTpoint.x? LTpoint.x:RTpoint.x;
    x = x>LBpoint.x? LBpoint.x:x;
    CGFloat y = RTpoint.y>LTpoint.y? LTpoint.y:RTpoint.y;
    y = y>LBpoint.y? LBpoint.y:y;
    
    CGFloat x1 = RTpoint.x<LTpoint.x? LTpoint.x:RTpoint.x;
    x1 = x1<LBpoint.x? LBpoint.x:x1;
    CGFloat y1 = RTpoint.y<LTpoint.y? LTpoint.y:RTpoint.y;
    y1 = y1<LBpoint.y? LBpoint.y:y1;
    
    CGRect rect = CGRectMake(x-50, y-50, x1-x+100, y1-y+100);
//    NSLog(@"%@",NSStringFromCGRect(rect));
    vc.image = [self getSubImage:subset frame:rect];
    
    
    [self.navigationController pushViewController:vc animated:YES];
//    NSLog(@"resault = %@",result.text);
}

- (void)decoder:(Decoder *)decoder failedToDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset reason:(NSString *)reason
{
    
    if (!self.isScanning) {
        [self showAlert:@"没有发现二维码"];
    }
}
- (void)showAlert:(NSString *)title{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}


#pragma mark - alertView delegate
- (void)alertViewCancel:(UIAlertView *)alertView{
    NSLog(@"cancel 点击");
}
@end
